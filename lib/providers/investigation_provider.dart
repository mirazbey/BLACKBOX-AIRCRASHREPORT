import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/case_model.dart';
import '../models/event_axis_model.dart';
import '../models/source_models.dart';
import '../models/evidence_model.dart';
import '../models/causal_graph_model.dart';
import '../models/unlock_rules_model.dart';
import '../models/investigation_state.dart';
import '../models/evaluation_model.dart';
import '../models/forensic_clip_model.dart';
import '../models/interrogation_model.dart';
import '../models/tactical_ping_model.dart';
import '../models/cinematic_debrief_model.dart';
import '../services/case_repository.dart';
import '../services/evaluation_engine.dart';
import '../services/unlock_engine.dart';

class InvestigationProvider extends ChangeNotifier {
  CaseBundle activeCase = CaseRepository.sampleCaseManifest;
  InvestigatorRole currentRole = InvestigatorRole.telemetryFdr;
  EventAxis eventAxis = CaseRepository.sampleEventAxis;

  List<FdrRecord> fdrRecords = CaseRepository.sampleFdrRecords;
  List<AudioSegment> audioSegments = CaseRepository.sampleAudioSegments;
  List<MaintenanceLog> maintenanceLogs = CaseRepository.sampleMaintenanceLogs;
  EnvironmentReport environmentReport = CaseRepository.sampleEnvironmentReport;
  List<SuspectProfile> suspects = CaseRepository.sampleSuspects;

  List<EvidenceNode> allEvidences = CaseRepository.sampleEvidenceNodes;
  List<EvidenceRelation> allRelations = CaseRepository.sampleEvidenceRelations;
  CausalGraph groundTruthGraph = CaseRepository.sampleGroundTruthCausalGraph;
  List<TheoryUnlockRule> theoryRules = CaseRepository.sampleTheoryRules;
  List<ForensicClip> forensicClips = CaseRepository.sampleForensicClips;
  List<PingPreset> pingPresets = CaseRepository.samplePingPresets;
  List<CinematicReconstructionScene> reconstructionScenes = CaseRepository.sampleReconstructionScenes;
  List<OperatorScoreDetail> operatorScores = [];

  // Active State
  int currentTimeSeconds = 66; // Defaults to anomaly T+66s
  Set<String> discoveredEvidenceIds = {};
  List<BoardPin> boardPins = [];
  List<BoardConnection> boardConnections = [];
  List<String> unlockedTheories = [];
  List<TacticalPing> tacticalPings = [];
  bool isRadioActive = false;
  EvaluationResult? lastEvaluationResult;

  InvestigationProvider() {
    _initDefaultState();
  }

  void _initDefaultState() {
    // Initial discovery
    discoveredEvidenceIds.add('EVD_FDR_SPD_DROP');
    boardPins.add(
      const BoardPin(
        pinId: 'PIN_1',
        evidenceId: 'EVD_FDR_SPD_DROP',
        title: '02:10:06 Hız Göstergesi Ani Düşüşü',
        sourceTag: 'FDR Telemetri',
        position: Offset(40, 80),
        ownerRoleIndex: 1,
      ),
    );
    _recalculateUnlocks();
  }

  void switchRole(InvestigatorRole newRole) {
    currentRole = newRole;
    notifyListeners();
  }

  void setTimelineCursor(int seconds) {
    currentTimeSeconds = seconds;
    notifyListeners();
  }

  void captureForensicFrame(ForensicClip clip) {
    currentTimeSeconds = clip.offsetSeconds;
    if (clip.revealsEvidenceId != null && !discoveredEvidenceIds.contains(clip.revealsEvidenceId)) {
      discoverEvidence(clip.revealsEvidenceId!);
    } else {
      notifyListeners();
    }
  }

  void discoverEvidence(String evidenceId) {
    if (!discoveredEvidenceIds.contains(evidenceId)) {
      discoveredEvidenceIds.add(evidenceId);
      final ev = allEvidences.where((e) => e.id == evidenceId).firstOrNull;
      if (ev != null) {
        final pinId = const Uuid().v4().substring(0, 6);
        final x = 40.0 + (boardPins.length % 3) * 140.0;
        final y = 80.0 + (boardPins.length ~/ 3) * 130.0;
        boardPins.add(
          BoardPin(
            pinId: pinId,
            evidenceId: ev.id,
            title: ev.title,
            sourceTag: _evidenceSourceLabel(ev.type),
            position: Offset(x, y),
            ownerRoleIndex: currentRole.roleIndex,
          ),
        );
      }
      _recalculateUnlocks();
      notifyListeners();
    }
  }

  String _evidenceSourceLabel(EvidenceType type) {
    return switch (type) {
      EvidenceType.telemetryAnomaly => 'FDR Telemetri',
      EvidenceType.audioSegment => 'CVR Ses Kaydı',
      EvidenceType.maintenanceRecord => 'Bakım Kaydı',
      EvidenceType.environmentRecord => 'Meteoroloji',
      EvidenceType.testimony => 'Tanık İfadesi',
      EvidenceType.fieldAnalysis => 'Enkaz Analizi',
      EvidenceType.derivedReconstruction => 'Türetilmiş Görsel',
    };
  }

  void updatePinPosition(String pinId, Offset newPos) {
    final index = boardPins.indexWhere((p) => p.pinId == pinId);
    if (index != -1) {
      boardPins[index] = boardPins[index].copyWith(position: newPos);
      notifyListeners();
    }
  }

  void connectPins(String fromPinId, String toPinId) {
    if (fromPinId == toPinId) return;
    final exists = boardConnections.any(
      (c) =>
          (c.fromPinId == fromPinId && c.toPinId == toPinId) ||
          (c.fromPinId == toPinId && c.toPinId == fromPinId),
    );
    if (!exists) {
      final fromPin = boardPins.firstWhere((p) => p.pinId == fromPinId);
      final toPin = boardPins.firstWhere((p) => p.pinId == toPinId);

      // Check relation in database
      final rel = allRelations
          .where(
            (r) =>
                (r.fromEvidenceId == fromPin.evidenceId &&
                    r.toEvidenceId == toPin.evidenceId) ||
                (r.fromEvidenceId == toPin.evidenceId &&
                    r.toEvidenceId == fromPin.evidenceId),
          )
          .firstOrNull;

      final relType = rel?.type == RelationType.contradicts
          ? 'CONTRADICTS'
          : 'SUPPORTS';

      boardConnections.add(
        BoardConnection(
          connectionId: const Uuid().v4().substring(0, 6),
          fromPinId: fromPinId,
          toPinId: toPinId,
          relationType: relType,
        ),
      );
      notifyListeners();
    }
  }

  void _recalculateUnlocks() {
    unlockedTheories = UnlockEngine.getUnlockedTheoryIds(
      rules: theoryRules,
      discoveredEvidenceIds: discoveredEvidenceIds,
    );
  }

  void setRadioActive(bool active) {
    isRadioActive = active;
    notifyListeners();
  }

  void sendTacticalPing({
    required DirectiveType directiveType,
    required String message,
    InvestigatorRole? toRole,
    int? targetTimestampSeconds,
    String? linkedEvidenceId,
  }) {
    final ping = TacticalPing(
      id: const Uuid().v4().substring(0, 6),
      fromRole: currentRole,
      toRole: toRole,
      directiveType: directiveType,
      message: message,
      targetTimestampSeconds: targetTimestampSeconds,
      linkedEvidenceId: linkedEvidenceId,
      createdAt: DateTime.now(),
    );
    tacticalPings.add(ping);
    notifyListeners();
  }

  void submitInvestigationReport(List<SubmittedFinding> findings) {
    lastEvaluationResult = EvaluationEngine.evaluateInvestigation(
      submittedFindings: findings,
      groundTruthGraph: groundTruthGraph,
      pinnedEvidenceIds: discoveredEvidenceIds,
      totalDiscoveredEvidences: discoveredEvidenceIds.length,
    );
    operatorScores = CaseRepository.getSampleOperatorScores(
      lastEvaluationResult?.totalScore ?? 85,
    );
    notifyListeners();
  }
}
