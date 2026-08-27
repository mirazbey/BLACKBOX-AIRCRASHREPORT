import '../models/evaluation_model.dart';
import '../models/causal_graph_model.dart';

class EvaluationEngine {
  static EvaluationResult evaluateInvestigation({
    required List<SubmittedFinding> submittedFindings,
    required CausalGraph groundTruthGraph,
    required Set<String> pinnedEvidenceIds,
    required int totalDiscoveredEvidences,
  }) {
    int causalPoints = 0;
    int evidencePoints = 0;
    int efficiencyPoints = 15;

    List<String> correctCauses = [];
    List<String> missedCritical = [];
    List<String> falseTheories = [];

    // 1. Causal Accuracy Evaluation (Max: 50)
    for (final trueNode in groundTruthGraph.nodes) {
      final matchingFinding = submittedFindings.where(
        (f) => f.selectedCauseTitle.toLowerCase().contains(trueNode.title.toLowerCase().split(' ').first) ||
               trueNode.title.toLowerCase().contains(f.selectedCauseTitle.toLowerCase()),
      ).firstOrNull;

      if (matchingFinding != null) {
        causalPoints += trueNode.pointsWeight;
        correctCauses.add(trueNode.title);

        // 2. Evidence Quality Evaluation (Max: 35)
        int matchingEvidenceCount = 0;
        for (final reqEvId in trueNode.requiredEvidenceIds) {
          if (matchingFinding.linkedEvidenceIds.contains(reqEvId)) {
            matchingEvidenceCount++;
          }
        }
        if (trueNode.requiredEvidenceIds.isNotEmpty) {
          evidencePoints += ((matchingEvidenceCount / trueNode.requiredEvidenceIds.length) * (35 / groundTruthGraph.nodes.length)).round();
        }
      } else {
        missedCritical.add(trueNode.title);
      }
    }

    // Check false leads submitted
    for (final finding in submittedFindings) {
      if (finding.selectedCauseTitle.toLowerCase().contains('bomba') ||
          finding.selectedCauseTitle.toLowerCase().contains('patlama')) {
        falseTheories.add('Kabin İçi Bomba Hipotezi (Enkaz Kanıtıyla Çürütüldü)');
        efficiencyPoints = (efficiencyPoints - 8).clamp(0, 15);
      }
    }

    // Cap values
    causalPoints = causalPoints.clamp(0, 50);
    evidencePoints = evidencePoints.clamp(0, 35);
    final total = causalPoints + evidencePoints + efficiencyPoints;

    String rankTitle = 'Stajyer Müfettiş';
    if (total >= 90) {
      rankTitle = 'Başmüfettiş (NTSB Lead Investigator)';
    } else if (total >= 70) {
      rankTitle = 'Kıdemli Kaza Analisti';
    } else if (total >= 50) {
      rankTitle = 'Saha Araştırmacısı';
    }

    String feedback = 'Soruşturma raporunuz NTSB standartlarında değerlendirilmiştir. ';
    if (total >= 85) {
      feedback += 'Tebrikler! Kazanın kök nedenini ve mürettebat reaksiyonunu tam isabetle tespit ettiniz.';
    } else if (total >= 65) {
      feedback += 'Kazanın ana mekanizmasını çözdünüz ancak bazı gizli bakım faktörlerini kaçırdınız.';
    } else {
      feedback += 'Soruşturmada bazı yanıltıcı ipuçlarına takıldınız ve doğrudan tetikleyiciyi tam saptayamadınız.';
    }

    return EvaluationResult(
      totalScore: total,
      causalAccuracyScore: causalPoints,
      evidenceQualityScore: evidencePoints,
      efficiencyScore: efficiencyPoints,
      rankTitle: rankTitle,
      summaryFeedback: feedback,
      missedCriticalEvidences: missedCritical,
      correctCauses: correctCauses,
      falseTheories: falseTheories,
    );
  }
}
