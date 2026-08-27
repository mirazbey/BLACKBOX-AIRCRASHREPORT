enum EvidenceType {
  telemetryAnomaly,
  audioSegment,
  maintenanceRecord,
  environmentRecord,
  testimony,
  fieldAnalysis,
  derivedReconstruction,
}

enum RelationType { supports, contradicts, refutes }

class EvidenceNode {
  final String id;
  final EvidenceType type;
  final String title;
  final String description;
  final List<int> visibleToRoles;
  final String sourceRef;
  final String confidence; // CONFIRMED, UNVERIFIED, CONTRADICTED

  const EvidenceNode({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.visibleToRoles,
    required this.sourceRef,
    this.confidence = 'CONFIRMED',
  });

  factory EvidenceNode.fromJson(Map<String, dynamic> json) {
    return EvidenceNode(
      id: json['id'] as String,
      type: EvidenceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EvidenceType.telemetryAnomaly,
      ),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      visibleToRoles:
          (json['visible_to_roles'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3, 4],
      sourceRef: json['source_ref'] as String? ?? '',
      confidence: json['confidence'] as String? ?? 'CONFIRMED',
    );
  }
}

class EvidenceRelation {
  final String fromEvidenceId;
  final String toEvidenceId;
  final RelationType type;
  final double strength; // 0.0 to 1.0
  final String? reason;

  const EvidenceRelation({
    required this.fromEvidenceId,
    required this.toEvidenceId,
    required this.type,
    this.strength = 1.0,
    this.reason,
  });

  factory EvidenceRelation.fromJson(Map<String, dynamic> json) {
    return EvidenceRelation(
      fromEvidenceId: json['from'] as String,
      toEvidenceId: json['to'] as String,
      type: RelationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RelationType.supports,
      ),
      strength: (json['strength'] as num?)?.toDouble() ?? 1.0,
      reason: json['reason'] as String?,
    );
  }
}
