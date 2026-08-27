import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../services/case_repository.dart';
import '../../providers/investigation_provider.dart';
import 'investigation_screen.dart';

class CaseDossierLibraryScreen extends StatelessWidget {
  const CaseDossierLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cases = CaseRepository.allCaseManifests;
    final activeCaseId = context.watch<InvestigationProvider>().activeCase.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GİZLİ VAKA DOSYALARI ARŞİVİ'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cases.length,
        itemBuilder: (context, index) {
          final c = cases[index];
          final isSelected = c.id == activeCaseId;
          final isClassified = c.difficulty == CaseDifficulty.extreme;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1B2330) : AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppTheme.amber
                    : (isClassified ? AppTheme.red.withAlpha(120) : AppTheme.surfaceBorder),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.amber.withAlpha(40),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isClassified ? AppTheme.redDim : AppTheme.cyanDim,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isClassified ? 'GİZLİ (KİLİTLİ)' : 'AKTİF VAKA',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Mono',
                            color: isClassified ? AppTheme.red : AppTheme.cyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        c.code,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDim,
                          fontFamily: 'IBM Plex Mono',
                        ),
                      ),
                      const Spacer(),
                      _buildDifficultyBadge(c.difficulty),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title & Subtitle
                  Text(
                    c.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      color: isSelected ? AppTheme.amber : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textDim,
                      fontSize: 12,
                    ),
                  ),
                  const Divider(color: AppTheme.surfaceBorder, height: 20),

                  // Metrics Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoColumn('UÇAK', c.aircraft.model),
                      ),
                      Expanded(
                        child: _buildInfoColumn('ROTA', '${c.flight.departure} ➔ ${c.flight.destination}'),
                      ),
                      Expanded(
                        child: _buildInfoColumn('KAYIP', '${c.flight.soulsOnBoard} Can'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Initial Summary Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      c.flight.initialSummary,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary, height: 1.3),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: isClassified
                          ? null
                          : () {
                              context.read<InvestigationProvider>().loadCase(c);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Vaka Yüklendi: ${c.title}')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const InvestigationScreen()),
                              );
                            },
                      icon: Icon(
                        isClassified ? Icons.lock : Icons.flight_land,
                        size: 16,
                        color: isClassified ? AppTheme.textFaint : Colors.black,
                      ),
                      label: Text(
                        isClassified
                            ? 'RÜTBE 5 GEREKLİ (KİLİTLİ)'
                            : (isSelected ? 'SORUŞTURMAYA DEVAM ET' : 'BU VAKAYI BAŞLAT'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isClassified ? AppTheme.textFaint : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isClassified ? AppTheme.surfaceBorder : AppTheme.amber,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono')),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge(CaseDifficulty difficulty) {
    Color color;
    String label;
    switch (difficulty) {
      case CaseDifficulty.easy:
        color = AppTheme.green;
        label = 'KOLAY';
        break;
      case CaseDifficulty.medium:
        color = AppTheme.cyan;
        label = 'ORTA';
        break;
      case CaseDifficulty.hard:
        color = AppTheme.amber;
        label = 'ZOR';
        break;
      case CaseDifficulty.extreme:
        color = AppTheme.red;
        label = 'UZMAN';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color, fontFamily: 'IBM Plex Mono'),
      ),
    );
  }
}
