class SubmittedFinding {
  final String categoryTitle;
  final String selectedCauseTitle;
  final List<String> linkedEvidenceIds;

  const SubmittedFinding({
    required this.categoryTitle,
    required this.selectedCauseTitle,
    required this.linkedEvidenceIds,
  });
}

class EvaluationResult {
  final int totalScore; // 0 to 100
  final int causalAccuracyScore; // 0 to 50
  final int evidenceQualityScore; // 0 to 35
  final int efficiencyScore; // 0 to 15
  final String rankTitle;
  final String summaryFeedback;
  final List<String> missedCriticalEvidences;
  final List<String> correctCauses;
  final List<String> falseTheories;

  const EvaluationResult({
    required this.totalScore,
    required this.causalAccuracyScore,
    required this.evidenceQualityScore,
    required this.efficiencyScore,
    required this.rankTitle,
    required this.summaryFeedback,
    required this.missedCriticalEvidences,
    required this.correctCauses,
    required this.falseTheories,
  });
}
