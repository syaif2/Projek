import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 160});
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/vorteks_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: 'Logo VORTEKS',
      );
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(padding: padding, child: child),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.cyan, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.navy, fontWeight: FontWeight.w800,
            )),
          ),
        ],
      );
}

/// Decorative cyan circuit trace pattern used behind the dashboard welcome
/// card and the profile header card in the VORTEKS V2 reference (pages 6, 20).
class CircuitPatternPainter extends CustomPainter {
  const CircuitPatternPainter({this.color = AppColors.cyan, this.opacity = 1});

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final dot = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Horizontal runs with right-angle branches, echoing the reference traces.
    final rows = <List<Offset>>[
      [Offset(0, size.height * .28), Offset(size.width * .30, size.height * .28),
       Offset(size.width * .42, size.height * .14), Offset(size.width * .78, size.height * .14)],
      [Offset(size.width * .08, size.height * .62), Offset(size.width * .34, size.height * .62),
       Offset(size.width * .46, size.height * .78), Offset(size.width, size.height * .78)],
      [Offset(size.width * .22, size.height * .95), Offset(size.width * .55, size.height * .95),
       Offset(size.width * .66, size.height * .50), Offset(size.width * .96, size.height * .50)],
      [Offset(size.width * .58, size.height * .02), Offset(size.width * .66, size.height * .02),
       Offset(size.width * .72, size.height * .34), Offset(size.width, size.height * .34)],
    ];

    for (final points in rows) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
      canvas.drawCircle(points.first, 3.4, dot);
      canvas.drawCircle(points.last, 3.4, dot);
    }
    // A couple of hollow nodes, as in the reference artwork.
    final hollow = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width * .40, size.height * .52), 5, hollow);
    canvas.drawCircle(Offset(size.width * .86, size.height * .90), 5, hollow);
  }

  @override
  bool shouldRepaint(covariant CircuitPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.opacity != opacity;
}

class LabeledValue extends StatelessWidget {
  const LabeledValue({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
          const SizedBox(width: 12),
          Flexible(child: Text(value, textAlign: TextAlign.end,
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700))),
        ],
      );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.maxWidth = 760});
  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      );
}

class OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final c = size.shortestSide * 0.30;
    return Path()
      ..moveTo(c, 0)
      ..lineTo(size.width - c, 0)
      ..lineTo(size.width, c)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(c, size.height)
      ..lineTo(0, size.height - c)
      ..lineTo(0, c)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _CurvedBackArrowPainter extends CustomPainter {
  const _CurvedBackArrowPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shaft = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(w * 0.80, h * 0.30)
      ..cubicTo(w * 0.45, h * 0.02, w * 0.20, h * 0.30, w * 0.20, h * 0.60);
    canvas.drawPath(path, shaft);
    final head = Path()
      ..moveTo(w * 0.20, h * 0.78)
      ..lineTo(w * 0.04, h * 0.52)
      ..lineTo(w * 0.36, h * 0.52)
      ..close();
    canvas.drawPath(head, Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BrandBackButton extends StatelessWidget {
  const BrandBackButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Kembali',
        onPressed: () => Navigator.maybePop(context),
        icon: CustomPaint(
          size: const Size(26, 26),
          painter: _CurvedBackArrowPainter(color ?? AppColors.navy),
        ),
      );
}
