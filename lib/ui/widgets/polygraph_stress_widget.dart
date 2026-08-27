import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PolygraphStressWidget extends StatefulWidget {
  final String suspectName;
  final String stressStatus;
  final bool isHighStress;

  const PolygraphStressWidget({
    super.key,
    required this.suspectName,
    required this.stressStatus,
    this.isHighStress = true,
  });

  @override
  State<PolygraphStressWidget> createState() => _PolygraphStressWidgetState();
}

class _PolygraphStressWidgetState extends State<PolygraphStressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.isHighStress ? 750 : 1200),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant PolygraphStressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isHighStress != widget.isHighStress) {
      _pulseController.duration = Duration(milliseconds: widget.isHighStress ? 750 : 1200);
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heartRate = widget.isHighStress ? 134 : 78;
    final accentColor = widget.isHighStress ? AppTheme.red : AppTheme.green;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(40),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monitor_heart, color: accentColor, size: 16),
              const SizedBox(width: 6),
              Text(
                'ADLİ BİYOMETRİK STRES & YALAN TESTİ (ECG/GSR)',
                style: TextStyle(
                  fontSize: 9,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Mono',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$heartRate BPM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Mono',
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ECG Oscilloscope Canvas
          SizedBox(
            height: 40,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 40),
                  painter: _EcgPainter(
                    animValue: _pulseController.value,
                    isHighStress: widget.isHighStress,
                    traceColor: accentColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Text('DURUM: ', style: TextStyle(fontSize: 8, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
              Text(
                widget.stressStatus,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: accentColor, fontFamily: 'IBM Plex Mono'),
              ),
              const Spacer(),
              Text(
                widget.isHighStress ? '⚠ AKUT ANKSİYETE / PANİK' : 'DENGELİ SOLUNUM',
                style: TextStyle(fontSize: 8, color: accentColor, fontFamily: 'IBM Plex Mono'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double animValue;
  final bool isHighStress;
  final Color traceColor;

  _EcgPainter({
    required this.animValue,
    required this.isHighStress,
    required this.traceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF0D241C)
      ..strokeWidth = 0.5;

    // Grid lines
    for (double x = 0; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final centerY = size.height / 2;
    final waveLength = size.width;

    path.moveTo(0, centerY);

    for (double x = 0; x <= size.width; x += 3) {
      final normalizedX = (x / waveLength + animValue) % 1.0;
      double yOffset = 0;

      // QRS Complex spike
      if (normalizedX > 0.45 && normalizedX < 0.55) {
        final spikePhase = (normalizedX - 0.45) / 0.1;
        if (spikePhase < 0.3) {
          yOffset = 4;
        } else if (spikePhase < 0.6) {
          yOffset = isHighStress ? -18 : -12; // Tall R-wave spike
        } else {
          yOffset = isHighStress ? 14 : 8; // Deep S-wave
        }
      } else if (normalizedX > 0.7 && normalizedX < 0.85) {
        // T-wave
        yOffset = sin((normalizedX - 0.7) / 0.15 * pi) * (isHighStress ? -7 : -4);
      }

      path.lineTo(x, centerY + yOffset);
    }

    final linePaint = Paint()
      ..color = traceColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) => true;
}
