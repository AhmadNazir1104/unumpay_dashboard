import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/file_preview_table.dart';
import '../widgets/metric_card.dart';
import '../widgets/status_donut_chart.dart';
import '../widgets/bank_failure_chart.dart';
import '../widgets/city_failures_chart.dart';
import '../widgets/hourly_chart.dart';
import '../widgets/monthly_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final report   = provider.report;

    if (report == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final s = report.summary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Dashboard'),
            Text(provider.uploadedFileName, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              provider.reset();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.upload_rounded, size: 16),
            label: const Text('New file'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── File preview ──────────────────────────────────────────
            if (provider.preview != null) ...[
              _sectionLabel('Uploaded file'),
              const SizedBox(height: 8),
              FilePreviewTable(preview: provider.preview!),
              const SizedBox(height: 24),
            ],

            // ── Metric cards ─────────────────────────────────────────
            _sectionLabel('Overview'),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: _columns(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MetricCard(
                  label: 'Total transactions',
                  value: _fmt(s.total),
                  icon: Icons.receipt_long_rounded,
                  valueColor: AppColors.textPrimary,
                ),
                MetricCard(
                  label: 'Successful',
                  value: _fmt(s.success),
                  subtitle: '${s.successRate.toStringAsFixed(1)}% of total',
                  icon: Icons.check_circle_outline_rounded,
                  valueColor: AppColors.success,
                ),
                MetricCard(
                  label: 'Failed',
                  value: _fmt(s.failed),
                  subtitle: '${s.failureRate.toStringAsFixed(1)}% of total',
                  icon: Icons.cancel_outlined,
                  valueColor: AppColors.failed,
                ),
                MetricCard(
                  label: 'Pending',
                  value: _fmt(s.pending),
                  subtitle: '${(s.pending / s.total * 100).toStringAsFixed(1)}% of total',
                  icon: Icons.hourglass_empty_rounded,
                  valueColor: AppColors.pending,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Status + Bank failure rate ─────────────────────────
            _sectionLabel('Status & Bank analysis'),
            const SizedBox(height: 8),
            _row(context, [
              StatusDonutChart(summary: s),
              BankFailureChart(stats: report.byPaymentSource),
            ]),

            const SizedBox(height: 16),

            // ── City failures ─────────────────────────────────────
            _sectionLabel('Geographic failures'),
            const SizedBox(height: 8),
            CityFailuresChart(stats: report.byCity),

            const SizedBox(height: 16),

            // ── Hourly ────────────────────────────────────────────
            _sectionLabel('Time analysis'),
            const SizedBox(height: 8),
            HourlyChart(stats: report.byHour),

            const SizedBox(height: 16),

            // ── Monthly ───────────────────────────────────────────
            _sectionLabel('Monthly trends'),
            const SizedBox(height: 8),
            MonthlyChart(stats: report.byMonth),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.8),
    );
  }

  // Side-by-side on wide screens, stacked on narrow
  Widget _row(BuildContext context, List<Widget> children) {
    final wide = MediaQuery.of(context).size.width > 700;
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((c) => Expanded(child: c)).toList()
            .expand((w) => [w, const SizedBox(width: 12)]).toList()
          ..removeLast(),
      );
    }
    return Column(
      children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
    );
  }

  int _columns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w > 900) return 4;
    if (w > 600) return 2;
    return 2;
  }

  String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
