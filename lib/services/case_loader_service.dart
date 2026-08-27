import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/case_model.dart';
import '../models/event_axis_model.dart';
import '../models/evidence_model.dart';
import '../models/causal_graph_model.dart';

class CasePackage {
  final CaseBundle manifest;
  final EventAxis eventAxis;
  final List<EvidenceNode> evidenceNodes;
  final List<EvidenceRelation> evidenceRelations;
  final List<dynamic> contradictions;
  final List<dynamic> hypotheses;
  final CausalGraph causalGraph;
  final Map<String, dynamic> evaluationRules;
  final Map<String, dynamic> accessPolicy;

  const CasePackage({
    required this.manifest,
    required this.eventAxis,
    required this.evidenceNodes,
    required this.evidenceRelations,
    required this.contradictions,
    required this.hypotheses,
    required this.causalGraph,
    required this.evaluationRules,
    required this.accessPolicy,
  });
}

class CaseLoaderService {
  static Future<CasePackage?> loadCaseBundleFromAssets(String caseFolder) async {
    try {
      // 1. Manifest & Case Info
      final manifestRaw = await rootBundle.loadString('$caseFolder/manifest.json');
      final manifestJson = jsonDecode(manifestRaw) as Map<String, dynamic>;

      final flightRaw = await rootBundle.loadString('$caseFolder/flight.json');
      final flightJson = jsonDecode(flightRaw) as Map<String, dynamic>;

      final entitiesRaw = await rootBundle.loadString('$caseFolder/entities.json');
      final entitiesJson = jsonDecode(entitiesRaw) as Map<String, dynamic>;

      final aircraftJson = entitiesJson['aircraft'] as Map<String, dynamic>;

      final bundle = CaseBundle(
        id: manifestJson['case_id'] as String,
        code: manifestJson['code'] as String,
        title: manifestJson['title'] as String,
        subtitle: manifestJson['subtitle'] as String,
        difficulty: manifestJson['difficulty'] == 'hard' ? CaseDifficulty.hard : CaseDifficulty.medium,
        durationMinutes: manifestJson['duration_minutes'] as int? ?? 20,
        isHistorical: true,
        aircraft: AircraftProfile(
          model: aircraftJson['model'] as String? ?? 'Airbus A330',
          tailNumber: aircraftJson['tail_number'] as String? ?? 'F-GZCP',
          engines: aircraftJson['engines'] as String? ?? '2x Turbofan',
          operatorName: flightJson['callsign'] as String? ?? 'Air France',
          avionicsSuite: aircraftJson['flight_control_law'] as String? ?? 'Fly-By-Wire Normal Law',
        ),
        flight: FlightProfile(
          flightNumber: flightJson['flight_number'] as String? ?? 'AF-447',
          departure: flightJson['departure_name'] as String? ?? 'Rio (SBGL)',
          destination: flightJson['destination_name'] as String? ?? 'Paris (LFPG)',
          phaseOfFlight: flightJson['route_segment'] as String? ?? 'FL350 Seyir',
          soulsOnBoard: 228,
          lastKnownAltitude: 'FL350',
          locationDescription: 'Atlantik Okyanusu',
          initialSummary: manifestJson['subtitle'] as String? ?? '',
        ),
      );

      // 2. Event Axis
      final eventAxisRaw = await rootBundle.loadString('$caseFolder/event_axis.json');
      final eventAxisJson = jsonDecode(eventAxisRaw) as Map<String, dynamic>;
      final markersList = (eventAxisJson['markers'] as List<dynamic>).map((m) {
        return EventMarker(
          caseTimeSeconds: m['case_time_s'] as int,
          timestampUtc: m['timestamp_utc'] as String,
          track: m['track'] as String,
          label: m['label'] as String,
          linkedEvidenceId: m['linked_evidence_id'] as String?,
          rolesNotified: (m['roles_notified'] as List<dynamic>).map((r) => r as int).toList(),
        );
      }).toList();

      final eventAxis = EventAxis(
        epochUtc: eventAxisJson['epoch_utc'] as String,
        totalDurationSeconds: eventAxisJson['total_duration_seconds'] as int,
        markers: markersList,
      );

      // 3. Evidence & Relations
      final evidenceRaw = await rootBundle.loadString('$caseFolder/investigation/evidence.json');
      final evidenceJson = jsonDecode(evidenceRaw) as Map<String, dynamic>;

      final List<EvidenceNode> nodes = (evidenceJson['nodes'] as List<dynamic>).map((n) {
        return EvidenceNode(
          id: n['id'] as String,
          type: _parseEvidenceType(n['source_tag'] as String?),
          title: n['title'] as String,
          description: n['description'] as String,
          visibleToRoles: const [1, 2, 3, 4, 5],
          sourceRef: n['source_tag'] as String? ?? 'fdr',
        );
      }).toList();

      final List<EvidenceRelation> relations = (evidenceJson['relations'] as List<dynamic>).map((r) {
        return EvidenceRelation(
          fromEvidenceId: r['from'] as String,
          toEvidenceId: r['to'] as String,
          type: _parseRelationType(r['type'] as String),
          strength: (r['strength'] as num).toDouble(),
          reason: r['explanation'] as String?,
        );
      }).toList();

      // 4. Contradictions & Hypotheses
      final contradictionsRaw = await rootBundle.loadString('$caseFolder/investigation/contradictions.json');
      final contradictionsJson = jsonDecode(contradictionsRaw) as List<dynamic>;

      final hypothesesRaw = await rootBundle.loadString('$caseFolder/investigation/hypotheses.json');
      final hypothesesJson = jsonDecode(hypothesesRaw) as List<dynamic>;

      // 5. Causal Graph (DAG)
      final causalRaw = await rootBundle.loadString('$caseFolder/investigation/causal_graph.json');
      final causalJson = jsonDecode(causalRaw) as Map<String, dynamic>;
      final dagNodes = (causalJson['nodes'] as List<dynamic>).map((nd) {
        return CausalNode(
          id: nd['id'] as String,
          category: _parseCausalCategory(nd['type'] as String),
          title: nd['label'] as String,
          description: nd['label'] as String,
          requiredEvidenceIds: const [],
          pointsWeight: 20,
        );
      }).toList();

      final causalGraph = CausalGraph(
        nodes: dagNodes,
        edges: const [],
      );

      // 6. Evaluation Rules & Access Policy
      final evalRaw = await rootBundle.loadString('$caseFolder/investigation/evaluation.json');
      final evalJson = jsonDecode(evalRaw) as Map<String, dynamic>;

      final accessRaw = await rootBundle.loadString('$caseFolder/roles/access_policy.json');
      final accessJson = jsonDecode(accessRaw) as Map<String, dynamic>;

      return CasePackage(
        manifest: bundle,
        eventAxis: eventAxis,
        evidenceNodes: nodes,
        evidenceRelations: relations,
        contradictions: contradictionsJson,
        hypotheses: hypothesesJson,
        causalGraph: causalGraph,
        evaluationRules: evalJson,
        accessPolicy: accessJson,
      );
    } catch (e) {
      debugPrint('Error loading case package from $caseFolder: $e');
      return null;
    }
  }

  static EvidenceType _parseEvidenceType(String? tag) {
    switch (tag?.toLowerCase()) {
      case 'cvr':
        return EvidenceType.audioSegment;
      case 'maintenance':
      case 'mel':
        return EvidenceType.maintenanceRecord;
      case 'environment':
      case 'metar':
        return EvidenceType.environmentRecord;
      case 'crm':
      case 'testimony':
        return EvidenceType.testimony;
      case 'fdr':
      default:
        return EvidenceType.telemetryAnomaly;
    }
  }

  static RelationType _parseRelationType(String typeStr) {
    switch (typeStr.toUpperCase()) {
      case 'CONTRADICTS':
        return RelationType.contradicts;
      case 'REFUTES':
        return RelationType.refutes;
      case 'SUPPORTS':
      default:
        return RelationType.supports;
    }
  }

  static CausalCategory _parseCausalCategory(String typeStr) {
    switch (typeStr.toUpperCase()) {
      case 'TRIGGER':
        return CausalCategory.trigger;
      case 'SYSTEM_ERROR':
        return CausalCategory.systemFault;
      case 'HUMAN_ERROR':
        return CausalCategory.humanError;
      case 'OUTCOME':
        return CausalCategory.outcome;
      case 'LATENT_MAINTENANCE':
        return CausalCategory.latentMaintenance;
      case 'ORGANIZATIONAL':
        return CausalCategory.organizational;
      case 'ENVIRONMENT':
      default:
        return CausalCategory.environment;
    }
  }
}
