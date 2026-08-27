import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../models/room_state_model.dart';
import '../../providers/investigation_provider.dart';
import '../../services/auth_service.dart';
import '../../services/audio_haptic_service.dart';
import 'investigation_screen.dart';

class MultiplayerRoomScreen extends StatefulWidget {
  final String initialRoomCode;
  final bool isHost;

  const MultiplayerRoomScreen({
    super.key,
    this.initialRoomCode = 'BBX-447',
    this.isHost = true,
  });

  @override
  State<MultiplayerRoomScreen> createState() => _MultiplayerRoomScreenState();
}

class _MultiplayerRoomScreenState extends State<MultiplayerRoomScreen> {
  late String roomCode;
  InvestigatorRole mySelectedRole = InvestigatorRole.telemetryFdr;
  bool isMyReady = true;

  late Map<InvestigatorRole, RoomSlot> slots;

  @override
  void initState() {
    super.initState();
    roomCode = widget.initialRoomCode;

    slots = {
      InvestigatorRole.telemetryFdr: const RoomSlot(
        role: InvestigatorRole.telemetryFdr,
        occupantUserId: 'usr_me',
        occupantDisplayName: 'Müfettiş Demir (Sen)',
        avatarCode: '🎯',
        isReady: true,
        isHost: true,
      ),
      InvestigatorRole.acousticCvr: const RoomSlot(
        role: InvestigatorRole.acousticCvr,
        occupantUserId: 'usr_peer_1',
        occupantDisplayName: 'Müfettiş Selin',
        avatarCode: '🎧',
        isReady: true,
      ),
      InvestigatorRole.avionicsFlir: const RoomSlot(
        role: InvestigatorRole.avionicsFlir,
        occupantUserId: 'usr_peer_2',
        occupantDisplayName: 'Müfettiş Can',
        avatarCode: '📹',
        isReady: false,
      ),
      InvestigatorRole.maintenanceOps: const RoomSlot(
        role: InvestigatorRole.maintenanceOps,
        occupantUserId: 'usr_peer_3',
        occupantDisplayName: 'Müfettiş Murat',
        avatarCode: '🛠️',
        isReady: true,
      ),
      InvestigatorRole.humanFactorsPsych: const RoomSlot(
        role: InvestigatorRole.humanFactorsPsych,
        occupantUserId: null, // Empty Seat
        isReady: false,
      ),
    };
  }

  void _switchSeat(InvestigatorRole targetRole) {
    if (slots[targetRole]?.isOccupied == true && targetRole != mySelectedRole) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu uzmanlık koltuğu dolu!')),
      );
      return;
    }

    AudioHapticService.playPinDrop();
    setState(() {
      // Clear old seat
      slots[mySelectedRole] = RoomSlot(role: mySelectedRole);
      // Occupy new seat
      mySelectedRole = targetRole;
      slots[targetRole] = RoomSlot(
        role: targetRole,
        occupantUserId: 'usr_me',
        occupantDisplayName: 'Müfettiş Demir (Sen)',
        avatarCode: '🎯',
        isReady: isMyReady,
        isHost: widget.isHost,
      );
    });

    context.read<InvestigationProvider>().switchRole(targetRole);
  }

  void _toggleReady() {
    AudioHapticService.playRadioClick();
    setState(() {
      isMyReady = !isMyReady;
      slots[mySelectedRole] = slots[mySelectedRole]!.copyWith(isReady: isMyReady);
    });
  }

  void _launchInvestigation() {
    AudioHapticService.playRadioClick();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const InvestigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthService>().currentUser;
    final occupiedCount = slots.values.where((s) => s.isOccupied).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('CANLI KRİZ ODASI LOBİSİ'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Code & Share Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.glassBox(
                  borderColor: AppTheme.amber,
                  borderWidth: 1.5,
                  backgroundColor: const Color(0xFF101620),
                  borderRadius: 10,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ODA BAĞLANTI KODU',
                          style: TextStyle(fontSize: 9, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          roomCode,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.amber,
                            fontFamily: 'IBM Plex Mono',
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: roomCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Oda Kodu Kopyalandı: $roomCode')),
                        );
                      },
                      icon: const Icon(Icons.copy, color: AppTheme.amber),
                      tooltip: 'Kodu Kopyala',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lobby Header
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '5 OPERATÖR KOLTUK DAĞILIMI ($occupiedCount / 5 BAĞLI)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontFamily: 'IBM Plex Mono',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 5 Specialist Seat Cards
              Expanded(
                child: ListView(
                  children: InvestigatorRole.values.map((role) {
                    final slot = slots[role]!;
                    final isMySeat = role == mySelectedRole;
                    final roleColor = _getRoleColor(role);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: AppTheme.glassBox(
                        borderColor: isMySeat ? roleColor : AppTheme.surfaceBorder,
                        borderWidth: isMySeat ? 2.0 : 1.0,
                        backgroundColor: isMySeat ? roleColor.withAlpha(25) : const Color(0xFF101419),
                        borderRadius: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: roleColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              role.operatorCode,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'IBM Plex Mono',
                              ),
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
                                const SizedBox(height: 2),
                                Text(
                                  slot.isOccupied
                                      ? (isMySeat ? '${authUser?.displayName ?? 'Sen'} (Aktif)' : slot.occupantDisplayName!)
                                      : 'BOŞ KOLTUK — Katılmak için dokunun',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: slot.isOccupied ? AppTheme.textDim : AppTheme.textFaint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (slot.isOccupied) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: slot.isReady ? AppTheme.green.withAlpha(40) : AppTheme.amber.withAlpha(40),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: slot.isReady ? AppTheme.green : AppTheme.amber),
                              ),
                              child: Text(
                                slot.isReady ? '✓ HAZIR' : '⏳ BEKLİYOR',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: slot.isReady ? AppTheme.green : AppTheme.amber,
                                  fontFamily: 'IBM Plex Mono',
                                ),
                              ),
                            ),
                          ] else ...[
                            OutlinedButton(
                              onPressed: () => _switchSeat(role),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: roleColor,
                                side: BorderSide(color: roleColor),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                              child: const Text('KOLTUĞA GEÇ', style: TextStyle(fontSize: 9)),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Bottom Ready & Launch Controls
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleReady,
                      icon: Icon(
                        isMyReady ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isMyReady ? AppTheme.green : AppTheme.amber,
                        size: 16,
                      ),
                      label: Text(isMyReady ? 'HAZIR' : 'HAZIRLAN'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isMyReady ? AppTheme.green : AppTheme.amber,
                        side: BorderSide(color: isMyReady ? AppTheme.green : AppTheme.amber),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _launchInvestigation,
                      icon: const Icon(Icons.rocket_launch, size: 18, color: Colors.black),
                      label: const Text('SORUŞTURMAYI BAŞLAT'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
