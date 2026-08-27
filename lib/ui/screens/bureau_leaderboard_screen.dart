import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/audio_haptic_service.dart';

class LeaderboardEntry {
  final int rank;
  final String name;
  final String title;
  final String countryCode;
  final int solvedCases;
  final double accuracyPct;
  final int totalXp;
  final String avatarCode;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.title,
    required this.countryCode,
    required this.solvedCases,
    required this.accuracyPct,
    required this.totalXp,
    required this.avatarCode,
    this.isCurrentUser = false,
  });
}

class BureauLeaderboardScreen extends StatefulWidget {
  const BureauLeaderboardScreen({super.key});

  @override
  State<BureauLeaderboardScreen> createState() => _BureauLeaderboardScreenState();
}

class _BureauLeaderboardScreenState extends State<BureauLeaderboardScreen> {
  int _selectedFilterTab = 0; // 0 = Tüm Zamanlar, 1 = Haftalık, 2 = En Hızlılar

  final List<LeaderboardEntry> _allTimeLeaders = const [
    LeaderboardEntry(
      rank: 1,
      name: 'Müfettiş Jean-Luc (BEA)',
      title: 'KIDEMLİ BAŞMÜFETTİŞ',
      countryCode: '🇫🇷',
      solvedCases: 28,
      accuracyPct: 98.4,
      totalXp: 14200,
      avatarCode: '🥇',
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'Müfettiş Sarah Mitchell (NTSB)',
      title: 'BAŞMÜFETTİŞ',
      countryCode: '🇺🇸',
      solvedCases: 26,
      accuracyPct: 96.8,
      totalXp: 12850,
      avatarCode: '🥈',
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Müfettiş Kenji Tanaka (JTSB)',
      title: 'ADLİ AKUSTİK MÜTEHASSISI',
      countryCode: '🇯🇵',
      solvedCases: 24,
      accuracyPct: 95.2,
      totalXp: 11400,
      avatarCode: '🥉',
    ),
    LeaderboardEntry(
      rank: 4,
      name: 'Müfettiş Erik Lindqvist (SHK)',
      title: 'KIDEMLİ MÜFETTİŞ',
      countryCode: '🇸🇪',
      solvedCases: 21,
      accuracyPct: 93.0,
      totalXp: 9800,
      avatarCode: '🎖️',
    ),
    LeaderboardEntry(
      rank: 5,
      name: 'Müfettiş Demir (Sen)',
      title: 'ADLİ MÜFETTİŞ',
      countryCode: '🇹🇷',
      solvedCases: 14,
      accuracyPct: 94.5,
      totalXp: 6200,
      avatarCode: '🎯',
      isCurrentUser: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthService>().currentUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('KÜRESEL MÜFETTİŞ SIRALAMASI'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Selector Tabs
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, 'TÜM ZAMANLAR'),
                  _buildTabButton(1, 'HAFTALIK LİG'),
                  _buildTabButton(2, 'EN HIZLI ÇÖZÜMLER'),
                ],
              ),
            ),

            // Leaderboard Table Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: const [
                  SizedBox(width: 32, child: Text('#', style: TextStyle(fontSize: 10, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'))),
                  Expanded(flex: 3, child: Text('MÜFETTİŞ', style: TextStyle(fontSize: 10, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'))),
                  Expanded(flex: 2, child: Text('DOĞRULUK', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'))),
                  Expanded(flex: 2, child: Text('TOPLAM XP', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono'))),
                ],
              ),
            ),
            const Divider(color: AppTheme.surfaceBorder, height: 8),

            // Leaders List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: _allTimeLeaders.length,
                itemBuilder: (context, index) {
                  final leader = _allTimeLeaders[index];
                  final isMe = leader.isCurrentUser;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: AppTheme.glassBox(
                      borderColor: isMe ? AppTheme.amber : AppTheme.surfaceBorder,
                      borderWidth: isMe ? 2.0 : 1.0,
                      backgroundColor: isMe ? AppTheme.amber.withAlpha(20) : const Color(0xFF101419),
                      borderRadius: 8,
                    ),
                    child: Row(
                      children: [
                        // Rank Badge
                        SizedBox(
                          width: 30,
                          child: Text(
                            '#${leader.rank}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: leader.rank <= 3 ? AppTheme.amber : AppTheme.textDim,
                              fontFamily: 'IBM Plex Mono',
                            ),
                          ),
                        ),
                        // Avatar & Name
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(leader.countryCode, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      isMe ? '${authUser?.displayName ?? leader.name} (Sen)' : leader.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isMe ? AppTheme.amber : AppTheme.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                leader.title,
                                style: const TextStyle(fontSize: 8.5, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono'),
                              ),
                            ],
                          ),
                        ),
                        // Accuracy %
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.green.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppTheme.green.withAlpha(80)),
                              ),
                              child: Text(
                                '%${leader.accuracyPct.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.green,
                                  fontFamily: 'IBM Plex Mono',
                                ),
                              ),
                            ),
                          ),
                        ),
                        // XP
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${leader.totalXp} XP',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.amber,
                              fontFamily: 'IBM Plex Mono',
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // User's Sticky Bottom Rank Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF0F1520),
                border: Border(top: BorderSide(color: AppTheme.amber, width: 1.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AppTheme.amber, size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KİŞİSEL SIRALAMANIZ',
                        style: TextStyle(fontSize: 8.5, color: AppTheme.textFaint, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '#5 ${authUser?.displayName ?? 'Müfettiş Demir'} • 6,200 XP',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.amber),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.green.withAlpha(40),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'TOP %5 ELİT',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.green, fontFamily: 'IBM Plex Mono'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedFilterTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          AudioHapticService.playPinDrop();
          setState(() => _selectedFilterTab = index);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : AppTheme.textDim,
                fontFamily: 'IBM Plex Mono',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
