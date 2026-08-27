import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum AudioFilterMode { rawCvr, voiceIsolated, alarmEnhanced }

class InteractiveWaveformWidget extends StatefulWidget {
  final int currentOffsetSeconds;
  final ValueChanged<int>? onSeek;

  const InteractiveWaveformWidget({
    super.key,
    required this.currentOffsetSeconds,
    this.onSeek,
  });

  @override
  State<InteractiveWaveformWidget> createState() => _InteractiveWaveformWidgetState();
}

class _InteractiveWaveformWidgetState extends State<InteractiveWaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _playController;
  bool isPlaying = true;
  AudioFilterMode filterMode = AudioFilterMode.voiceIsolated;

  @override
  void initState() {
    super.initState();
    _playController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _playController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _getFilterColor(), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _getFilterColor().withAlpha(40),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top OSD Header
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPlaying ? AppTheme.green : AppTheme.amber,
                  boxShadow: [
                    BoxShadow(
                      color: (isPlaying ? AppTheme.green : AppTheme.amber).withAlpha(150),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'CVR SES DALGA FORMU [${_getFilterLabel()}]',
                style: TextStyle(
                  fontSize: 10,
                  color: _getFilterColor(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Mono',
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                'T+${widget.currentOffsetSeconds}s / 240s',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.amber,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Mono',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Waveform Canvas with Animated Playhead
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final width = MediaQuery.of(context).size.width - 64;
              final fraction = (details.localPosition.dx / width).clamp(0.0, 1.0);
              final targetSec = (fraction * 240).toInt();
              widget.onSeek?.call(targetSec);
            },
            child: SizedBox(
              height: 58,
              child: AnimatedBuilder(
                animation: _playController,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(double.infinity, 58),
                    painter: _WaveformPainter(
                      currentSec: widget.currentOffsetSeconds,
                      animProgress: isPlaying ? _playController.value : 0.0,
                      filterMode: filterMode,
                      accentColor: _getFilterColor(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bottom Controls: Filters & Play/Pause
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      _playController.repeat();
                    } else {
                      _playController.stop();
                    }
                  });
                },
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: AppTheme.amber,
                  size: 26,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),

              // Filter Chips
              _buildFilterChip('SES İZOLASYONU', AudioFilterMode.voiceIsolated),
              const SizedBox(width: 6),
              _buildFilterChip('STALL ALARMI', AudioFilterMode.alarmEnhanced),
              const SizedBox(width: 6),
              _buildFilterChip('HAM KAYIT', AudioFilterMode.rawCvr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, AudioFilterMode mode) {
    final isSelected = filterMode == mode;
    return InkWell(
      onTap: () => setState(() => filterMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? _getFilterColor().withAlpha(50) : AppTheme.surfaceAlt,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? _getFilterColor() : AppTheme.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontFamily: 'IBM Plex Mono',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textDim,
          ),
        ),
      ),
    );
  }

  Color _getFilterColor() {
    switch (filterMode) {
      case AudioFilterMode.voiceIsolated:
        return AppTheme.cyan;
      case AudioFilterMode.alarmEnhanced:
        return AppTheme.red;
      case AudioFilterMode.rawCvr:
        return AppTheme.amber;
    }
  }

  String _getFilterLabel() {
    switch (filterMode) {
      case AudioFilterMode.voiceIsolated:
        return 'DSP BANDPASS 300Hz-3kHz';
      case AudioFilterMode.alarmEnhanced:
        return 'GPWS / STALL BOOST +12dB';
      case AudioFilterMode.rawCvr:
        return 'HAM 4-KANAL MANYETİK KASET';
    }
  }
}

class _WaveformPainter extends CustomPainter {
  final int currentSec;
  final double animProgress;
  final AudioFilterMode filterMode;
  final Color accentColor;

  _WaveformPainter({
    required this.currentSec,
    required this.animProgress,
    required this.filterMode,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 52;
    final barWidth = size.width / (barCount * 1.4);
    final gap = barWidth * 0.4;
    final centerY = size.height / 2;

    final progressFraction = (currentSec / 240).clamp(0.0, 1.0);
    final activeBarIndex = (progressFraction * barCount).toInt();

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);

      // Procedural height curve with heightened peaks during crash anomaly seconds (T+60 to T+180)
      final anomalyWeight = (i > 12 && i < 38) ? 1.8 : 0.8;
      final dynamicMod = sin(animProgress * 2 * pi + (i * 0.35)).abs() * 0.35;
      final baseAmp = (sin(i * 0.45).abs() * 0.6 + 0.3 + dynamicMod) * anomalyWeight;

      final barHeight = (baseAmp * (size.height / 2 - 4)).clamp(4.0, size.height / 2 - 2);

      final isPast = i <= activeBarIndex;
      final paint = Paint()
        ..color = isPast ? accentColor : AppTheme.surfaceBorder
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth;

      // Draw mirrored audio waveform
      canvas.drawLine(Offset(x, centerY - barHeight), Offset(x, centerY + barHeight), paint);
    }

    // Playhead Line
    final playheadX = progressFraction * size.width;
    final playheadPaint = Paint()
      ..color = AppTheme.amber
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(playheadX, 0), Offset(playheadX, size.height), playheadPaint);

    // Playhead top diamond badge
    final diamondPath = Path()
      ..moveTo(playheadX, 0)
      ..lineTo(playheadX - 4, 6)
      ..lineTo(playheadX + 4, 6)
      ..close();
    canvas.drawPath(diamondPath, Paint()..color = AppTheme.amber);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => true;
}
