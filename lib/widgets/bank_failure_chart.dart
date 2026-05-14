import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/transaction_report.dart';

class BankFailureChart extends StatelessWidget {
  final List<PaymentSourceStat> stats;

  const BankFailureChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Only show major banks with meaningful volume
    final filtered = stats
        .where((s) => s.total > 100)
        .toList()
      ..sort((a, b) => b.failRate.compareTo(a.failRate));

    final items = filtered.take(8).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Failure rate by bank / provider', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text('Banks with >100 transactions', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                        '${items[group.x].source}\n${rod.toY.toStringAsFixed(1)}%',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i >= 0 && i < items.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(items[i].source.toUpperCase(), style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(items.length, (i) {
                    final rate = items[i].failRate;
                    final color = rate > 12 ? AppColors.failed : rate > 6 ? AppColors.pending : AppColors.success;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: rate,
                          color: color,
                          width: 22,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
