import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';
import 'home_screen.dart';

class ResultRevealScreen extends StatelessWidget {
  const ResultRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final result = provider.lastEvaluationResult;

    if (result == null) {
      return const Scaffold(body: Center(child: Text('Sonuç bulunamadı.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SORUŞTURMA SONUÇ RAPORU'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Total Score Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.amber, width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  'TOPLAM DOĞRULUK SKORU',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '%${result.totalScore}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.amber,
                    fontSize: 44,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.rankTitle.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.cyan),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 50 / 35 / 15 Metric Breakdown
          Row(
            children: [
              Expanded(
                child: _ScoreBox(
                  title: 'NEDENSELLİK',
                  score: '${result.causalAccuracyScore}/50',
                  color: AppTheme.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ScoreBox(
                  title: 'DELİL GÜCÜ',
                  score: '${result.evidenceQualityScore}/35',
                  color: AppTheme.cyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ScoreBox(
                  title: 'VERİMLİLİK',
                  score: '${result.efficiencyScore}/15',
                  color: AppTheme.violet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Official Findings Feedback
          Container(
            padding: const EdgeInsets.all(16),
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
                    const Icon(Icons.verified, color: AppTheme.cyan, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'RESMİ SORUŞTURMA KARARI',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.cyan),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(result.summaryFeedback, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 14),
                Text('DOĞRULANAN KÖK NEDENLER:', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                ...result.correctCauses.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.green, size: 14),
                      const SizedBox(width: 6),
                      Expanded(child: Text(c, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary))),
                    ],
                  ),
                )),
                if (result.falseTheories.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text('YANILTICI İPUÇLARI / ÇÜRÜTÜLEN TEORİLER:', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  ...result.falseTheories.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: AppTheme.red, size: 14),
                        const SizedBox(width: 6),
                        Expanded(child: Text(f, style: const TextStyle(fontSize: 12, color: AppTheme.red))),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Return Home Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.amber,
                foregroundColor: Colors.black,
              ),
              child: const Text('ANA ÜSSE DÖN'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String title;
  final String score;
  final Color color;

  const _ScoreBox({
    required this.title,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 9, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono')),
          const SizedBox(height: 4),
          Text(score, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
