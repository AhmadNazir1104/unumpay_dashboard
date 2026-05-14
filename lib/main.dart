import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/dashboard_provider.dart';
import 'screens/upload_screen.dart';

void main() {
  runApp(const UnumPayApp());
}

class UnumPayApp extends StatelessWidget {
  const UnumPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: MaterialApp(
        title: 'UnumPay Analytics',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const UploadScreen(),
      ),
    );
  }
}
