import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../providers/investigation_provider.dart';

class TacticalCommsWheelWidget extends StatelessWidget {
  const TacticalCommsWheelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final presets = provider.pingPresets;
    final recentPings = provider.tacticalPings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live Incoming Ticker / Ping Banner (if any)
        if (recentPings.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.amberDim.withAlpha(80),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.emergency_rounded, color: AppTheme.amber, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '[${recentPings.last.fromRole.shortName.toUpperCase()}]: ${recentPings.last.message}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Mono',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (recentPings.last.targetTimestampSeconds != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => provider.setTimelineCursor(recentPings.last.targetTimestampSeconds!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'T+${recentPings.last.targetTimestampSeconds}s',
                        style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],

        // Quick Tactic Ping Bar / Action Chips
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  avatar: const Icon(Icons.send_rounded, size: 12, color: AppTheme.amber),
                  label: Text(
                    preset.title,
                    style: const TextStyle(fontSize: 10, fontFamily: 'IBM Plex Mono', color: AppTheme.textPrimary),
                  ),
                  backgroundColor: AppTheme.surfaceAlt,
                  side: const BorderSide(color: AppTheme.surfaceBorder),
                  onPressed: () {
                    provider.sendTacticalPing(
                      directiveType: preset.type,
                      message: preset.defaultMessage,
                      toRole: preset.recommendedTargetRole,
                      targetTimestampSeconds: provider.currentTimeSeconds,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Telsiz Bildirimi Gönderildi: "${preset.title}"'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppTheme.surfaceAlt,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
