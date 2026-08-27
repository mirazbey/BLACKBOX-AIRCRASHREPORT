import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../models/evidence_model.dart';
import '../../models/tactical_ping_model.dart';
import '../../providers/investigation_provider.dart';
import '../../services/audio_haptic_service.dart';

class InformationBrokerWidget extends StatefulWidget {
  const InformationBrokerWidget({super.key});

  @override
  State<InformationBrokerWidget> createState() => _InformationBrokerWidgetState();
}

class _InformationBrokerWidgetState extends State<InformationBrokerWidget> {
  final Set<String> _sharedToPublicPool = {};

  void _shareEvidenceToPool(EvidenceNode ev) {
    AudioHapticService.playPinDrop();
    setState(() {
      _sharedToPublicPool.add(ev.id);
    });

    final provider = context.read<InvestigationProvider>();
    if (!provider.discoveredEvidenceIds.contains(ev.id)) {
      provider.discoverEvidence(ev.id);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delil Masaya Sürüldü: ${ev.title} (+50 Sinerji XP)'),
        backgroundColor: AppTheme.surfaceHighlight,
      ),
    );
  }

  void _requestEvidenceFromRole(InvestigatorRole targetRole) {
    AudioHapticService.playRadioClick();
    final provider = context.read<InvestigationProvider>();
    provider.sendTacticalPing(
      directiveType: DirectiveType.requestMaintenanceCheck,
      message: '${targetRole.operatorCode} uzmanından elindeki gizli telemetri/bakım kaydını masaya sürmesi talep edildi!',
      toRole: targetRole,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${targetRole.displayName} uzmanına delil talebi iletildi.'),
        backgroundColor: AppTheme.surfaceHighlight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final currentRole = provider.currentRole;
    final allEvidences = provider.allEvidences;

    final myEvidences = allEvidences.where((e) {
      // In solo mode all visible; in coop role filtered
      return e.visibleToRoles.contains(currentRole.roleIndex) || e.sourceRef.toLowerCase() == currentRole.name.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('BİLGİ BROKERI & DELİL HAVUZU'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Overview Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.glassBox(
                borderColor: AppTheme.amber,
                borderWidth: 1.2,
                backgroundColor: const Color(0xFF111722),
                borderRadius: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: _getRoleColor(currentRole),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          currentRole.operatorCode,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'IBM Plex Mono'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ÖZEL DELİL KASANIZ (${myEvidences.length} ADET)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Asimetrik rolünüz gereği yalnızca uzmanlık alanınıza ait delilleri görürsünüz. Kaza zincirini çözmek için delillerinizi ortak masaya sürün veya diğer uzmanlardan talep edin.',
                    style: TextStyle(fontSize: 10, color: AppTheme.textDim, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section 1: My Classified Evidence Cards
            Text(
              '1. ELİNİZDEKİ GİZLİ DELİLLER (ROLÜNÜZE ÖZEL)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.amber,
                fontFamily: 'IBM Plex Mono',
              ),
            ),
            const SizedBox(height: 8),
            ...myEvidences.map((ev) {
              final isShared = _sharedToPublicPool.contains(ev.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: AppTheme.glassBox(
                  borderColor: isShared ? AppTheme.green : AppTheme.surfaceBorder,
                  backgroundColor: const Color(0xFF10141A),
                  borderRadius: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ev.title,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ev.description,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textDim),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: isShared ? null : () => _shareEvidenceToPool(ev),
                      icon: Icon(isShared ? Icons.check : Icons.share, size: 14, color: isShared ? AppTheme.green : Colors.black),
                      label: Text(
                        isShared ? 'MASADA' : 'MASAYA SÜR',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isShared ? AppTheme.green : Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isShared ? AppTheme.surfaceHighlight : AppTheme.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Section 2: Other 4 Specialists & Direct Requests
            Text(
              '2. DİĞER 4 OPERATÖRDEN DELİL TALEBİ',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.cyan,
                fontFamily: 'IBM Plex Mono',
              ),
            ),
            const SizedBox(height: 8),
            ...InvestigatorRole.values.where((r) => r != currentRole).map((role) {
              final roleColor = _getRoleColor(role);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: AppTheme.glassBox(
                  borderColor: AppTheme.surfaceBorder,
                  backgroundColor: const Color(0xFF0F131A),
                  borderRadius: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: roleColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        role.operatorCode,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'IBM Plex Mono'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.displayName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          Text(
                            'Korumalı Veri: ${_getProtectedDataType(role)}',
                            style: const TextStyle(fontSize: 9, color: AppTheme.textFaint),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _requestEvidenceFromRole(role),
                      icon: const Icon(Icons.send_outlined, size: 13, color: AppTheme.cyan),
                      label: const Text('TALEP ET', style: TextStyle(fontSize: 9, color: AppTheme.cyan)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.cyan),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getProtectedDataType(InvestigatorRole role) {
    switch (role) {
      case InvestigatorRole.telemetryFdr:
        return 'FDR Pitch/Roll Ham Telemetrisi';
      case InvestigatorRole.acousticCvr:
        return 'Kokpit 4-Kanallı Ses Kayıtları & CAM';
      case InvestigatorRole.avionicsFlir:
        return 'Termal FLIR & Meteoroloji Uydusu';
      case InvestigatorRole.maintenanceOps:
        return 'MEL Ertelenen Bakım & Logbook';
      case InvestigatorRole.humanFactorsPsych:
        return 'Görgü Tanığı & Mürettebat Sorguları';
    }
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
