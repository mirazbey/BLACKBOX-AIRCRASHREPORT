import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/source_models.dart';

class CockpitPfdWidget extends StatelessWidget {
  final FdrRecord record;

  const CockpitPfdWidget({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final pitch = record.pitchDeg;
    final roll = record.rollDeg;
    final airspeed = record.indicatedAirspeedKnots;
    final altitude = record.altitudeFt;
    final isStall = record.controlColumnPct < -50 && airspeed < 120;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStall ? AppTheme.red : AppTheme.surfaceBorder,
          width: isStall ? 2.5 : 1.5,
        ),
        boxShadow: isStall
            ? [
                BoxShadow(
                  color: AppTheme.red.withAlpha(100),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Artificial Horizon Canvas
            Positioned.fill(
              child: CustomPaint(
                painter: _HorizonPainter(
                  pitchDeg: pitch,
                  rollDeg: roll,
                ),
              ),
            ),

            // Pitch Ladder & Aircraft Reference Symbol
            Positioned.fill(
              child: CustomPaint(
                painter: _AircraftReferencePainter(),
              ),
            ),

            // Left Airspeed Tape
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 55,
              child: Container(
                color: Colors.black.withAlpha(180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('IAS', style: TextStyle(fontSize: 8, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                    Text(
                      '${airspeed.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Mono',
                        color: airspeed < 120 ? AppTheme.red : AppTheme.amber,
                      ),
                    ),
                    const Text('KT', style: TextStyle(fontSize: 8, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                    if (airspeed < 120) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        color: AppTheme.red,
                        child: const Text('LOW', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Right Altitude Tape
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 65,
              child: Container(
                color: Colors.black.withAlpha(180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ALT', style: TextStyle(fontSize: 8, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                    Text(
                      '${altitude.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Mono',
                        color: AppTheme.cyan,
                      ),
                    ),
                    const Text('FT', style: TextStyle(fontSize: 8, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                  ],
                ),
              ),
            ),

            // Top Autopilot & Flight Mode Annunciator (FMA)
            Positioned(
              top: 6,
              left: 60,
              right: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFmaBox(record.autopilotEngaged ? 'AP1' : 'MANUAL', record.autopilotEngaged ? AppTheme.green : AppTheme.red),
                  _buildFmaBox(pitch > 10 ? 'PITCH UP' : 'ALT CRZ', AppTheme.cyan),
                  _buildFmaBox('THR LVR', AppTheme.amber),
                ],
              ),
            ),

            // STALL Warning Blinking Banner
            if (isStall) ...[
              Positioned(
                bottom: 8,
                left: 60,
                right: 70,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '⚠ STALL / PERDÖVİTES ⚠',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFmaBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color, fontFamily: 'IBM Plex Mono'),
      ),
    );
  }
}

class _HorizonPainter extends CustomPainter {
  final double pitchDeg;
  final double rollDeg;

  _HorizonPainter({required this.pitchDeg, required this.rollDeg});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-rollDeg * pi / 180);

    final pitchOffset = pitchDeg * 3.5;

    // Sky (Blue)
    final skyPaint = Paint()..color = const Color(0xFF003F7A);
    canvas.drawRect(
      Rect.fromLTRB(-size.width, -size.height * 2 + pitchOffset, size.width, pitchOffset),
      skyPaint,
    );

    // Ground (Brown)
    final groundPaint = Paint()..color = const Color(0xFF4A2F08);
    canvas.drawRect(
      Rect.fromLTRB(-size.width, pitchOffset, size.width, size.height * 2 + pitchOffset),
      groundPaint,
    );

    // Horizon Line (White)
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(-size.width, pitchOffset),
      Offset(size.width, pitchOffset),
      linePaint,
    );

    // Pitch ladder rungs
    for (int p = -30; p <= 30; p += 10) {
      if (p == 0) continue;
      final y = pitchOffset - (p * 3.5);
      final rungWidth = p.abs() % 20 == 0 ? 36.0 : 22.0;
      canvas.drawLine(
        Offset(-rungWidth, y),
        Offset(rungWidth, y),
        linePaint..strokeWidth = 1.2,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) => true;
}

class _AircraftReferencePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppTheme.amber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Center dot and aircraft wingbars
    canvas.drawCircle(center, 3, Paint()..color = AppTheme.amber);
    canvas.drawLine(center + const Offset(-40, 0), center + const Offset(-15, 0), paint);
    canvas.drawLine(center + const Offset(-15, 0), center + const Offset(-15, 8), paint);
    canvas.drawLine(center + const Offset(15, 0), center + const Offset(40, 0), paint);
    canvas.drawLine(center + const Offset(15, 0), center + const Offset(15, 8), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
