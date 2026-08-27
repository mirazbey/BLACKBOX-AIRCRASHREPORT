enum GateType { andGate, orGate }

class TheoryUnlockRule {
  final String theoryId;
  final String title;
  final String description;
  final GateType gateType;
  final List<String> requiredEvidenceIds;
  final String? refutedByEvidenceId;
  final bool isRedHerring;

  const TheoryUnlockRule({
    required this.theoryId,
    required this.title,
    required this.description,
    required this.gateType,
    required this.requiredEvidenceIds,
    this.refutedByEvidenceId,
    this.isRedHerring = false,
  });

  factory TheoryUnlockRule.fromJson(Map<String, dynamic> json) {
    return TheoryUnlockRule(
      theoryId: json['theory_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      gateType: (json['gate_type'] == 'OR') ? GateType.orGate : GateType.andGate,
      requiredEvidenceIds: (json['required_evidence_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      refutedByEvidenceId: json['refuted_by_evidence_id'] as String?,
      isRedHerring: json['is_red_herring'] as bool? ?? false,
    );
  }
}
