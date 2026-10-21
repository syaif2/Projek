import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../data/models/content_models.dart';
import '../assessment/assessment_screens.dart';
import '../help/help_screen.dart';
import '../learning/lesson_detail_screen.dart';
import '../learning/lesson_list_screen.dart';
import '../profile/profile_screens.dart';
import 'dashboard_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key, required this.controller});
  final AppController controller;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  String get _title => const ['DASHBOARD', 'MATERI', 'ASESMEN', 'BANTUAN'][_selectedIndex];

  void _openLesson(LessonContent lesson) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LessonDetailScreen(controller: widget.controller, lesson: lesson),
    )).then((_) => widget.controller.refresh());
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(_title),
            actions: [
              IconButton(
                key: const Key('open-profile'),
                tooltip: 'Profil',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => ProfileScreen(controller: widget.controller),
                )),
                icon: const Icon(Icons.account_circle_outlined, size: 27),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              DashboardScreen(controller: widget.controller, onOpenLesson: _openLesson, onOpenLessons: () => setState(() => _selectedIndex = 1)),
              LessonListScreen(controller: widget.controller, onOpenLesson: _openLesson),
              AssessmentLandingScreen(controller: widget.controller),
              const HelpScreen(showScaffold: false),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
              NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Materi'),
              NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check), label: 'Asesmen'),
              NavigationDestination(icon: Icon(Icons.help_outline), selectedIcon: Icon(Icons.help), label: 'Bantuan'),
            ],
          ),
        ),
      );
}
