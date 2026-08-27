import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class EnvironmentRadarWidget extends StatefulWidget {
  const EnvironmentRadarWidget({super.key});

  @override
  State<EnvironmentRadarWidget> createState() => _EnvironmentRadarWidgetState();
}

class _EnvironmentRadarWidgetState extends State<EnvironmentRadarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final env = provider.environmentReport;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Doppler Radar Live Sweep Canvas
        Container(
          height: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.cyanDim, width: 1.5),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _radarController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _RadarSweepPainter(
                        angle: _radarController.value * 2 * pi,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 4,
                left: 6,
                child: Row(
                  children: [
                    const Icon(Icons.radar, color: AppTheme.cyan, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'DOPPLER FIRTINA RADARI [RANGE: 80 NM]',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.cyan),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.black87,
                  child: const Text(
                    'CB STORM CELL AT FL350',
                    style: TextStyle(fontSize: 9, color: AppTheme.red, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // METAR Terminal Weather Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud_sync, color: AppTheme.cyan, size: 18),
                  const SizedBox(width: 8),
                  Text('METEOROLOJİ & METAR RAPORU', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.cyan)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: AppTheme.background,
                child: Text(
                  env.rawMetar,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber, fontSize: 11),
                ),
              ),
              const SizedBox(height: 8),
              Text('ÇÖZÜMLENMİŞ ÖZET:', style: Theme.of(context).textTheme.labelSmall),
              Text(env.decodedSummary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text('BUZLANMA & TÜRBÜLANS TEHLİKESİ:', style: Theme.of(context).textTheme.labelSmall),
              Text(env.severeIcingAltitudeRange, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.red)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    provider.discoverEvidence('EVD_METAR_ICING');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buzlanma Raporu Masaya Eklendi!')),
                    );
                  },
                  icon: const Icon(Icons.ac_unit, size: 14),
                  label: const Text('BUZLANMA DELİLİNİ PİNLE', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.cyan,
                    side: const BorderSide(color: AppTheme.cyan),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Wreckage Scatter Analysis
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.waves, color: AppTheme.amber, size: 18),
                  const SizedBox(width: 8),
                  Text('ENKAZ DAĞILIM ANALİZİ (OKYANUS TABANI)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber)),
                ],
              ),
              const SizedBox(height: 8),
              Text('DAĞILIM DESENİ: ${env.wreckagePattern}', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 4),
              Text(env.wreckageInterpretation, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.discoverEvidence('EVD_WRECKAGE_COMPACT');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enkaz Analizi Masaya Eklendi!')),
                    );
                  },
                  icon: const Icon(Icons.push_pin, size: 14),
                  label: const Text('ENKAZ DELİLİNİ PİNLE', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.amber),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadarSweepPainter extends CustomPainter {
  final double angle;

  _RadarSweepPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    final linePaint = Paint()
      ..color = const Color(0xFF0D3B36)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Rings
    canvas.drawCircle(center, radius, linePaint);
    canvas.drawCircle(center, radius * 0.66, linePaint);
    canvas.drawCircle(center, radius * 0.33, linePaint);

    // Crosshairs
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), linePaint);

    // Storm Cell blobs (Red / Amber echoes)
    final stormPaint = Paint()..color = AppTheme.red.withAlpha(180);
    canvas.drawCircle(Offset(center.dx + 40, center.dy - 35), 22, stormPaint);
    canvas.drawCircle(Offset(center.dx + 55, center.dy - 20), 16, Paint()..color = AppTheme.amber.withAlpha(180));

    // Sweep Line & Beam Shader
    final sweepPaint = Paint()
      ..color = AppTheme.cyan
      ..strokeWidth = 2;

    final sweepEnd = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
    canvas.drawLine(center, sweepEnd, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarSweepPainter oldDelegate) => oldDelegate.angle != angle;
}
