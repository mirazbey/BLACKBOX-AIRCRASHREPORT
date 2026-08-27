import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../models/cinematic_debrief_model.dart';

class OperatorXpBreakdownWidget extends StatelessWidget {
  final List<OperatorScoreDetail> operatorScores;

  const OperatorXpBreakdownWidget({
    super.key,
    required this.operatorScores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.military_tech, color: AppTheme.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              'OPERATÖR BİREYSEL XP & PERFORMANS KARNESİ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.amber,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...operatorScores.map((op) {
          final isMvp = op.isMvp;
          final roleColor = _getRoleColor(op.role);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMvp ? roleColor.withAlpha(35) : AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isMvp ? AppTheme.amber : AppTheme.surfaceBorder,
                width: isMvp ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: roleColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        op.operatorCode,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'IBM Plex Mono',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            op.specialistTitle,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          Text(
                            'Kritik Katkı: ${op.keyDiscoveryTitle}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.textDim),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isMvp) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '★ MVP',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '+${op.earnedXp} XP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Mono',
                        color: isMvp ? AppTheme.amber : AppTheme.cyan,
                      ),
                    ),
                  ],
                ),
                if (op.unlockedBadges.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: op.unlockedBadges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(fontSize: 8, color: AppTheme.cyan, fontFamily: 'IBM Plex Mono'),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getRoleColor(InvestigatorRole role) {
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
