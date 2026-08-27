import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/causal_graph_model.dart';
import '../../providers/investigation_provider.dart';
import '../../services/audio_haptic_service.dart';

class CausalGraphInspectorWidget extends StatefulWidget {
  const CausalGraphInspectorWidget({super.key});

  @override
  State<CausalGraphInspectorWidget> createState() => _CausalGraphInspectorWidgetState();
}

class _CausalGraphInspectorWidgetState extends State<CausalGraphInspectorWidget> {
  String? _selectedNodeId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final graph = provider.groundTruthGraph;
    final nodes = graph.nodes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassBox(
        borderColor: AppTheme.surfaceBorder,
        backgroundColor: const Color(0xFF090D13),
        borderRadius: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.account_tree, color: AppTheme.amber, size: 18),
              const SizedBox(width: 8),
              Text(
                'ADLİ NEDENSELLİK GRAFI (CAUSAL DAG & SWISS CHEESE)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.amber,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.amber),
                ),
                child: Text(
                  '${nodes.length} DÜĞÜM TANIMLI',
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.amber,
                    fontFamily: 'IBM Plex Mono',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // DAG Interactive Canvas
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: _DagPainter(
                nodes: nodes,
                selectedNodeId: _selectedNodeId,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Node List & Inspector Selector
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nodes.length,
              itemBuilder: (context, index) {
                final node = nodes[index];
                final isSelected = _selectedNodeId == node.id;
                final catColor = _getCategoryColor(node.category);

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      AudioHapticService.playPinDrop();
                      setState(() {
                        _selectedNodeId = isSelected ? null : node.id;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? catColor.withAlpha(40) : const Color(0xFF131822),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? catColor : AppTheme.surfaceBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: catColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            node.title,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? catColor : AppTheme.textPrimary,
                              fontFamily: 'IBM Plex Mono',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(CausalCategory cat) {
    switch (cat) {
      case CausalCategory.environment:
        return AppTheme.cyan;
      case CausalCategory.latentMaintenance:
      case CausalCategory.organizational:
        return AppTheme.violet;
      case CausalCategory.trigger:
        return AppTheme.amber;
      case CausalCategory.systemFault:
        return Colors.orangeAccent;
      case CausalCategory.humanError:
      case CausalCategory.outcome:
        return AppTheme.red;
    }
  }
}

class _DagPainter extends CustomPainter {
  final List<CausalNode> nodes;
  final String? selectedNodeId;

  _DagPainter({required this.nodes, this.selectedNodeId});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final width = size.width;
    final height = size.height;

    // Arrange nodes into 4 horizontal stages:
    // Stage 0: Root Latent (x = 15%)
    // Stage 1: Trigger (x = 40%)
    // Stage 2: System & Human Errors (x = 65%)
    // Stage 3: Outcome (x = 90%)

    final nodePositions = <String, Offset>{};

    int stage0Count = 0;
    int stage1Count = 0;
    int stage2Count = 0;
    int stage3Count = 0;

    for (final node in nodes) {
      double xRatio;
      int count;
      switch (node.category) {
        case CausalCategory.environment:
        case CausalCategory.latentMaintenance:
        case CausalCategory.organizational:
          xRatio = 0.15;
          count = stage0Count++;
          break;
        case CausalCategory.trigger:
          xRatio = 0.40;
          count = stage1Count++;
          break;
        case CausalCategory.systemFault:
        case CausalCategory.humanError:
          xRatio = 0.65;
          count = stage2Count++;
          break;
        case CausalCategory.outcome:
          xRatio = 0.90;
          count = stage3Count++;
          break;
      }
      final y = 25.0 + count * 45.0;
      nodePositions[node.id] = Offset(xRatio * width, y.clamp(20.0, height - 20.0));
    }

    // Draw connecting arrows between stages
    final linePaint = Paint()
      ..color = const Color(0xFF2A3649)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = AppTheme.amber
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    // Draw forward DAG edges
    final nodeKeys = nodePositions.keys.toList();
    for (int i = 0; i < nodeKeys.length - 1; i++) {
      final p1 = nodePositions[nodeKeys[i]]!;
      final p2 = nodePositions[nodeKeys[i + 1]]!;

      final isEdgeSelected = selectedNodeId != null &&
          (selectedNodeId == nodeKeys[i] || selectedNodeId == nodeKeys[i + 1]);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..cubicTo(
          p1.dx + (p2.dx - p1.dx) * 0.5,
          p1.dy,
          p1.dx + (p2.dx - p1.dx) * 0.5,
          p2.dy,
          p2.dx,
          p2.dy,
        );

      canvas.drawPath(path, isEdgeSelected ? glowPaint : linePaint);
    }

    // Draw Node Circles and Labels
    for (final node in nodes) {
      final pos = nodePositions[node.id]!;
      final isSelected = selectedNodeId == node.id;
      final nodeColor = _getNodeColor(node.category);

      // Outer glow
      if (isSelected) {
        canvas.drawCircle(pos, 14, Paint()..color = nodeColor.withAlpha(80));
      }

      // Main Node Dot
      canvas.drawCircle(pos, 8, Paint()..color = nodeColor);
      canvas.drawCircle(
        pos,
        8,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Node label
      final tp = TextPainter(
        text: TextSpan(
          text: node.title.length > 14 ? '${node.title.substring(0, 12)}..' : node.title,
          style: TextStyle(
            fontSize: 7.5,
            color: isSelected ? Colors.white : AppTheme.textDim,
            fontFamily: 'IBM Plex Mono',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy + 11));
    }
  }

  Color _getNodeColor(CausalCategory cat) {
    switch (cat) {
      case CausalCategory.environment:
        return AppTheme.cyan;
      case CausalCategory.latentMaintenance:
      case CausalCategory.organizational:
        return AppTheme.violet;
      case CausalCategory.trigger:
        return AppTheme.amber;
      case CausalCategory.systemFault:
        return Colors.orangeAccent;
      case CausalCategory.humanError:
      case CausalCategory.outcome:
        return AppTheme.red;
    }
  }

  @override
  bool shouldRepaint(covariant _DagPainter oldDelegate) =>
      oldDelegate.selectedNodeId != selectedNodeId || oldDelegate.nodes != nodes;
}
