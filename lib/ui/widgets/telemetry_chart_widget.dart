import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';
import 'cockpit_pfd_widget.dart';

class TelemetryChartWidget extends StatelessWidget {
  const TelemetryChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final records = provider.fdrRecords;

    final currentRecord = records.firstWhere(
      (r) => r.offsetSeconds >= provider.currentTimeSeconds,
      orElse: () => records.last,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.flight_takeoff, color: AppTheme.amber, size: 18),
                Expanded(
                  child: Text(
                    'FDR DURUM GÖSTERGESİ (T+${currentRecord.offsetSeconds}s)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.amber,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: currentRecord.autopilotEngaged ? AppTheme.cyanDim : AppTheme.redDim,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    currentRecord.autopilotEngaged ? 'AP1: ENGAGED' : 'AP1: OFF (MANUAL)',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: currentRecord.autopilotEngaged ? AppTheme.cyan : AppTheme.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Primary Flight Display (PFD) HUD
          CockpitPfdWidget(record: currentRecord),
          const SizedBox(height: 16),

          // Primary Altitude & Airspeed Chart
          Text(
            'İNDİKE SÜRAT (IAS - KNOTS) & İRTİFA (FT)',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Container(
            height: 180,
            padding: const EdgeInsets.only(right: 18, top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: true),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Airspeed Curve (Amber)
                  LineChartBarData(
                    spots: records.map((r) => FlSpot(r.offsetSeconds.toDouble(), r.indicatedAirspeedKnots)).toList(),
                    isCurved: true,
                    color: AppTheme.amber,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                  ),
                  // Altitude Curve / 100 (Cyan)
                  LineChartBarData(
                    spots: records.map((r) => FlSpot(r.offsetSeconds.toDouble(), r.altitudeFt / 100)).toList(),
                    isCurved: true,
                    color: AppTheme.cyan,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Flight Control & Engine Metrics Grid
          Text(
            'KOKPİT LÖVYE POZİSYONU & MOTOR DEVRİ (N1)',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'LÖVYE (COLUMN)',
                  value: '${currentRecord.controlColumnPct.toInt()}%',
                  subtitle: currentRecord.controlColumnPct < -50
                      ? 'AĞIR BURUN YUKARI (PULL-UP)'
                      : 'NÖTR / NORMAL',
                  accentColor: currentRecord.controlColumnPct < -50 ? AppTheme.red : AppTheme.textDim,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricCard(
                  title: 'MOTOR GÜCÜ (N1)',
                  value: '${currentRecord.engine1N1Pct.toStringAsFixed(1)}% / ${currentRecord.engine2N1Pct.toStringAsFixed(1)}%',
                  subtitle: 'TOGA MAKSİMUM İTİŞ',
                  accentColor: AppTheme.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Anomaly Discovery Action
          if (currentRecord.linkedEvidenceId != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.amberDim.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.amber),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.amber),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KRİTİK ANOMALİ TESPİT EDİLDİ!',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.amber, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hız sensörünün ani çöküşü kara kutuya kaydedilmiştir.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider.discoverEvidence(currentRecord.linkedEvidenceId!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delil Dedektif Masasına Eklendi!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('MASAYA PİNLE', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: accentColor, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: accentColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
