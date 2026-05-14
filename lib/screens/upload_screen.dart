import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import 'dashboard_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo / Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text('UnumPay Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 40),

                const Text('Upload transaction file', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text('Upload your CSV or Excel file to generate an instant analytics report.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),

                const SizedBox(height: 32),

                // Drop zone / Upload button
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: provider.isLoading ? null : () => _pickFile(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.upload_file_rounded,
                            size: 48,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                          const SizedBox(height: 12),
                          const Text('Tap to choose a file', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          const SizedBox(height: 4),
                          const Text('Supports .csv and .xlsx', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // State feedback
                if (provider.isLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Analysing ${provider.uploadedFileName}...',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                ],

                if (provider.state == DashboardState.error) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.failed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.failed.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.failed, size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(provider.errorMessage, style: const TextStyle(fontSize: 13, color: AppColors.failed))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: provider.reset,
                      child: const Text('Try again'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final provider = context.read<DashboardProvider>();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: kIsWeb,         // on web, load bytes into memory
      withReadStream: !kIsWeb,  // on mobile, stream from disk
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (kIsWeb) {
      // Web: use raw bytes
      if (file.bytes == null) return;
      await provider.uploadFileBytes(file.bytes!, file.name);
    } else {
      // Mobile / desktop: use file path
      if (file.path == null) return;
      await provider.uploadFile(file.path!, file.name);
    }

    if (context.mounted && provider.state == DashboardState.success) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }
}
