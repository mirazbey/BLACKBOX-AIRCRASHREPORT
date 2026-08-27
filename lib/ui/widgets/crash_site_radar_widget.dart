import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';

enum RadarViewMode {
  flightProfile3d,
  debrisField,
  acousticPinger,
}

class CrashSiteRadarWidget extends StatefulWidget {
  final CaseBundle activeCase;
  final int currentTimeSeconds;
  final ValueChanged<int>? onTimeScrubbed;

  const CrashSiteRadarWidget({
    super.key,
    required this.activeCase,
    required this.currentTimeSeconds,
    this.onTimeScrubbed,
  });

  @override
  State<CrashSiteRadarWidget> createState() => _CrashSiteRadarWidgetState();
}

class _CrashSiteRadarWidgetState extends State<CrashSiteRadarWidget> with SingleTickerProviderStateMixin {
  RadarViewMode _currentMode = RadarViewMode.flightProfile3d;
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassBox(
        borderColor: AppTheme.cyan,
        borderWidth: 1.5,
        backgroundColor: const Color(0xFF080C12),
        borderRadius: 10,
      ),
      child: Column(
        children: [
          // Top Radar Header & Mode Toggles
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF101620),
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              border: Border(bottom: BorderSide(color: AppTheme.surfaceBorder)),
            ),
            child: Row(
              children: [
                const Icon(Icons.radar, size: 16, color: AppTheme.cyan),
                const SizedBox(width: 8),
                Text(
                  '3D TAKTİK KAZA MAHALİ RADARI',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.cyan,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.cyanDim,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'GPS: 03°03\'N / 30°22\'W',
                    style: const TextStyle(fontSize: 8, color: AppTheme.cyan, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // View Mode Selector Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                _buildModeButton(RadarViewMode.flightProfile3d, '3D İRTİFA PROFİLİ', Icons.trending_down),
                const SizedBox(width: 4),
                _buildModeButton(RadarViewMode.debrisField, 'ENKAZ DAĞILIMI', Icons.grain),
                const SizedBox(width: 4),
                _buildModeButton(RadarViewMode.acousticPinger, 'PİNGER AKUSTİK', Icons.surround_sound),
              ],
            ),
          ),

          // Interactive Radar Canvas
          Expanded(
            child: AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return ClipRect(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _TacticalRadarPainter(
                      viewMode: _currentMode,
                      sweepAngle: _sweepController.value * 2 * math.pi,
                      currentTimeSeconds: widget.currentTimeSeconds,
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Telemetry Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1219),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(9)),
              border: Border(top: BorderSide(color: AppTheme.surfaceBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFooterStat('DARBE VARYOSU', '-10,912 ft/dk', AppTheme.red),
                _buildFooterStat('DARBE AÇISI', '+16.2° Burun Yukarı', AppTheme.amber),
                _buildFooterStat('DENİZ DİBİ DERİNLİĞİ', '3,980 Metre', AppTheme.cyan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(RadarViewMode mode, String label, IconData icon) {
    final isSelected = _currentMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentMode = mode),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.cyan.withAlpha(40) : AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? AppTheme.cyan : AppTheme.surfaceBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 10, color: isSelected ? AppTheme.cyan : AppTheme.textFaint),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.cyan : AppTheme.textDim,
                  fontFamily: 'IBM Plex Mono',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 7, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono')),
        Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, fontFamily: 'IBM Plex Mono')),
      ],
    );
  }
}

class _TacticalRadarPainter extends CustomPainter {
  final RadarViewMode viewMode;
  final double sweepAngle;
  final int currentTimeSeconds;

  _TacticalRadarPainter({
    required this.viewMode,
    required this.sweepAngle,
    required this.currentTimeSeconds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.46;

    // 1. Radar Grid Circles & Crosshairs
    final gridPaint = Paint()
      ..color = AppTheme.cyan.withAlpha(35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxRadius * (i / 3), gridPaint);
    }
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy), Offset(center.dx + maxRadius, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius), Offset(center.dx, center.dy + maxRadius), gridPaint);

    if (viewMode == RadarViewMode.flightProfile3d) {
      _draw3dFlightProfile(canvas, size, center);
    } else if (viewMode == RadarViewMode.debrisField) {
      _drawDebrisField(canvas, center, maxRadius);
    } else {
      _drawAcousticPinger(canvas, center, maxRadius);
    }

    // 2. Rotating Radar Sweep Beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset.center,
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          Colors.transparent,
          AppTheme.cyan.withAlpha(80),
        ],
        stops: const [0.0, 1.0],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius, sweepPaint);
  }

  void _draw3dFlightProfile(Canvas canvas, Size size, Offset center) {
    // Draw 3D Isometric Descending Glideslope Ladder
    final pathPaint = Paint()
      ..color = AppTheme.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final trailPath = Path();
    final startX = size.width * 0.15;
    final startY = size.height * 0.25;
    final endX = size.width * 0.85;
    final endY = size.height * 0.78;

    trailPath.moveTo(startX, startY);
    trailPath.cubicTo(
      size.width * 0.4,
      startY + 10,
      size.width * 0.55,
      endY - 20,
      endX,
      endY,
    );

    canvas.drawPath(trailPath, pathPaint);

    // Current Aircraft Position on Path based on timecode
    final progress = ((currentTimeSeconds - 60) / 180.0).clamp(0.0, 1.0);
    final curX = startX + (endX - startX) * progress;
    final curY = startY + (endY - startY) * progress;

    final planePaint = Paint()
      ..color = AppTheme.amber
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(curX, curY), 6, planePaint);
    canvas.drawCircle(
      Offset(curX, curY),
      12,
      Paint()
        ..color = AppTheme.amber.withAlpha(90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Impact Cross
    final impactPaint = Paint()
      ..color = AppTheme.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(endX - 8, endY - 8), Offset(endX + 8, endY + 8), impactPaint);
    canvas.drawLine(Offset(endX + 8, endY - 8), Offset(endX - 8, endY + 8), impactPaint);
  }

  void _drawDebrisField(Canvas canvas, Offset center, double radius) {
    final debris = [
      {'dx': 0.1, 'dy': -0.2, 'label': 'KARA KUTU (FDR/CVR)', 'color': AppTheme.amber},
      {'dx': -0.3, 'dy': 0.15, 'label': 'DİKEY STABİLİZE', 'color': AppTheme.cyan},
      {'dx': 0.25, 'dy': 0.3, 'label': 'SOL MOTOR (CF6)', 'color': AppTheme.red},
      {'dx': -0.15, 'dy': -0.35, 'label': 'BURUN RADOMU', 'color': AppTheme.violet},
      {'dx': 0.4, 'dy': -0.1, 'label': 'SAĞ KANAT', 'color': AppTheme.green},
    ];

    for (final item in debris) {
      final pos = Offset(
        center.dx + (item['dx'] as double) * radius,
        center.dy + (item['dy'] as double) * radius,
      );

      final color = item['color'] as Color;
      canvas.drawCircle(pos, 4, Paint()..color = color);
      canvas.drawCircle(
        pos,
        8,
        Paint()
          ..color = color.withAlpha(80)
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawAcousticPinger(Canvas canvas, Offset center, double radius) {
    // ULB 37.5 kHz Acoustic Hydrophone Pings
    final pingerPos = Offset(center.dx + radius * 0.15, center.dy - radius * 0.15);

    for (int i = 1; i <= 4; i++) {
      final ringRadius = (sweepAngle * 18 + i * 20) % (radius * 0.8);
      canvas.drawCircle(
        pingerPos,
        ringRadius,
        Paint()
          ..color = AppTheme.amber.withAlpha((180 * (1.0 - ringRadius / (radius * 0.8))).toInt().clamp(0, 255))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    canvas.drawCircle(pingerPos, 5, Paint()..color = AppTheme.amber);
  }

  @override
  bool shouldRepaint(covariant _TacticalRadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.currentTimeSeconds != currentTimeSeconds ||
        oldDelegate.viewMode != viewMode;
  }
}
