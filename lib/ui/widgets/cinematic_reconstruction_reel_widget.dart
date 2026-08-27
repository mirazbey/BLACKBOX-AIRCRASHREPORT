import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../models/cinematic_debrief_model.dart';

class CinematicReconstructionReelWidget extends StatefulWidget {
  final List<CinematicReconstructionScene> scenes;
  final VoidCallback? onReelComplete;

  const CinematicReconstructionReelWidget({
    super.key,
    required this.scenes,
    this.onReelComplete,
  });

  @override
  State<CinematicReconstructionReelWidget> createState() => _CinematicReconstructionReelWidgetState();
}

class _CinematicReconstructionReelWidgetState extends State<CinematicReconstructionReelWidget>
    with SingleTickerProviderStateMixin {
  int currentSceneIndex = 0;
  late AnimationController _sceneAnimController;

  @override
  void initState() {
    super.initState();
    _sceneAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();

    _sceneAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (currentSceneIndex < widget.scenes.length - 1) {
          setState(() {
            currentSceneIndex++;
            _sceneAnimController.reset();
            _sceneAnimController.forward();
          });
        } else {
          widget.onReelComplete?.call();
        }
      }
    });
  }

  @override
  void dispose() {
    _sceneAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scenes.isEmpty) {
      return const SizedBox.shrink();
    }

    final scene = widget.scenes[currentSceneIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.amber.withAlpha(50),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top OSD Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: AppTheme.surfaceAlt,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'BÜYÜK FİNAL REKONSTRÜKSİYONU',
                      style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SAHNE ${currentSceneIndex + 1} / ${widget.scenes.length}',
                    style: const TextStyle(fontSize: 10, color: AppTheme.amber, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                  ),
                  const Spacer(),
                  Text(
                    '${scene.timeUtc} [${scene.timeOffsetLabel}]',
                    style: const TextStyle(fontSize: 10, color: AppTheme.cyan, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                  ),
                ],
              ),
            ),

            // Cinematic Canvas Frame
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _sceneAnimController,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _CinematicScenePainter(
                            sceneType: scene.mediaAssetOrSceneType,
                            animProgress: _sceneAnimController.value,
                          ),
                        );
                      },
                    ),
                  ),
                  // CRT Scanline Shader
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _ScanlineShaderPainter(),
                      ),
                    ),
                  ),
                  // Operator Badge overlay
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: _getOperatorColor(scene.primaryOperatorRole)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.military_tech, size: 12, color: _getOperatorColor(scene.primaryOperatorRole)),
                          const SizedBox(width: 4),
                          Text(
                            scene.primaryOperatorRole.operatorCode,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM Plex Mono',
                              color: _getOperatorColor(scene.primaryOperatorRole),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Voiceover Audio Subtitle Bar
                  Positioned(
                    bottom: 8,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withAlpha(210),
                      child: Text(
                        scene.audioVoiceOver,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'IBM Plex Sans',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress Timeline Bar
            LinearProgressIndicator(
              value: (currentSceneIndex + _sceneAnimController.value) / widget.scenes.length,
              backgroundColor: AppTheme.surfaceBorder,
              valueColor: const AlwaysStoppedAnimation(AppTheme.amber),
              minHeight: 3,
            ),

            // Scene Description & Swiss Cheese Cause Tag
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.amberDim.withAlpha(70),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.amber),
                        ),
                        child: Text(
                          scene.stageTitle.toUpperCase(),
                          style: const TextStyle(fontSize: 9, color: AppTheme.amber, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          scene.headline,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13, color: AppTheme.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    scene.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppTheme.cyan, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'İsviçre Peyniri Kaza Zinciri: ${scene.swissCheeseHoleTitle}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.cyan, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Next / Skip Scene Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: currentSceneIndex > 0
                            ? () {
                                setState(() {
                                  currentSceneIndex--;
                                  _sceneAnimController.reset();
                                  _sceneAnimController.forward();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.skip_previous, size: 14),
                        label: const Text('ÖNCEKİ', style: TextStyle(fontSize: 10)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (currentSceneIndex < widget.scenes.length - 1) {
                            setState(() {
                              currentSceneIndex++;
                              _sceneAnimController.reset();
                              _sceneAnimController.forward();
                            });
                          } else {
                            widget.onReelComplete?.call();
                          }
                        },
                        icon: Icon(
                          currentSceneIndex < widget.scenes.length - 1 ? Icons.skip_next : Icons.fact_check,
                          size: 14,
                          color: Colors.black,
                        ),
                        label: Text(
                          currentSceneIndex < widget.scenes.length - 1 ? 'SONRAKİ SAHNE' : 'SKOR VE XP TABLOSU',
                          style: const TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getOperatorColor(InvestigatorRole role) {
    switch (role) {
      case InvestigatorRole.telemetryFdr:
        return AppTheme.amber;
      case InvestigatorRole.acousticCvr:
        return AppTheme.cyan;
      case InvestigatorRole.avionicsFlir:
        return AppTheme.red;
      case InvestigatorRole.maintenanceOps:
        return AppTheme.violet;
      case InvestigatorRole.humanFactorsPsych:
        return AppTheme.green;
    }
  }
}

class _CinematicScenePainter extends CustomPainter {
  final String sceneType;
  final double animProgress;

  _CinematicScenePainter({required this.sceneType, required this.animProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (sceneType == 'flir_ice') {
      // FLIR Thermal Ice probe view
      final bg = Paint()..color = const Color(0xFF04121E);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

      final probePaint = Paint()
        ..color = AppTheme.cyan
        ..strokeWidth = 8;
      canvas.drawLine(Offset(center.dx - 60, center.dy), Offset(center.dx + 40, center.dy), probePaint);

      final frost = Paint()..color = const Color(0xFF00E5FF).withAlpha(180 + (sin(animProgress * 4 * pi) * 40).toInt());
      canvas.drawCircle(Offset(center.dx + 20, center.dy), 22, frost);
    } else if (sceneType == 'pfd_stall') {
      // PFD Pitch-Up Ladder into Stall
      final sky = Paint()..color = const Color(0xFF00376B);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sky);

      final pitchOffset = 40.0;
      final linePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2;
      canvas.drawLine(Offset(0, center.dy + pitchOffset), Offset(size.width, center.dy + pitchOffset), linePaint);

      // Flashing STALL banner
      if (sin(animProgress * 6 * pi) > 0) {
        final banner = Paint()..color = AppTheme.red;
        canvas.drawRect(Rect.fromCenter(center: center, width: 180, height: 32), banner);
      }
    } else if (sceneType == 'mel_log') {
      // Stamped Maintenance Deferral Document
      final paper = Paint()..color = const Color(0xFF161A22);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paper);

      final stamp = Paint()
        ..color = AppTheme.red.withAlpha(220)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawRect(Rect.fromCenter(center: center, width: 160, height: 44), stamp);
    } else {
      // 3D Wireframe Ocean descent
      final dark = Paint()..color = const Color(0xFF060F0A);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), dark);

      final grid = Paint()
        ..color = AppTheme.green.withAlpha(80)
        ..strokeWidth = 1;
      for (double y = center.dy; y < size.height; y += 16) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CinematicScenePainter oldDelegate) => true;
}

class _ScanlineShaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black.withAlpha(55)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
