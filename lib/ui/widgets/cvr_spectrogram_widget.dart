import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/audio_haptic_service.dart';

enum AudioFilterMode {
  rawHamSes,
  bandpassVocal,
  notchAvionics,
  stallIsolator,
}

class CvrSpectrogramWidget extends StatefulWidget {
  final int currentOffsetSeconds;
  final ValueChanged<int> onSeek;

  const CvrSpectrogramWidget({
    super.key,
    required this.currentOffsetSeconds,
    required this.onSeek,
  });

  @override
  State<CvrSpectrogramWidget> createState() => _CvrSpectrogramWidgetState();
}

class _CvrSpectrogramWidgetState extends State<CvrSpectrogramWidget> {
  AudioFilterMode _selectedFilter = AudioFilterMode.rawHamSes;
  bool _isPlaying = false;

  void _switchFilter(AudioFilterMode mode) {
    AudioHapticService.playPinDrop();
    setState(() {
      _selectedFilter = mode;
    });
  }

  void _togglePlay() {
    AudioHapticService.playRadioClick();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.glassBox(
        borderColor: AppTheme.cyan,
        borderWidth: 1.0,
        backgroundColor: const Color(0xFF0D1219),
        borderRadius: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Controls
          Row(
            children: [
              const Icon(Icons.graphic_eq, color: AppTheme.cyan, size: 16),
              const SizedBox(width: 6),
              const Text(
                '4-KANALLI AKUSTİK SPEKTROGRAM & DSP FİLTRE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cyan,
                  fontFamily: 'IBM Plex Mono',
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _togglePlay,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isPlaying ? AppTheme.red.withAlpha(40) : AppTheme.cyan.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _isPlaying ? AppTheme.red : AppTheme.cyan),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 12,
                        color: _isPlaying ? AppTheme.red : AppTheme.cyan,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isPlaying ? 'ÇALIYOR' : 'OYNAT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: _isPlaying ? AppTheme.red : AppTheme.cyan,
                          fontFamily: 'IBM Plex Mono',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2D Spectrogram Canvas Waterfall
          GestureDetector(
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localX = details.localPosition.dx.clamp(0.0, box.size.width - 24);
                final ratio = localX / (box.size.width - 24);
                final newSec = (60 + ratio * 180).toInt();
                widget.onSeek(newSec);
              }
            },
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF06090D),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: CustomPaint(
                painter: _SpectrogramPainter(
                  currentSec: widget.currentOffsetSeconds,
                  filterMode: _selectedFilter,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // DSP Filter Selector Row
          Row(
            children: [
              _buildFilterButton(AudioFilterMode.rawHamSes, 'HAM SES'),
              const SizedBox(width: 4),
              _buildFilterButton(AudioFilterMode.bandpassVocal, 'BANDPASS (300-3400Hz)'),
              const SizedBox(width: 4),
              _buildFilterButton(AudioFilterMode.notchAvionics, '400Hz NOTCH'),
              const SizedBox(width: 4),
              _buildFilterButton(AudioFilterMode.stallIsolator, '1200Hz STALL'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(AudioFilterMode mode, String label) {
    final isSelected = _selectedFilter == mode;
    return Expanded(
      child: InkWell(
        onTap: () => _switchFilter(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.cyan.withAlpha(40) : const Color(0xFF141A22),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isSelected ? AppTheme.cyan : AppTheme.surfaceBorder,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.cyan : AppTheme.textDim,
                fontFamily: 'IBM Plex Mono',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpectrogramPainter extends CustomPainter {
  final int currentSec;
  final AudioFilterMode filterMode;

  _SpectrogramPainter({required this.currentSec, required this.filterMode});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(42);
    final width = size.width;
    final height = size.height;

    // Draw waterfall frequency heat columns
    const columns = 60;
    final colWidth = width / columns;

    for (int col = 0; col < columns; col++) {
      final colSec = 60 + (col / columns) * 180;
      final isNearStall = colSec >= 75 && colSec <= 150;

      for (int row = 0; row < 12; row++) {
        double intensity = rand.nextDouble() * 0.4;

        if (isNearStall && (row == 4 || row == 5 || row == 8)) {
          // Stall whistle harmonic energy peak
          intensity = 0.9;
        }

        // Apply DSP filter coloring
        Color cellColor;
        switch (filterMode) {
          case AudioFilterMode.bandpassVocal:
            cellColor = (row >= 3 && row <= 8)
                ? AppTheme.cyan.withAlpha(((intensity * 0.9).clamp(0.1, 1.0) * 255).toInt())
                : Colors.blueGrey.withAlpha(25);
            break;
          case AudioFilterMode.stallIsolator:
            cellColor = (row == 4 || row == 5)
                ? AppTheme.red.withAlpha(((intensity * 1.0).clamp(0.2, 1.0) * 255).toInt())
                : Colors.black.withAlpha(75);
            break;
          case AudioFilterMode.notchAvionics:
            cellColor = (row == 2)
                ? Colors.transparent
                : AppTheme.amber.withAlpha(((intensity * 0.8).clamp(0.1, 0.9) * 255).toInt());
            break;
          case AudioFilterMode.rawHamSes:
            cellColor = isNearStall
                ? AppTheme.red.withAlpha(((intensity * 0.85).clamp(0.1, 1.0) * 255).toInt())
                : AppTheme.cyan.withAlpha(((intensity * 0.7).clamp(0.05, 0.8) * 255).toInt());
            break;
        }

        final rect = Rect.fromLTWH(
          col * colWidth,
          height - (row + 1) * (height / 12),
          colWidth - 1,
          (height / 12) - 1,
        );

        canvas.drawRect(rect, Paint()..color = cellColor);
      }
    }

    // Draw Current Time Playhead
    final progress = ((currentSec - 60) / 180.0).clamp(0.0, 1.0);
    final cursorX = progress * width;

    final cursorPaint = Paint()
      ..color = AppTheme.amber
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(cursorX, 0), Offset(cursorX, height), cursorPaint);
  }

  @override
  bool shouldRepaint(covariant _SpectrogramPainter oldDelegate) =>
      oldDelegate.currentSec != currentSec || oldDelegate.filterMode != filterMode;
}
