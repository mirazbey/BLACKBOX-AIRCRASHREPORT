import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class CvrAudioPlayerWidget extends StatefulWidget {
  const CvrAudioPlayerWidget({super.key});

  @override
  State<CvrAudioPlayerWidget> createState() => _CvrAudioPlayerWidgetState();
}

class _CvrAudioPlayerWidgetState extends State<CvrAudioPlayerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _waveAnimController;

  @override
  void initState() {
    super.initState();
    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final segments = provider.audioSegments;

    return Column(
      children: [
        // Top Simulated Audio Spectrogram Visualizer
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.cyanDim),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.graphic_eq, color: AppTheme.cyan, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'CVR 4-KANAL AKUSTİK FREKANS SPEKTROGRAMI',
                    style: TextStyle(fontSize: 10, color: AppTheme.cyan, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                  ),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.green,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('PLAYING', style: TextStyle(fontSize: 8, color: AppTheme.green, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              // Animated Spectrum Bars
              AnimatedBuilder(
                animation: _waveAnimController,
                builder: (context, _) {
                  return SizedBox(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(28, (i) {
                        final randomHeight = 6 + (sin(_waveAnimController.value * 2 * pi + i * 0.4).abs() * 26);
                        final isHighAlert = i > 18;
                        return Container(
                          width: 6,
                          height: randomHeight,
                          decoration: BoxDecoration(
                            color: isHighAlert ? AppTheme.red : AppTheme.cyan,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          ),
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
