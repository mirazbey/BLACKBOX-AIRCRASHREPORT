import 'case_model.dart';

class OperatorScoreDetail {
  final InvestigatorRole role;
  final String operatorCode;
  final String specialistTitle;
  final int earnedXp;
  final int accuracyPercentage;
  final bool isMvp;
  final String keyDiscoveryTitle;
  final List<String> unlockedBadges;

  const OperatorScoreDetail({
    required this.role,
    required this.operatorCode,
    required this.specialistTitle,
    required this.earnedXp,
    required this.accuracyPercentage,
    required this.isMvp,
    required this.keyDiscoveryTitle,
    required this.unlockedBadges,
  });
}

class CinematicReconstructionScene {
  final int sequenceOrder;
  final String timeUtc;
  final String timeOffsetLabel;
  final InvestigatorRole primaryOperatorRole;
  final String stageTitle;
  final String headline;
  final String description;
  final String mediaAssetOrSceneType; // 'flir_ice', 'cctv_pull', 'pfd_stall', 'mel_log', 'impact_3d'
  final String audioVoiceOver;
  final String swissCheeseHoleTitle;

  const CinematicReconstructionScene({
    required this.sequenceOrder,
    required this.timeUtc,
    required this.timeOffsetLabel,
    required this.primaryOperatorRole,
    required this.stageTitle,
    required this.headline,
    required this.description,
    required this.mediaAssetOrSceneType,
    required this.audioVoiceOver,
    required this.swissCheeseHoleTitle,
  });
}
