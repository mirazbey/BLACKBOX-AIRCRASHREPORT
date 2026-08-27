import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

enum TacticalSoundEffect {
  stallAlarm,
  radioSquelch,
  pinClick,
  threadConnected,
  contradictionAlert,
  gavelSeal,
  radarBeep,
}

class AudioHapticService {
  static bool soundEnabled = true;
  static bool hapticsEnabled = true;

  static void triggerFeedback(TacticalSoundEffect effect) {
    if (hapticsEnabled) {
      switch (effect) {
        case TacticalSoundEffect.contradictionAlert:
        case TacticalSoundEffect.stallAlarm:
          HapticFeedback.heavyImpact();
          break;
        case TacticalSoundEffect.gavelSeal:
          HapticFeedback.mediumImpact();
          break;
        case TacticalSoundEffect.radioSquelch:
        case TacticalSoundEffect.threadConnected:
          HapticFeedback.selectionClick();
          break;
        case TacticalSoundEffect.pinClick:
        case TacticalSoundEffect.radarBeep:
          HapticFeedback.lightImpact();
          break;
      }
    }

    if (soundEnabled) {
      // Audio cue feedback logging & sound trigger
      debugPrint('[AUDIO FX]: Triggering ${effect.name.toUpperCase()}');
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void playStallWarning() {
    triggerFeedback(TacticalSoundEffect.stallAlarm);
  }

  static void playRadioClick() {
    triggerFeedback(TacticalSoundEffect.radioSquelch);
  }

  static void playPinDrop() {
    triggerFeedback(TacticalSoundEffect.pinClick);
  }

  static void playContradictionFound() {
    triggerFeedback(TacticalSoundEffect.contradictionAlert);
  }

  static void playReportSealed() {
    triggerFeedback(TacticalSoundEffect.gavelSeal);
  }
}
