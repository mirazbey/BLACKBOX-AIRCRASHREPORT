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
  final String? unlocksEvidenceId;
  final String? unlockedEvidenceTitle;

  const DialogueQuestion({
    required this.id,
    required this.questionText,
    required this.answerText,
    required this.stressReaction,
    this.unlocksEvidenceId,
    this.unlockedEvidenceTitle,
  });
}
