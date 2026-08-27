import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class InterrogationViewWidget extends StatefulWidget {
  const InterrogationViewWidget({super.key});

  @override
  State<InterrogationViewWidget> createState() => _InterrogationViewWidgetState();
}

class _InterrogationViewWidgetState extends State<InterrogationViewWidget> {
  int selectedSuspectIndex = 0;
  String? activeQuestionId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final suspects = provider.suspects;
    final suspect = suspects[selectedSuspectIndex];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Suspect Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(suspects.length, (i) {
              final isSelected = selectedSuspectIndex == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  avatar: Text(suspects[i].avatarCode),
                  label: Text(
                    suspects[i].name,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : AppTheme.textDim,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.amber,
                  backgroundColor: AppTheme.surfaceAlt,
                  onSelected: (_) {
                    setState(() {
                      selectedSuspectIndex = i;
                      activeQuestionId = null;
                    });
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // Suspect Profile & Stress Telemetry Card
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
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Center(
                      child: Text(suspect.avatarCode, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(suspect.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                        Text(suspect.title, style: const TextStyle(fontSize: 11, color: AppTheme.amber, fontWeight: FontWeight.bold)),
                        Text(suspect.organization, style: const TextStyle(fontSize: 10, color: AppTheme.textFaint)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppTheme.surfaceBorder, height: 24),
              Row(
                children: [
                  const Icon(Icons.favorite, color: AppTheme.red, size: 14),
                  const SizedBox(width: 6),
                  const Text('PSİKOLOJİK STRES İNDEKSİ:', style: TextStyle(fontSize: 10, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono')),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.redDim,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      suspect.stressStatus,
                      style: const TextStyle(fontSize: 9, color: AppTheme.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Questions List & Dialogue Tree
        Text('SORUŞTURMA VE ÇAPRAZ SORGU SEÇENEKLERİ:', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        ...suspect.questions.map((q) {
          final isExpanded = activeQuestionId == q.id;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isExpanded ? AppTheme.surfaceBorder : AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isExpanded ? AppTheme.amber : AppTheme.surfaceBorder,
                width: isExpanded ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      activeQuestionId = isExpanded ? null : q.id;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.psychology, color: AppTheme.amber, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            q.questionText,
                            style: TextStyle(
                              fontSize: 12,
                              color: isExpanded ? AppTheme.amber : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: AppTheme.textDim,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const Divider(color: AppTheme.surfaceBorder, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('İFADE VE CEVAP:', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.cyan)),
                        const SizedBox(height: 4),
                        Text(
                          '"${q.answerText}"',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppTheme.textPrimary, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Text('ADLİ PSİKOLOG GÖZLEMİ:', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.amber)),
                        const SizedBox(height: 2),
                        Text(
                          q.stressReaction,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textDim),
                        ),
                        if (q.unlocksEvidenceId != null) ...[
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                provider.discoverEvidence(q.unlocksEvidenceId!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('İtiraf Delili Masaya Eklendi: ${q.unlockedEvidenceTitle}')),
                                );
                              },
                              icon: const Icon(Icons.push_pin, size: 14, color: Colors.black),
                              label: const Text('İTİRAFI KARA TAHTAYA PİNLE', style: TextStyle(fontSize: 11, color: Colors.black)),
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
              ],
            ),
          );
        }),
      ],
    );
  }
}
