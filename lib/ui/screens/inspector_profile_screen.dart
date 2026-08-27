import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/auth_model.dart';
import '../../services/auth_service.dart';

class InspectorProfileScreen extends StatelessWidget {
  const InspectorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final isApple = user?.providerType == AuthProviderType.apple;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MÜFETTİŞ SİCİL DOSYASI & KARİYER'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Holographic Bureau ID Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E2836), Color(0xFF0F151D)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.amber, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.amber.withAlpha(40),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar / Badge Icon
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.amber),
                      ),
                      child: Center(
                        child: Icon(
                          isApple ? Icons.apple : Icons.shield,
                          color: isApple ? Colors.white : AppTheme.amber,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isApple ? Colors.white24 : AppTheme.amberDim,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isApple ? 'APPLE ID' : 'GOOGLE ID',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isApple ? Colors.white : AppTheme.amber,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'IBM Plex Mono',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'NTSB / BEA AKREDİTE',
                                style: TextStyle(fontSize: 8, color: AppTheme.cyan, fontFamily: 'IBM Plex Mono', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user?.displayName ?? 'BAŞMÜFETTİŞ',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'investigator@bureau.gov',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textDim, fontFamily: 'IBM Plex Mono'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.surfaceBorder, height: 24),

                // XP & Level Progression Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('RÜTBE: SEVİYE 18', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.amber, fontFamily: 'IBM Plex Mono')),
                    const Text('18,450 / 20,000 XP', style: TextStyle(fontSize: 10, color: AppTheme.cyan, fontFamily: 'IBM Plex Mono')),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.92,
                    backgroundColor: AppTheme.surfaceBorder,
                    valueColor: AlwaysStoppedAnimation(AppTheme.amber),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5 Operator Mastery Section
          Text(
            '5 OPERATÖR UZMANLIK DERECELERİ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.cyan),
          ),
          const SizedBox(height: 10),

          _buildMasteryTile(context, 'OP-01 [FDR]', 'Telemetri & FDR Mühendisi', 0.94, AppTheme.amber, '14 Vaka Çözüldü'),
          _buildMasteryTile(context, 'OP-05 [CRM]', 'Adli Psikolog & CRM Sorgu', 0.96, AppTheme.green, '16 Vaka Çözüldü'),
          _buildMasteryTile(context, 'OP-04 [MEL]', 'Adli Bakım & MEL Müfettişi', 0.92, AppTheme.violet, '13 Vaka Çözüldü'),
          _buildMasteryTile(context, 'OP-03 [FLIR]', 'FLIR & Video Rekonstrüksiyon', 0.90, AppTheme.red, '12 Vaka Çözüldü'),
          _buildMasteryTile(context, 'OP-02 [CVR]', 'Akustik & CVR Analisti', 0.88, AppTheme.cyan, '11 Vaka Çözüldü'),

          const SizedBox(height: 20),

          // Unlocked Medals & Badges Grid
          Text(
            'KAZANILAN LİYAKAT ROZETLERİ & NİŞANLAR',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.amber),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _BadgeCard(icon: Icons.star, title: '★ MVP LİDERİ', desc: '5 maç üst üste en yüksek doğruluk'),
              _BadgeCard(icon: Icons.graphic_eq, title: 'CVR KULAK', desc: 'Stall ses frekansını 10 saniyede yakaladı'),
              _BadgeCard(icon: Icons.psychology, title: 'YALAN AVCISI', desc: 'Pilot panik itirafını hatasız kopardı'),
              _BadgeCard(icon: Icons.build_circle, title: 'ADLİ MÜHÜR AVCI', desc: 'Ertelenmiş MEL arıza sahteciliğini buldu'),
              _BadgeCard(icon: Icons.videocam, title: 'TERMAL DEDEKTİF', desc: 'Pitot buzlanmasını FLIR kamerasında teyit etti'),
              _BadgeCard(icon: Icons.verified_user, title: 'NTSB MÜKEMMELLİK', desc: '%95 üzeri vaka doğruluk skoru'),
            ],
          ),
          const SizedBox(height: 24),

          // Solved Case History
          Text(
            'TAMAMLANAN SORUŞTURMA KAYITLARI',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.textDim),
          ),
          const SizedBox(height: 10),

          _buildCaseHistoryItem(context, 'CASE-017: Atlantik Gecesi', 'Airbus A330 • %96 Doğruluk • +520 XP', 'TAM ÇÖZÜM', AppTheme.green),
          _buildCaseHistoryItem(context, 'CASE-002: Hayalet Uçak', 'Boeing 737 • %92 Doğruluk • +480 XP', 'TAM ÇÖZÜM', AppTheme.green),
          _buildCaseHistoryItem(context, 'CASE-001: Sisli Pist', 'Boeing 747 • Kilitli (Rütbe 20 Gerekli)', 'KİLİTLİ', AppTheme.red),
          const SizedBox(height: 24),

          // Sign Out Action
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              icon: const Icon(Icons.logout, color: AppTheme.red, size: 18),
              label: const Text('MÜFETTİŞ OTURUMUNU KAPAT (ÇIKIŞ YAP)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.red,
                side: const BorderSide(color: AppTheme.red),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildMasteryTile(
    BuildContext context,
    String code,
    String title,
    double progress,
    Color color,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  code,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'IBM Plex Mono'),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const Spacer(),
              Text(
                '%${(progress * 100).toInt()}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color, fontFamily: 'IBM Plex Mono'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceBorder,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCaseHistoryItem(
    BuildContext context,
    String title,
    String details,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.history_edu, color: statusColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                Text(details, style: const TextStyle(fontSize: 10, color: AppTheme.textDim)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor, fontFamily: 'IBM Plex Mono'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _BadgeCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 40) / 2,
      padding: const EdgeInsets.all(10),
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
              Icon(icon, color: AppTheme.amber, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.amber, fontFamily: 'IBM Plex Mono'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(fontSize: 9, color: AppTheme.textDim, height: 1.2),
          ),
        ],
      ),
    );
  }
}
