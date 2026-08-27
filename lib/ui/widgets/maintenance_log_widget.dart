import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class MaintenanceLogWidget extends StatelessWidget {
  const MaintenanceLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final logs = provider.maintenanceLogs;

    return ListView(
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
              Row(
                children: [
                  const Icon(Icons.build_circle, color: AppTheme.violet, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'UÇAK TEKNİK KÜTÜK DEFTERİ (AIRCRAFT TECH LOG)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.violet),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'TC-ANL kuyruk tescilli Airbus A330 uçağının son 15 günlük bakım ertelemeleri ve MEL kayıtları.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...logs.map((log) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: log.isDeferred ? AppTheme.red : AppTheme.surfaceBorder,
                width: log.isDeferred ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('LOG #${log.logId}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(width: 8),
                    Text('[${log.date} — ${log.station}]', style: Theme.of(context).textTheme.labelSmall),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: log.isDeferred ? AppTheme.redDim : AppTheme.cyanDim,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log.isDeferred ? 'MEL İLE ERTELENDİ' : 'TAMAMLANDI',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: log.isDeferred ? AppTheme.red : AppTheme.cyan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('ARIZA BİLDİRİMİ:', style: Theme.of(context).textTheme.labelSmall),
                Text(log.defectDescription, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 6),
                Text('UYGULANAN İŞLEM:', style: Theme.of(context).textTheme.labelSmall),
                Text(log.actionTaken, style: Theme.of(context).textTheme.bodyMedium),
                if (log.linkedEvidenceId != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.discoverEvidence(log.linkedEvidenceId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bakım Delili Masaya Eklendi!')),
                        );
                      },
                      icon: const Icon(Icons.push_pin, size: 14),
                      label: const Text('ŞÜPHELİ ARIZAYI PİNLE', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.violet,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
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
