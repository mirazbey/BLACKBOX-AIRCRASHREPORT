import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../providers/matchmaking_provider.dart';
import '../../providers/investigation_provider.dart';
import 'investigation_screen.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mm = context.watch<MatchmakingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SORUŞTURMA AĞI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            mm.reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Radar Pulse Animation Placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceAlt,
                  border: Border.all(color: AppTheme.amber, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.amber.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.radar, size: 54, color: AppTheme.amber),
              ),
              const SizedBox(height: 28),

              Text(
                mm.searchStatusText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              if (mm.status == MatchStatus.searching || mm.status == MatchStatus.joining) ...[
                const SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    backgroundColor: AppTheme.surfaceBorder,
                    valueColor: AlwaysStoppedAnimation(AppTheme.amber),
                  ),
                ),
              ],

              if (mm.status == MatchStatus.found && mm.currentSession != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.cyan),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ATANAN UZMANLIK ROLÜNÜZ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getRoleTitle(mm.currentSession!.localRoleIndex),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.cyan),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Oda Kodu: ${mm.currentSession!.roomCode}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final role = _getRoleEnum(mm.currentSession!.localRoleIndex);
                      context.read<InvestigationProvider>().switchRole(role);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const InvestigationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cyan,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('SORUŞTURMA MASASINA GİRİŞ YAP'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleTitle(int roleIndex) {
    switch (roleIndex) {
      case 1:
        return 'Telemetri & FDR Mühendisi (OP-01)';
      case 2:
        return 'Akustik & CVR Analisti (OP-02)';
      case 3:
        return 'FLIR & Video Rekonstrüksiyon (OP-03)';
      case 4:
        return 'Adli Bakım & MEL Müfettişi (OP-04)';
      case 5:
        return 'Adli Psikolog & CRM Sorgu (OP-05)';
      default:
        return 'Kaza Soruşturma Uzmanı';
    }
  }

  InvestigatorRole _getRoleEnum(int roleIndex) {
    switch (roleIndex) {
      case 1:
        return InvestigatorRole.telemetryFdr;
      case 2:
        return InvestigatorRole.acousticCvr;
      case 3:
        return InvestigatorRole.avionicsFlir;
      case 4:
        return InvestigatorRole.maintenanceOps;
      case 5:
        return InvestigatorRole.humanFactorsPsych;
      default:
        return InvestigatorRole.telemetryFdr;
    }
  }
}
