import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

class VorteksApp extends StatelessWidget {
  const VorteksApp({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VORTEKS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: controller.currentUser == null
            ? IntroFlow(controller: controller)
            : DashboardShell(controller: controller),
      );
}

class VorteksStartupErrorApp extends StatelessWidget {
  const VorteksStartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VORTEKS',
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.storage_rounded, size: 48, color: AppColors.navy),
                const SizedBox(height: 12),
                Text('VORTEKS tidak dapat membuka penyimpanan lokal.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('Tutup dan buka kembali aplikasi. Data akun dan progres tidak dihapus.', textAlign: TextAlign.center),
              ]),
            ),
          ),
        ),
      );
}
