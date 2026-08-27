import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';
import '../../models/investigation_state.dart';

class InvestigationBoardWidget extends StatefulWidget {
  const InvestigationBoardWidget({super.key});

  @override
  State<InvestigationBoardWidget> createState() => _InvestigationBoardWidgetState();
}

class _InvestigationBoardWidgetState extends State<InvestigationBoardWidget> {
  String? selectedPinIdForConnection;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final pins = provider.boardPins;
    final connections = provider.boardConnections;
    final theories = provider.unlockedTheories;

    return Stack(
      children: [
        // Zoomable & Pannable Investigation Corkboard Canvas
        InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(500),
          minScale: 0.5,
          maxScale: 2.5,
          child: SizedBox(
            width: 1400,
            height: 1200,
            child: Stack(
              children: [
                // Corkboard Background Texture
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F131A),
                      border: Border.all(color: AppTheme.surfaceBorder, width: 2),
                    ),
                    child: CustomPaint(
                      painter: _GridBackgroundPainter(),
                    ),
                  ),
                ),

                // Thread Strings Painter
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BoardThreadPainter(
                      pins: pins,
                      connections: connections,
                    ),
                  ),
                ),

                // Pinned Evidence Cards
                ...pins.map((pin) {
                  final isSelected = selectedPinIdForConnection == pin.pinId;

                  return Positioned(
                    left: pin.position.dx,
                    top: pin.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        provider.updatePinPosition(
                          pin.pinId,
                          pin.position + details.delta,
                        );
                      },
                      onTap: () {
                        setState(() {
                          if (selectedPinIdForConnection == null) {
                            selectedPinIdForConnection = pin.pinId;
                          } else {
                            if (selectedPinIdForConnection != pin.pinId) {
                              provider.connectPins(selectedPinIdForConnection!, pin.pinId);
                            }
                            selectedPinIdForConnection = null;
                          }
                        });
                      },
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1E2838) : const Color(0xFF161C26),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? AppTheme.amber : _getRoleColor(pin.ownerRoleIndex),
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Pushpin Icon
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getRoleColor(pin.ownerRoleIndex),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getRoleColor(pin.ownerRoleIndex).withAlpha(150),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    pin.sourceTag.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: _getRoleColor(pin.ownerRoleIndex),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IBM Plex Mono',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pin.title,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                                height: 1.3,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                isSelected ? 'BAĞLANTI SEÇİLDİ' : 'DOKUN & BAĞLA',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isSelected ? AppTheme.amber : AppTheme.textFaint,
                                  fontFamily: 'IBM Plex Mono',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Floating Info & HUD Legend
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surface.withAlpha(240),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hub, color: AppTheme.violet, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'AÇILAN TEORİLER: ${theories.length}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.violet),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surface.withAlpha(240),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: const Row(
                  children: [
                    Text('KIRMIZI = ÇELİŞKİ  |  TURKUAZ = DESTEK', style: TextStyle(fontSize: 9, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                  ],
                ),
              ),
              const Spacer(),
              if (selectedPinIdForConnection != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.amberDim,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'İkinci delile dokun',
                    style: TextStyle(fontSize: 11, color: AppTheme.amber, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(int roleIndex) {
    switch (roleIndex) {
      case 1:
        return AppTheme.amber;
      case 2:
        return AppTheme.cyan;
      case 3:
        return AppTheme.violet;
      case 4:
        return AppTheme.red;
      default:
        return AppTheme.amber;
    }
  }
}

class _GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2633)
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BoardThreadPainter extends CustomPainter {
  final List<BoardPin> pins;
  final List<BoardConnection> connections;

  _BoardThreadPainter({required this.pins, required this.connections});

  @override
  void paint(Canvas canvas, Size size) {
    for (final conn in connections) {
      final fromPin = pins.where((p) => p.pinId == conn.fromPinId).firstOrNull;
      final toPin = pins.where((p) => p.pinId == conn.toPinId).firstOrNull;

      if (fromPin != null && toPin != null) {
        final start = fromPin.position + const Offset(80, 45);
        final end = toPin.position + const Offset(80, 45);

        final isContradiction = conn.relationType == 'CONTRADICTS';

        final paint = Paint()
          ..color = isContradiction ? AppTheme.red : AppTheme.cyan
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

        // Draw curved bezier line (yarn string)
        final mid = (start + end) / 2;
        final controlPoint = Offset(mid.dx, mid.dy + 35);
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);

        canvas.drawPath(path, paint);

        // Draw center badge for relation type as per MIMARI_RAPOR_V3 Bölüm 05
        final badgeCenter = controlPoint;
        final badgeColor = isContradiction ? AppTheme.red : AppTheme.cyan;
        final badgeText = isContradiction ? '⚡ ÇELİŞKİ' : '✓ DESTEKLER';

        final bgRect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: badgeCenter, width: isContradiction ? 74 : 80, height: 18),
          const Radius.circular(9),
        );

        canvas.drawRRect(bgRect, Paint()..color = const Color(0xFF101419));
        canvas.drawRRect(
          bgRect,
          Paint()
            ..color = badgeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBM Plex Mono',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          badgeCenter - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardThreadPainter oldDelegate) => true;
}
