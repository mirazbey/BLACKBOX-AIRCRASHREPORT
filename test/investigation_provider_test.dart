import 'package:chasethecase/providers/investigation_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('forensic frame unlocks evidence and updates timeline', () {
    final provider = InvestigationProvider();
    final clip = provider.forensicClips.first;

    provider.captureForensicFrame(clip);

    expect(provider.currentTimeSeconds, clip.offsetSeconds);
    expect(provider.discoveredEvidenceIds, contains(clip.revealsEvidenceId));
    expect(
      provider.boardPins.where(
        (pin) => pin.evidenceId == clip.revealsEvidenceId,
      ),
      hasLength(1),
    );
  });
}
