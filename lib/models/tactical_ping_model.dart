import 'case_model.dart';

enum DirectiveType {
  urgentTimeSync,
  flagContradiction,
  requestInterrogation,
  requestMaintenanceCheck,
  requestFlirEnhance,
  confirmHypothesis,
}

class TacticalPing {
  final String id;
  final InvestigatorRole fromRole;
  final InvestigatorRole? toRole; // null = Broadcast to all
  final DirectiveType directiveType;
  final String message;
  final int? targetTimestampSeconds;
  final String? linkedEvidenceId;
  final DateTime createdAt;

  const TacticalPing({
    required this.id,
    required this.fromRole,
    this.toRole,
    required this.directiveType,
    required this.message,
    this.targetTimestampSeconds,
    this.linkedEvidenceId,
    required this.createdAt,
  });

  String get typeLabel {
    switch (directiveType) {
      case DirectiveType.urgentTimeSync:
        return '🚨 ACİL ZAMAN SENKRONU';
      case DirectiveType.flagContradiction:
        return '🔍 ÇELİŞKİ TESPİTİ';
      case DirectiveType.requestInterrogation:
        return '👤 SORGU TALEBİ';
      case DirectiveType.requestMaintenanceCheck:
        return '🛠️ BAKIM KONTROLÜ İSTE';
      case DirectiveType.requestFlirEnhance:
        return '📹 FLIR ODAKLANMA İSTE';
      case DirectiveType.confirmHypothesis:
        return '✅ HİPOTEZ ONAYLANDI';
    }
  }
}

class PingPreset {
  final DirectiveType type;
  final String title;
  final String defaultMessage;
  final InvestigatorRole? recommendedTargetRole;

  const PingPreset({
    required this.type,
    required this.title,
    required this.defaultMessage,
    this.recommendedTargetRole,
  });
}
