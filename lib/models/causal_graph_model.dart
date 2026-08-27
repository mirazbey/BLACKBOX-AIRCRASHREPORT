enum CausalCategory {
  environment,
  latentMaintenance,
  organizational,
  trigger,
  systemFault,
  humanError,
  outcome,
}

class CausalNode {
  final String id;
  final CausalCategory category;
  final String title;
  final String description;
  final List<String> requiredEvidenceIds;
  final int pointsWeight;

  const CausalNode({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.requiredEvidenceIds,
    this.pointsWeight = 20,
  });

  factory CausalNode.fromJson(Map<String, dynamic> json) {
    return CausalNode(
      id: json['id'] as String,
      category: CausalCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => CausalCategory.systemFault,
      ),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      requiredEvidenceIds: (json['required_evidence_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      pointsWeight: json['points_weight'] as int? ?? 20,
    );
  }
}

class CausalEdge {
  final String fromNodeId;
  final String toNodeId;
  final bool isIndirectContributor;

  const CausalEdge({
    required this.fromNodeId,
    required this.toNodeId,
    this.isIndirectContributor = false,
  });

  factory CausalEdge.fromJson(Map<String, dynamic> json) {
    return CausalEdge(
      fromNodeId: json['from'] as String,
      toNodeId: json['to'] as String,
      isIndirectContributor: json['is_indirect_contributor'] as bool? ?? false,
    );
  }
}

class CausalGraph {
  final List<CausalNode> nodes;
  final List<CausalEdge> edges;

  const CausalGraph({
    required this.nodes,
    required this.edges,
  });

  factory CausalGraph.fromJson(Map<String, dynamic> json) {
    final nList = json['nodes'] as List<dynamic>? ?? [];
    final eList = json['edges'] as List<dynamic>? ?? [];
    return CausalGraph(
      nodes: nList.map((e) => CausalNode.fromJson(e as Map<String, dynamic>)).toList(),
      edges: eList.map((e) => CausalEdge.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
