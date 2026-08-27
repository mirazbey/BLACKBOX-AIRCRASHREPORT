import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../screens/result_reveal_screen.dart';

class JuryVotingModal extends StatefulWidget {
  final List<String> submittedCauses;
  final VoidCallback onReportSealed;

  const JuryVotingModal({
    super.key,
    required this.submittedCauses,
    required this.onReportSealed,
  });

  @override
  State<JuryVotingModal> createState() => _JuryVotingModalState();
}

class _JuryVotingModalState extends State<JuryVotingModal> {
  final Map<InvestigatorRole, bool?> operatorVotes = {
    InvestigatorRole.telemetryFdr: true,
    InvestigatorRole.maintenanceOps: true,
    InvestigatorRole.humanFactorsPsych: true,
    InvestigatorRole.avionicsFlir: null, // Pending
    InvestigatorRole.acousticCvr: null,   // Pending
  };

  int remainingSeconds = 20;
  Timer? _countdownTimer;
  bool hasVoted = false;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
          // Simulate peer votes arriving
          if (remainingSeconds == 16) {
            operatorVotes[InvestigatorRole.avionicsFlir] = true;
          }
          if (remainingSeconds == 12) {
            operatorVotes[InvestigatorRole.acousticCvr] = true;
          }
        });
      } else {
        _countdownTimer?.cancel();
        _finalizeReport();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  int get approveCount => operatorVotes.values.where((v) => v == true).length;
  bool get hasMajority => approveCount >= 3;

  void _finalizeReport() {
    widget.onReportSealed();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResultRevealScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.glassBox(
          borderColor: hasMajority ? AppTheme.green : AppTheme.amber,
          borderWidth: 2,
          backgroundColor: const Color(0xFF0D1219),
          borderRadius: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              children: [
                Icon(
                  Icons.gavel,
                  color: hasMajority ? AppTheme.green : AppTheme.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'NTSB KRİZ HEYETİ OYLAMASI',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: hasMajority ? AppTheme.green : AppTheme.amber,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHighlight,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.surfaceBorder),
                  ),
                  child: Text(
                    '${remainingSeconds}s',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.amber, fontFamily: 'IBM Plex Mono'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Teslim edilen İsviçre Peyniri Kök Neden Raporu heyet onayına sunuldu. Resmi mühür için en az 3/5 oy gereklidir.',
              style: const TextStyle(fontSize: 11, color: AppTheme.textDim, height: 1.3),
            ),
            const SizedBox(height: 14),

            // Submitted Causes Summary
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TESLİM EDİLEN KAZA TEZLERİ:',
                    style: TextStyle(fontSize: 9, color: AppTheme.cyan, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                  ),
                  const SizedBox(height: 6),
                  ...widget.submittedCauses.take(3).map((cause) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_right, size: 14, color: AppTheme.amber),
                        Expanded(
                          child: Text(
                            cause,
                            style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 5-Operator Voting Table
            const Text(
              '5 OPERATÖR CANLI OY DAĞILIMI:',
              style: TextStyle(fontSize: 9, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'),
            ),
            const SizedBox(height: 8),

            ...operatorVotes.entries.map((entry) {
              final role = entry.key;
              final vote = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: vote == true ? AppTheme.green.withAlpha(80) : AppTheme.surfaceBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(role),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        role.operatorCode,
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'IBM Plex Mono'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        role.displayName,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                    ),
                    if (vote == true) ...[
                      const Icon(Icons.check_circle, color: AppTheme.green, size: 14),
                      const SizedBox(width: 4),
                      const Text('ONAYLADI', style: TextStyle(fontSize: 9, color: AppTheme.green, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono')),
                    ] else if (vote == false) ...[
                      const Icon(Icons.cancel, color: AppTheme.red, size: 14),
                      const SizedBox(width: 4),
                      const Text('ŞERH DÜŞTÜ', style: TextStyle(fontSize: 9, color: AppTheme.red, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono')),
                    ] else ...[
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppTheme.amber),
                      ),
                      const SizedBox(width: 6),
                      const Text('OY BEKLENİYOR', style: TextStyle(fontSize: 9, color: AppTheme.amber, fontFamily: 'IBM Plex Mono')),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            // Majority Indicator
            Row(
              children: [
                Text(
                  'ÇOĞUNLUK: $approveCount / 5 ONAY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Mono',
                    color: hasMajority ? AppTheme.green : AppTheme.amber,
                  ),
                ),
                const Spacer(),
                Text(
                  hasMajority ? '✓ RAPOR GEÇERLİ' : '⏳ OYLAR BEKLENİYOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Mono',
                    color: hasMajority ? AppTheme.green : AppTheme.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasVoted
                        ? null
                        : () {
                            setState(() {
                              hasVoted = true;
                              operatorVotes[InvestigatorRole.telemetryFdr] = false;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.red,
                      side: const BorderSide(color: AppTheme.red),
                    ),
                    child: const Text('ŞERH DÜŞ', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _countdownTimer?.cancel();
                      _finalizeReport();
                    },
                    icon: const Icon(Icons.verified, size: 16, color: Colors.black),
                    label: Text(
                      hasMajority ? 'MÜHÜRLE VE FİNALİ İZLE' : 'HEMEN ONAYLA',
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasMajority ? AppTheme.green : AppTheme.amber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
