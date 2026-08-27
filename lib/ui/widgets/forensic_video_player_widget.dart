import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../theme/app_theme.dart';
import '../../models/forensic_clip_model.dart';
import '../../providers/investigation_provider.dart';

class ForensicVideoPlayerWidget extends StatefulWidget {
  const ForensicVideoPlayerWidget({super.key});

  @override
  State<ForensicVideoPlayerWidget> createState() =>
      _ForensicVideoPlayerWidgetState();
}

class _ForensicVideoPlayerWidgetState extends State<ForensicVideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  int selectedClipIndex = 0;
  late AnimationController _glitchController;
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideo;
  bool _didLoadInitialClip = false;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadInitialClip) {
      _didLoadInitialClip = true;
      _prepareVideo(context.read<InvestigationProvider>().forensicClips.first);
    }
  }

  void _prepareVideo(ForensicClip clip) {
    _videoController?.dispose();
    _videoController = null;
    _initializeVideo = null;

    if (clip.assetPath == null && clip.remoteUri == null) return;

    final controller = clip.remoteUri != null
        ? VideoPlayerController.networkUrl(clip.remoteUri!)
        : VideoPlayerController.asset(clip.assetPath!);
    _videoController = controller;
    _initializeVideo = controller.initialize().then((_) async {
      if (_videoController != controller) return;
      await controller.setLooping(true);
      await controller.setVolume(0.32);
      await controller.seekTo(const Duration(milliseconds: 550));
    });
  }

  Future<void> _toggleVideo() async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final clips = provider.forensicClips;
    final activeClip = clips[selectedClipIndex];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Camera Selector Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(clips.length, (i) {
              final isSelected = selectedClipIndex == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    clips[i].selectorLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.black : AppTheme.textDim,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.amber,
                  backgroundColor: AppTheme.surfaceAlt,
                  onSelected: (_) {
                    setState(() {
                      selectedClipIndex = i;
                      _prepareVideo(clips[i]);
                    });
                    provider.setTimelineCursor(clips[i].offsetSeconds);
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // CRT Forensic Monitor Frame
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.surfaceBorder, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Real case-bundle video when available, procedural fallback
                // for feeds that have not been downloaded yet.
                Positioned.fill(child: _buildSceneLayer(activeClip)),

                // CRT Scanline Shader Overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _CrtScanlinesPainter()),
                  ),
                ),

                // Top OSD Status Bar (REC, Timestamp, Camera Name)
                Positioned(
                  top: 8,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.red,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'SIM / TÜRETİLMİŞ',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBM Plex Mono',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          activeClip.cameraLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppTheme.cyan,
                            fontFamily: 'IBM Plex Mono',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${activeClip.timestampUtc} UTC',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.amber,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBM Plex Mono',
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Subtitle Overlay
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: Colors.black.withAlpha(200),
                    child: Text(
                      activeClip.subtitleText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontFamily: 'IBM Plex Sans',
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Clip Title & Forensic Analysis Card
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
                  const Icon(Icons.videocam, color: AppTheme.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activeClip.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                activeClip.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              // Pin Evidence Action
              if (activeClip.revealsEvidenceId != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        provider.discoveredEvidenceIds.contains(
                          activeClip.revealsEvidenceId,
                        )
                        ? null
                        : () {
                            provider.captureForensicFrame(activeClip);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Kare, türetilmiş analiz notu olarak kara tahtaya eklendi.',
                                ),
                              ),
                            );
                          },
                    icon: const Icon(
                      Icons.push_pin,
                      size: 16,
                      color: Colors.black,
                    ),
                    label: Text(
                      provider.discoveredEvidenceIds.contains(
                            activeClip.revealsEvidenceId,
                          )
                          ? 'ANALİZ NOTU TAHTAYA EKLENDİ'
                          : 'KADRAJI ANALİZ NOTU OLARAK PİNLE',
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.amber,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSceneLayer(ForensicClip clip) {
    final controller = _videoController;
    final initializeVideo = _initializeVideo;

    if (controller == null || initializeVideo == null) {
      return AnimatedBuilder(
        animation: _glitchController,
        builder: (context, _) {
          return CustomPaint(
            painter: _ForensicScenePainter(
              cameraType: clip.cameraType,
              animValue: _glitchController.value,
            ),
          );
        },
      );
    }

    return FutureBuilder<void>(
      future: initializeVideo,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ColoredBox(
            color: Color(0xFF0D1116),
            child: Center(
              child: Text(
                'KAYIT ÇÖZÜMLENEMEDİ',
                style: TextStyle(color: AppTheme.red, fontSize: 10),
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/forensics/cockpit_reconstruction_source.png',
                fit: BoxFit.cover,
                color: const Color(0x88000000),
                colorBlendMode: BlendMode.darken,
              ),
              const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.amber,
                ),
              ),
            ],
          );
        }

        return ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return GestureDetector(
              onTap: _toggleVideo,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: value.size.width,
                      height: value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  if (!value.isPlaying)
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(205),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.amber),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppTheme.amber,
                          size: 30,
                        ),
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppTheme.amber,
                        bufferedColor: AppTheme.amberDim,
                        backgroundColor: AppTheme.surfaceBorder,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ForensicScenePainter extends CustomPainter {
  final CameraFeedType cameraType;
  final double animValue;

  _ForensicScenePainter({required this.cameraType, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (cameraType) {
      case CameraFeedType.avionicsFlir:
        // Thermal FLIR Pitot view (cold blue/cyan surrounded by dark heat)
        final bgPaint = Paint()..color = const Color(0xFF071B26);
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

        // Plane fuselage contour
        final planePaint = Paint()..color = const Color(0xFF133E54);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx - 40, center.dy),
            width: 140,
            height: 180,
          ),
          planePaint,
        );

        // Pitot Probe & Ice crystallization
        final probePaint = Paint()
          ..color = AppTheme.cyan
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(center.dx - 10, center.dy),
          Offset(center.dx + 60, center.dy),
          probePaint,
        );

        // Ice frost blob (deep blue cold anomaly)
        final icePaint = Paint()
          ..color = const Color(
            0xFF00E5FF,
          ).withAlpha(160 + (sin(animValue * 2 * pi) * 40).toInt());
        canvas.drawCircle(Offset(center.dx + 40, center.dy), 18, icePaint);
        break;

      case CameraFeedType.cockpitCctv:
        // Gritty night cockpit CCTV
        final bgPaint = Paint()..color = const Color(0xFF101216);
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

        // Windshield frame & thunderstorm lightning flashes
        if (sin(animValue * 4 * pi) > 0.7) {
          final flashPaint = Paint()..color = Colors.white.withAlpha(40);
          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            flashPaint,
          );
        }

        // Instrument panel glow
        final panelPaint = Paint()..color = const Color(0xFF1E2633);
        canvas.drawRect(
          Rect.fromLTWH(20, center.dy + 10, size.width - 40, size.height / 2),
          panelPaint,
        );

        // Flashing Master Caution Annunciator
        final alertGlow = Paint()
          ..color = AppTheme.red.withAlpha(
            sin(animValue * 3 * pi) > 0 ? 220 : 40,
          );
        canvas.drawCircle(
          Offset(center.dx - 50, center.dy + 30),
          12,
          alertGlow,
        );
        break;

      case CameraFeedType.tailExteriorCam:
      case CameraFeedType.wireframe3dRecon:
        // 3D Wireframe Reconstruction (Green radar aesthetic)
        final bgPaint = Paint()..color = const Color(0xFF08120C);
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

        final gridPaint = Paint()
          ..color = AppTheme.green.withAlpha(60)
          ..strokeWidth = 1;

        // Ocean wireframe surface
        for (double y = center.dy; y < size.height; y += 18) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        }

        // Wireframe aircraft descent vector
        final planeWire = Paint()
          ..color = AppTheme.green
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

        final planePath = Path()
          ..moveTo(center.dx - 40, center.dy - 30)
          ..lineTo(center.dx + 40, center.dy - 10)
          ..lineTo(center.dx, center.dy + 20)
          ..close();
        canvas.drawPath(planePath, planeWire);

        // Impact vector line
        final vectorPaint = Paint()
          ..color = AppTheme.red
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawLine(center, Offset(center.dx, center.dy + 60), vectorPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ForensicScenePainter oldDelegate) => true;
}

class _CrtScanlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
