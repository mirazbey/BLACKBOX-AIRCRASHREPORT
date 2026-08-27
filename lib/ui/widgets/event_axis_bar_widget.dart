import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class EventAxisBarWidget extends StatelessWidget {
  const EventAxisBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final axis = provider.eventAxis;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.surfaceBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'T+${provider.currentTimeSeconds}s (02:10:${provider.currentTimeSeconds.toString().padLeft(2, '0')})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber),
              ),
              Text(
                'SENKRON ZAMAN EKSENİ',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.amber,
              inactiveTrackColor: AppTheme.surfaceBorder,
              thumbColor: AppTheme.amber,
              overlayColor: AppTheme.amber.withAlpha(40),
              trackHeight: 3,
            ),
            child: Slider(
              value: provider.currentTimeSeconds.toDouble(),
              min: 0,
              max: axis.totalDurationSeconds.toDouble(),
              onChanged: (val) {
                provider.setTimelineCursor(val.toInt());
              },
            ),
          ),
          // Markers row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: axis.markers.map((marker) {
                final isSelected = (marker.caseTimeSeconds - provider.currentTimeSeconds).abs() <= 5;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    label: Text(
                      'T+${marker.caseTimeSeconds}s ${marker.label}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.black : AppTheme.textDim,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    backgroundColor: isSelected ? AppTheme.amber : AppTheme.surfaceAlt,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    onPressed: () {
                      provider.setTimelineCursor(marker.caseTimeSeconds);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
