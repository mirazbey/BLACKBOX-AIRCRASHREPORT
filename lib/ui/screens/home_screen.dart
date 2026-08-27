import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../providers/matchmaking_provider.dart';
import 'matchmaking_screen.dart';
import 'investigation_screen.dart';
import 'case_dossier_library_screen.dart';
import 'inspector_profile_screen.dart';
import 'multiplayer_room_screen.dart';
import 'bureau_leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar / Bureau Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'KAZA SORUŞTURMA DAİRESİ',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.amber,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InspectorProfileScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceAlt,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.amber),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.badge, size: 12, color: AppTheme.amber),
                          SizedBox(width: 4),
                          Text(
                            'SİCİL: #44102',
                            style: TextStyle(fontSize: 10, color: AppTheme.amber, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Title
              Text(
                'BLACK BOX',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'AIR CRASH BUREAU',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.amber,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gerçek havacılık raporlarından kurgulanmış 5 operatörlü dedüksiyon simülasyonu.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),

              // Active Highlight Case Card (Clickable to Archive)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CaseDossierLibraryScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: AppTheme.glassBox(
                    borderColor: AppTheme.amber,
                    borderWidth: 1.5,
                    backgroundColor: const Color(0xFF141922),
                    borderRadius: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.redDim,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'GÜNÜN VAKASI',
                              style: TextStyle(fontSize: 9, color: AppTheme.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ARŞİVE GÖZ AT ➔',
                            style: TextStyle(fontSize: 9, color: AppTheme.cyan, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Mono'),
                          ),
                          const Spacer(),
                          const Text(
                            'ZORLUK: ZOR',
                            style: TextStyle(fontSize: 10, color: AppTheme.amber, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'CASE #017 — ATLANTİK GECESİ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, color: AppTheme.amber),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Airbus A330 • 02:10 UTC • 228 Yolcu • FL350 Seyir',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main Action: OYUN ARA (Quick Matchmaking)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<MatchmakingProvider>().startMatchmaking(targetRoles: 5);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MatchmakingScreen()),
                    );
                  },
                  icon: const Icon(Icons.radar, color: Colors.black),
                  label: const Text('OYUN ARA (5 KİŞİLİK KRİZ MASASI)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.amber,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Multiplayer Room Lobby (Code based)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MultiplayerRoomScreen()),
                    );
                  },
                  icon: const Icon(Icons.meeting_room, color: AppTheme.amber, size: 18),
                  label: const Text(
                    'ÖZEL ODA KUR / ARKADAŞINLA OYNA',
                    style: TextStyle(color: AppTheme.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF161E28),
                    foregroundColor: AppTheme.amber,
                    side: const BorderSide(color: AppTheme.amber),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Solo Mode / Solo Soruşturma
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InvestigationScreen()),
                    );
                  },
                  icon: const Icon(Icons.person, color: AppTheme.cyan),
                  label: const Text('TEK KİŞİLİK SORUŞTURMA (SOLO)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.cyan,
                    side: const BorderSide(color: AppTheme.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Dossiers Archive Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CaseDossierLibraryScreen()),
                    );
                  },
                  icon: const Icon(Icons.folder_special, color: AppTheme.amber),
                  label: const Text('GİZLİ VAKA DOSYALARI ARŞİVİ', style: TextStyle(fontSize: 11, color: AppTheme.amber)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.amber,
                    side: const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Global Leaderboard Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BureauLeaderboardScreen()),
                    );
                  },
                  icon: const Icon(Icons.leaderboard, color: AppTheme.cyan),
                  label: const Text('KÜRESEL MÜFETTİŞ SIRALAMASI', style: TextStyle(fontSize: 11, color: AppTheme.cyan)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.cyan,
                    side: const BorderSide(color: AppTheme.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Room Code Join Row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () => _showJoinRoomDialog(context),
                        icon: const Icon(Icons.meeting_room, size: 16, color: AppTheme.textDim),
                        label: const Text('ÖZEL ODA KODU GİR', style: TextStyle(fontSize: 11, color: AppTheme.textDim)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.surfaceBorder),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinRoomDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Özel Oda Kodu', style: TextStyle(color: AppTheme.amber)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Örn: CRASH-817',
            hintStyle: TextStyle(color: AppTheme.textFaint),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MatchmakingProvider>().joinCustomRoom(
                controller.text,
                InvestigatorRole.telemetryFdr,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MatchmakingScreen()),
              );
            },
            child: const Text('GİRİŞ YAP'),
          ),
        ],
      ),
    );
  }
}
