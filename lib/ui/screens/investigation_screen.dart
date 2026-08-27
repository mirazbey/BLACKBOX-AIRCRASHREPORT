import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/case_model.dart';
import '../../providers/investigation_provider.dart';
import '../widgets/telemetry_chart_widget.dart';
import '../widgets/cvr_audio_player_widget.dart';
import '../widgets/maintenance_log_widget.dart';
import '../widgets/investigation_board_widget.dart';
import '../widgets/event_axis_bar_widget.dart';
import '../widgets/radio_ptt_widget.dart';
import '../widgets/forensic_video_player_widget.dart';
import '../widgets/interrogation_view_widget.dart';
import '../widgets/tactical_comms_wheel_widget.dart';
import '../widgets/crash_site_radar_widget.dart';
import '../widgets/tactical_comms_drawer_widget.dart';
import '../widgets/information_broker_widget.dart';
import 'report_builder_screen.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final activeCase = provider.activeCase;
    final role = provider.currentRole;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              activeCase.code,
              style: const TextStyle(fontSize: 13, color: AppTheme.amber),
            ),
            Text(
              role.shortName.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.cyan,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          // Solo Role Switcher Menu
          PopupMenuButton<InvestigatorRole>(
            icon: const Icon(Icons.swap_horiz, color: AppTheme.cyan),
            tooltip: 'Rol Değiştir (Solo Mod)',
            onSelected: (newRole) => provider.switchRole(newRole),
            itemBuilder: (ctx) => InvestigatorRole.values.map((r) {
              return PopupMenuItem(
                value: r,
                child: Text(
                  r.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
          ),
          // Information Broker Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InformationBrokerWidget()),
              );
            },
            icon: const Icon(Icons.hub, color: AppTheme.cyan, size: 20),
            tooltip: 'Delil Brokeri / Havuz',
          ),
          // Tactical Comms Drawer Button
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const TacticalCommsDrawerWidget(),
              );
            },
            icon: const Icon(Icons.forum, color: AppTheme.amber, size: 20),
            tooltip: 'Taktik Akış / Telsiz',
          ),
          // Submit Report Action Button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportBuilderScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              child: const Text(
                'RAPORU DOLDUR',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppTheme.amber,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: AppTheme.amber,
          unselectedLabelColor: AppTheme.textDim,
          tabs: [
            Tab(text: role.shortName.toUpperCase()),
            const Tab(text: '3D RADAR & FLIR'),
            const Tab(text: 'KARA TAHTA'),
            const Tab(text: 'VAKA DOSYASI'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Role Specific Source View
                    _buildRoleSpecificView(role),
                    // Tab 2: Combined 3D Radar & FLIR Forensic Station
                    _buildRadarAndFlirStation(activeCase, provider),
                    // Tab 3: Shared Investigation Board
                    const InvestigationBoardWidget(),
                    // Tab 4: Case Profile Briefing
                    _buildBriefingView(activeCase),
                  ],
                ),
              ),
              // Tactical Non-Voice Comms & Ping Bar
              const TacticalCommsWheelWidget(),
              // Synchronized Event Axis Timeline Bar
              const EventAxisBarWidget(),
            ],
          ),
          // Floating Radio Push-to-Talk Button
          const Positioned(bottom: 120, right: 16, child: RadioPttWidget()),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificView(InvestigatorRole role) {
    switch (role) {
      case InvestigatorRole.telemetryFdr:
        return const TelemetryChartWidget();
      case InvestigatorRole.acousticCvr:
        return const CvrAudioPlayerWidget();
      case InvestigatorRole.avionicsFlir:
        return const ForensicVideoPlayerWidget();
      case InvestigatorRole.maintenanceOps:
        return const MaintenanceLogWidget();
      case InvestigatorRole.humanFactorsPsych:
        return const InterrogationViewWidget();
    }
  }

  Widget _buildRadarAndFlirStation(CaseBundle activeCase, InvestigationProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: CrashSiteRadarWidget(
              activeCase: activeCase,
              currentTimeSeconds: provider.currentTimeSeconds,
              onTimeScrubbed: provider.setTimelineCursor,
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(
            flex: 5,
            child: ForensicVideoPlayerWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefingView(CaseBundle activeCase) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeCase.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                activeCase.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Divider(color: AppTheme.surfaceBorder, height: 24),
              _buildInfoRow('Uçak Modeli:', activeCase.aircraft.model),
              _buildInfoRow('Kuyruk Tescili:', activeCase.aircraft.tailNumber),
              _buildInfoRow('Motorlar:', activeCase.aircraft.engines),
              _buildInfoRow(
                'Uçuş Rotası:',
                '${activeCase.flight.departure} ➔ ${activeCase.flight.destination}',
              ),
              _buildInfoRow(
                'Yolcu / Mürettebat:',
                '${activeCase.flight.soulsOnBoard} Kişi',
              ),
              _buildInfoRow(
                'Son Bilinen İrtifa:',
                activeCase.flight.lastKnownAltitude,
              ),
              const SizedBox(height: 12),
              Text(
                'İLK SORUŞTURMA BİLDİRİMİ:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                activeCase.flight.initialSummary,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textFaint),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
