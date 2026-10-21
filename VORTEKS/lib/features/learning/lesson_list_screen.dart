import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/vorteks_widgets.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key, required this.controller, required this.onOpenLesson});
  final AppController controller;
  final ValueChanged<LessonContent> onOpenLesson;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth > 620 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
          itemCount: controller.lessons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
          itemBuilder: (context, index) {
            final lesson = controller.lessons[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                key: Key('lesson-${lesson.id}'),
                onTap: () => onOpenLesson(lesson),
                customBorder: const _OctagonBorder(),
                child: Ink(
                  decoration: const ShapeDecoration(color: Colors.white, shape: _OctagonBorder()),
                  child: CustomPaint(
                    painter: _OctagonBorderPainter(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_iconFor(lesson), size: 44, color: AppColors.navy),
                        const SizedBox(height: 12),
                        Text(lesson.title, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900, decoration: TextDecoration.underline)),
                      ])),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
}

/// Line icon for each topic tile on the MATERI grid (reference page 7).
IconData _iconFor(LessonContent lesson) => switch (lesson.id) {
      'arus-listrik' => Icons.bolt,
      'ohmik-non-ohmik' => Icons.lightbulb_outline,
      'hambatan-jenis' => Icons.api_outlined,
      'rangkaian-listrik' => Icons.wifi_tethering,
      'rangkaian-majemuk' => Icons.account_tree_outlined,
      _ => Icons.power,
    };

class _OctagonBorder extends ShapeBorder {
  const _OctagonBorder();
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => OctagonClipper().getClip(rect.size).shift(rect.topLeft);
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
  @override
  ShapeBorder scale(double t) => this;
}

class _OctagonBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = OctagonClipper().getClip(size);
    canvas.drawPath(path, Paint()..color = AppColors.navy..style = PaintingStyle.stroke..strokeWidth = 2.4);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
