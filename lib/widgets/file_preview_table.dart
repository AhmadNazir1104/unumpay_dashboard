import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/file_preview.dart';

class FilePreviewTable extends StatelessWidget {
  final FilePreview preview;

  const FilePreviewTable({super.key, required this.preview});

  @override
  Widget build(BuildContext context) {
    if (preview.headers.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                const Icon(Icons.table_chart_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('File preview', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_fmt(preview.totalRows)} total rows  •  showing first 10',
                    style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Scrollable table
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 64,
                  ),
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(color: AppColors.border, width: 1),
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      // Header row
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                        children: preview.headers
                            .map((h) => _headerCell(h))
                            .toList(),
                      ),
                      // Data rows
                      ...preview.rows.asMap().entries.map((entry) {
                        final isEven = entry.key % 2 == 0;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: isEven ? Colors.white : const Color(0xFFFAFAFC),
                          ),
                          children: _padRow(entry.value, preview.headers.length)
                              .map((cell) => _dataCell(cell, entry.value, preview.headers))
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _dataCell(String text, List<String> row, List<String> headers) {
    // Colour the payment_status cell based on value
    Color? textColor;
    final idx = headers.indexOf('payment_status');
    if (idx >= 0 && idx < row.length) {
      final status = row[idx].toLowerCase();
      if (text == status) {
        if (status == 'success') textColor = AppColors.success;
        if (status == 'failed')  textColor = AppColors.failed;
        if (status == 'pending') textColor = AppColors.pending;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Text(
        text.isEmpty || text == 'NULL' || text == 'null' ? '—' : text,
        style: TextStyle(
          fontSize: 12,
          color: textColor ?? (text == 'NULL' || text == 'null' || text.isEmpty
              ? AppColors.textSecondary.withOpacity(0.4)
              : AppColors.textPrimary),
          fontWeight: textColor != null ? FontWeight.w600 : FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  /// Ensure row has the same number of cells as headers (handles ragged rows)
  List<String> _padRow(List<String> row, int length) {
    if (row.length >= length) return row.take(length).toList();
    return [...row, ...List.filled(length - row.length, '')];
  }

  String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
