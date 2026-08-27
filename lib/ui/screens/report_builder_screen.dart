import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/evaluation_model.dart';
import '../../providers/investigation_provider.dart';
import '../widgets/jury_voting_modal.dart';
import '../widgets/causal_graph_inspector_widget.dart';

class ReportBuilderScreen extends StatefulWidget {
  const ReportBuilderScreen({super.key});

  @override
  State<ReportBuilderScreen> createState() => _ReportBuilderScreenState();
}

class _ReportBuilderScreenState extends State<ReportBuilderScreen> {
  String? selectedTriggerCause;
  String? selectedHumanErrorCause;
  String? selectedLatentCause;

  final List<String> triggerOptions = [
    'Pitot Tüplerinin Eşzamanlı Donması & Güvenilmez Sürat',
    'Çift Motor Yangını ve İtiş Kaybı',
    'Kabin İçi Bomba / Ani Patlayıcı Dekompresyon',
  ];

  final List<String> humanOptions = [
    'Pilotun Hatalı Lövye Geri Çekişi (Stall Girişi)',
    'Kaptan Pilotun Kasıtlı Dalış Girişimi',
    'Kule Talimatlarına Uyulmaması',
  ];

  final List<String> latentOptions = [
    'Pitot Isıtıcı Direncinin Ertelenmiş Bakımı (MEL)',
    'Yakıt Tankı Montaj Hatası',
    'Kargo Ağırlık Dengesizliği',
  ];

  @override
  void initState() {
    super.initState();
    selectedTriggerCause = triggerOptions.first;
    selectedHumanErrorCause = humanOptions.first;
    selectedLatentCause = latentOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESMİ NTSB KAZA RAPORU'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İSVİÇRE PEYNİRİ NEDENSELLİK ZİNCİRİ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber),
                ),
                const SizedBox(height: 4),
                Text(
                  'Delil masanızdaki bulgulara dayanarak kazayı oluşturan doğrudan tetikleyici, pilot reaksiyonu ve gizli organizasyonel faktörü seçiniz.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Causal DAG Inspector
          const CausalGraphInspectorWidget(),
          const SizedBox(height: 20),

          // 1. Doğrudan Tetikleyici (Direct Trigger)
          _buildSelectorSection(
            title: '1. DOĞRUDAN TETİKLEYİCİ FAKTÖR (DIRECT TRIGGER)',
            subtitle: 'Uçuşun seyrini bozan ilk mekanik/sensör olayı',
            options: triggerOptions,
            selectedValue: selectedTriggerCause,
            accentColor: AppTheme.amber,
            onChanged: (val) => setState(() => selectedTriggerCause = val),
          ),
          const SizedBox(height: 16),

          // 2. İnsan Faktörü / Pilot Tepkisi (Active Human Mistake)
          _buildSelectorSection(
            title: '2. İNSAN FAKTÖRÜ & MÜRETTEBAT TEPKİSİ (CREW RESPONSE)',
            subtitle: 'Kokpit ekibinin duruma verdiği operasyonel reaksiyon',
            options: humanOptions,
            selectedValue: selectedHumanErrorCause,
            accentColor: AppTheme.red,
            onChanged: (val) => setState(() => selectedHumanErrorCause = val),
          ),
          const SizedBox(height: 16),

          // 3. Gizli / Bakım Faktörü (Latent Failure)
          _buildSelectorSection(
            title: '3. GİZLİ ORGANİZASYONEL / BAKIM HATASI (LATENT FACTOR)',
            subtitle: 'Kazadan önce yapılmış ihmal veya ertelenmiş arıza',
            options: latentOptions,
            selectedValue: selectedLatentCause,
            accentColor: AppTheme.violet,
            onChanged: (val) => setState(() => selectedLatentCause = val),
          ),
          const SizedBox(height: 28),

          // Submit Action
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                final findings = [
                  SubmittedFinding(
                    categoryTitle: 'Tetikleyici',
                    selectedCauseTitle: selectedTriggerCause!,
                    linkedEvidenceIds: provider.discoveredEvidenceIds.toList(),
                  ),
                  SubmittedFinding(
                    categoryTitle: 'İnsan Faktörü',
                    selectedCauseTitle: selectedHumanErrorCause!,
                    linkedEvidenceIds: provider.discoveredEvidenceIds.toList(),
                  ),
                  SubmittedFinding(
                    categoryTitle: 'Gizli Bakım',
                    selectedCauseTitle: selectedLatentCause!,
                    linkedEvidenceIds: provider.discoveredEvidenceIds.toList(),
                  ),
                ];

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => JuryVotingModal(
                    submittedCauses: [
                      selectedTriggerCause!,
                      selectedHumanErrorCause!,
                      selectedLatentCause!,
                    ],
                    onReportSealed: () {
                      provider.submitInvestigationReport(findings);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.gavel, color: Colors.black),
              label: const Text('RAPORU HEYETE SUN VE OYLAMAYI BAŞLAT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.amber,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSelectorSection({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selectedValue,
    required Color accentColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: accentColor, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono')),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textFaint)),
          const SizedBox(height: 10),
          ...options.map((opt) {
            final isSelected = selectedValue == opt;
            return InkWell(
              onTap: () => onChanged(opt),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withAlpha(40) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? accentColor : AppTheme.surfaceBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? accentColor : AppTheme.textFaint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppTheme.textPrimary : AppTheme.textDim,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
