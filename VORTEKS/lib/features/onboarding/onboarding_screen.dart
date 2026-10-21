import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/vorteks_widgets.dart';
import '../auth/auth_screens.dart';

class IntroFlow extends StatefulWidget {
  const IntroFlow({super.key, required this.controller});
  final AppController controller;

  @override
  State<IntroFlow> createState() => _IntroFlowState();
}

class _IntroFlowState extends State<IntroFlow> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const Scaffold(
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [BrandLogo(size: 180), SizedBox(height: 12), Text('VORTEKS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.navy))],
        )),
      );
    }
    return IntroScreen(onStart: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AuthChoiceScreen(controller: widget.controller))));
  }
}

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BrandLogo(size: 190),
                    const SizedBox(height: 20),
                    Text('VORTEKS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    const Text('Visualisasi Otomatis Rangkaian Terintegrasi Eksperimen Listrik', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.5, color: AppColors.ink)),
                    const SizedBox(height: 30),
                    FilledButton(onPressed: onStart, child: const Text('MULAI')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton(), title: const Text('VORTEKS')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BrandLogo(size: 190),
                    const SizedBox(height: 28),
                    Row(children: [
                      Expanded(child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => RegisterScreen(controller: controller))), child: const Text('DAFTAR'))),
                      const SizedBox(width: 12),
                      Expanded(child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => LoginScreen(controller: controller))), child: const Text('LOGIN'))),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
