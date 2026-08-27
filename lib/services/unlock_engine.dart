import '../models/unlock_rules_model.dart';

class UnlockEngine {
  static List<String> getUnlockedTheoryIds({
    required List<TheoryUnlockRule> rules,
    required Set<String> discoveredEvidenceIds,
  }) {
    List<String> unlocked = [];
    for (final rule in rules) {
      if (rule.gateType == GateType.andGate) {
        final allPresent = rule.requiredEvidenceIds.every((id) => discoveredEvidenceIds.contains(id));
        if (allPresent) {
          unlocked.add(rule.theoryId);
        }
      } else {
        final anyPresent = rule.requiredEvidenceIds.any((id) => discoveredEvidenceIds.contains(id));
        if (anyPresent) {
          unlocked.add(rule.theoryId);
        }
      }
    }
    return unlocked;
  }
}
