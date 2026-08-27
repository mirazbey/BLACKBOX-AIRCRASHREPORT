import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../models/tactical_ping_model.dart';
import '../../providers/investigation_provider.dart';
import '../../services/audio_haptic_service.dart';

class TacticalCommsDrawerWidget extends StatefulWidget {
  const TacticalCommsDrawerWidget({super.key});

  @override
  State<TacticalCommsDrawerWidget> createState() => _TacticalCommsDrawerWidgetState();
}

class _TacticalCommsDrawerWidgetState extends State<TacticalCommsDrawerWidget> {
  final TextEditingController _msgController = TextEditingController();
  DirectiveType _selectedDirective = DirectiveType.flagContradiction;

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendCustomDirective() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<InvestigationProvider>();
    provider.sendTacticalPing(
      directiveType: _selectedDirective,
      message: text,
      targetTimestampSeconds: provider.currentTimeSeconds,
    );

    AudioHapticService.playRadioClick();
    _msgController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final pings = provider.tacticalPings.reversed.toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0C1017),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(top: BorderSide(color: AppTheme.amber, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header
          Row(
            children: [
              const Icon(Icons.forum, color: AppTheme.amber, size: 18),
              const SizedBox(width: 8),
              Text(
                'KRİZ MASASI CANLI TAKTİK AKIŞI',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.amber,
                  fontFamily: 'IBM Plex Mono',
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppTheme.textDim, size: 20),
              ),
            ],
          ),
          const Divider(color: AppTheme.surfaceBorder, height: 16),

          // Dispatched Directive Messages Stream
          Expanded(
            child: pings.isEmpty
                ? const Center(
                    child: Text(
                      'Henüz taktik direktif veya telsiz mesajı gönderilmedi.',
                      style: TextStyle(fontSize: 11, color: AppTheme.textFaint),
                    ),
                  )
                : ListView.builder(
                    itemCount: pings.length,
                    itemBuilder: (context, index) {
                      final ping = pings[index];
                      final roleColor = _getRoleColor(ping.fromRole);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceAlt,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: roleColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    ping.fromRole.operatorCode,
                                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'IBM Plex Mono'),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceHighlight,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    _formatDirectiveType(ping.directiveType),
                                    style: const TextStyle(fontSize: 8, color: AppTheme.cyan, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'T+${ping.targetTimestampSeconds ?? provider.currentTimeSeconds}s',
                                  style: const TextStyle(fontSize: 9, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ping.message,
                              style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 10),

          // Directive Composer & Send Action
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildDirectiveChip(DirectiveType.flagContradiction, '🔍 ÇELİŞKİ'),
                    const SizedBox(width: 4),
                    _buildDirectiveChip(DirectiveType.urgentTimeSync, '⏱️ SENKRON'),
                    const SizedBox(width: 4),
                    _buildDirectiveChip(DirectiveType.requestInterrogation, '👤 SORGU'),
                    const SizedBox(width: 4),
                    _buildDirectiveChip(DirectiveType.requestMaintenanceCheck, '🛠️ MEL'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Ekibe telsiz mesajı veya koordinat fırlat...',
                          hintStyle: TextStyle(fontSize: 11, color: AppTheme.textFaint),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendCustomDirective,
                      icon: const Icon(Icons.send, color: AppTheme.amber, size: 18),
                      tooltip: 'Gönder',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectiveChip(DirectiveType type, String label) {
    final isSelected = _selectedDirective == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedDirective = type),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.amber.withAlpha(50) : AppTheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isSelected ? AppTheme.amber : AppTheme.surfaceBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.amber : AppTheme.textDim,
                fontFamily: 'IBM Plex Mono',
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDirectiveType(DirectiveType type) {
    switch (type) {
      case DirectiveType.urgentTimeSync:
        return 'ZAMAN SENKRONU';
      case DirectiveType.flagContradiction:
        return 'ÇELİŞKİ BİLDİRİMİ';
      case DirectiveType.requestInterrogation:
        return 'SORGU TALEP';
      case DirectiveType.requestMaintenanceCheck:
        return 'MEL KONTROL';
      case DirectiveType.requestFlirEnhance:
        return 'FLIR ODAKLANMA';
      case DirectiveType.confirmHypothesis:
        return 'HİPOTEZ ONAYI';
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
