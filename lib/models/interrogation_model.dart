enum StressNature {
  calmTruth,            // Sakin Doğruluk (70-80 BPM)
  traumaFlashback,      // Travmatik Korku / Flashback (130-140 BPM - DOĞRU ANLATIM AMA ŞOK)
  guiltAnxiety,         // Suçluluk / Vicdan Azabı (105-115 BPM - Gerçek İtiraf)
  deliberateDeception,  // Bilinçli Örtbas / Yalan (135-150 BPM - Verilerle Çelişen Yalan)
}

class SuspectProfile {
  final String id;
  final String name;
  final String title;
  final String organization;
  final String avatarCode;
  final String stressStatus;
  final List<DialogueQuestion> questions;

  const SuspectProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.organization,
    required this.avatarCode,
    required this.stressStatus,
    required this.questions,
  });
}

class DialogueQuestion {
  final String id;
  final String questionText;
  final String answerText;
  final String stressReaction;
  final StressNature stressNature;
  final String? contradictionHint;
  final String? unlocksEvidenceId;
  final String? unlockedEvidenceTitle;

  const DialogueQuestion({
    required this.id,
    required this.questionText,
    required this.answerText,
    required this.stressReaction,
    this.stressNature = StressNature.calmTruth,
    this.contradictionHint,
    this.unlocksEvidenceId,
    this.unlockedEvidenceTitle,
  });

  bool get isTraumaHighPulse => stressNature == StressNature.traumaFlashback;
  bool get isDeliberateLie => stressNature == StressNature.deliberateDeception;
}
