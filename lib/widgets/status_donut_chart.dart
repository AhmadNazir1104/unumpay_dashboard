import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/transaction_report.dart';

class StatusDonutChart extends StatelessWidget {
  final TransactionSummary summary;

  const StatusDonutChart({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 45,
                        sections: [
                          PieChartSectionData(
                            value: summary.pending.toDouble(),
                            color: AppColors.pending,
                            title: '',
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: summary.success.toDouble(),
                            color: AppColors.success,
                            title: '',
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: summary.failed.toDouble(),
                            color: AppColors.failed,
                            title: '',
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem(AppColors.success, 'Success', summary.success, summary.total),
                      const SizedBox(height: 10),
                      _legendItem(AppColors.failed, 'Failed', summary.failed, summary.total),
                      const SizedBox(height: 10),
                      _legendItem(AppColors.pending, 'Pending', summary.pending, summary.total),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, int value, int total) {
    final pct = total > 0 ? (value / total * 100).toStringAsFixed(1) : '0';
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('$pct%  (${_fmt(value)})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
