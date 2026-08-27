import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';
import 'interactive_waveform_widget.dart';
import 'cvr_spectrogram_widget.dart';

class CvrAudioPlayerWidget extends StatelessWidget {
  const CvrAudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final segments = provider.audioSegments;

    return Column(
      children: [
        // Interactive Waveform Audio Visualizer
        InteractiveWaveformWidget(
          currentOffsetSeconds: provider.currentTimeSeconds,
          onSeek: (newSec) => provider.setTimelineCursor(newSec),
        ),

        // 2D Spectrogram Waterfall & DSP Filter
        CvrSpectrogramWidget(
          currentOffsetSeconds: provider.currentTimeSeconds,
          onSeek: (newSec) => provider.setTimelineCursor(newSec),
        ),

        // Transcripts List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: segments.length,
            itemBuilder: (context, index) {
              final seg = segments[index];
              final isNearCurrentTime = (seg.offsetSeconds - provider.currentTimeSeconds).abs() <= 10;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isNearCurrentTime ? AppTheme.surfaceBorder : AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isNearCurrentTime ? AppTheme.cyan : AppTheme.surfaceBorder,
                    width: isNearCurrentTime ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.cyanDim,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'T+${seg.offsetSeconds}s [${seg.timestampUtc}]',
                            style: const TextStyle(fontSize: 10, color: AppTheme.cyan, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          seg.channel,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        if (seg.alarms.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.redDim,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              seg.alarms.first,
                              style: const TextStyle(fontSize: 9, color: AppTheme.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      seg.speaker,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.amber,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${seg.text}"',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isNearCurrentTime ? AppTheme.textPrimary : AppTheme.textDim,
                      ),
                    ),
                    if (seg.linkedEvidenceId != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            provider.discoverEvidence(seg.linkedEvidenceId!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ses Delili Masaya Eklendi!')),
                            );
                          },
                          icon: const Icon(Icons.bookmark_add, size: 14),
                          label: const Text('DELİL OLARAK KAYDET', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.cyan,
                            side: const BorderSide(color: AppTheme.cyan),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
