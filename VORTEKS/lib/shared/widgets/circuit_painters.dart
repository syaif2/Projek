import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CircuitDiagram extends StatelessWidget {
  const CircuitDiagram({super.key, this.caption = 'Skema rangkaian tertutup'});
  final String caption;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 150, width: double.infinity,
            child: CustomPaint(painter: BasicCircuitPainter())),
          const SizedBox(height: 4),
          Text(caption, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted)),
        ],
      );
}

class BasicCircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()..color = AppColors.navy..strokeWidth = 3..style = PaintingStyle.stroke;
    final accent = Paint()..color = AppColors.cyan..strokeWidth = 4..style = PaintingStyle.stroke;
    final left = size.width * .16;
    final right = size.width * .84;
    final top = size.height * .2;
    final bottom = size.height * .78;
    final lampX = size.width * .52;
    final batteryX = size.width * .28;
    canvas.drawLine(Offset(left, top), Offset(lampX - 20, top), wire);
    canvas.drawLine(Offset(lampX + 20, top), Offset(right, top), wire);
    canvas.drawLine(Offset(right, top), Offset(right, bottom), wire);
    canvas.drawLine(Offset(right, bottom), Offset(batteryX + 6, bottom), wire);
    canvas.drawLine(Offset(batteryX - 6, bottom), Offset(left, bottom), wire);
    canvas.drawLine(Offset(left, bottom), Offset(left, top), wire);
    canvas.drawCircle(Offset(lampX, top), 19, wire);
    canvas.drawLine(Offset(lampX - 10, top - 10), Offset(lampX + 10, top + 10), accent);
    canvas.drawLine(Offset(lampX - 10, top + 10), Offset(lampX + 10, top - 10), accent);
    canvas.drawLine(Offset(batteryX - 10, bottom - 18), Offset(batteryX - 10, bottom + 18), accent);
    canvas.drawLine(Offset(batteryX + 6, bottom - 9), Offset(batteryX + 6, bottom + 9), wire);
    _label(canvas, 'I', Offset(right + 5, size.height * .44), AppColors.cyan);
    _label(canvas, '+', Offset(batteryX - 6, bottom + 23), AppColors.navy);
    _label(canvas, '−', Offset(batteryX + 9, bottom + 23), AppColors.navy);
  }

  void _label(Canvas canvas, String text, Offset position, Color color) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IvGraphPainter extends CustomPainter {
  IvGraphPainter({required this.resistorPoints, required this.ledPoints});
  final List<Offset> resistorPoints;
  final List<Offset> ledPoints;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 38.0;
    const top = 12.0;
    const bottom = 28.0;
    const right = 12.0;
    final graph = Rect.fromLTWH(left, top, size.width - left - right, size.height - top - bottom);
    final grid = Paint()..color = AppColors.border..strokeWidth = 1;
    final axis = Paint()..color = AppColors.ink..strokeWidth = 1.8;
    for (var i = 1; i < 4; i++) {
      final y = graph.top + graph.height * i / 4;
      final x = graph.left + graph.width * i / 4;
      canvas.drawLine(Offset(graph.left, y), Offset(graph.right, y), grid);
      canvas.drawLine(Offset(x, graph.top), Offset(x, graph.bottom), grid);
    }
    canvas.drawLine(Offset(graph.left, graph.bottom), Offset(graph.right, graph.bottom), axis);
    canvas.drawLine(Offset(graph.left, graph.bottom), Offset(graph.left, graph.top), axis);
    _text(canvas, 'V', Offset(graph.right - 5, graph.bottom + 5), AppColors.muted);
    _text(canvas, 'I', Offset(6, graph.top - 4), AppColors.muted);
    _drawPoints(canvas, graph, resistorPoints, AppColors.navy);
    _drawPoints(canvas, graph, ledPoints, AppColors.cyan);
  }

  void _drawPoints(Canvas canvas, Rect graph, List<Offset> points, Color color) {
    final p = Paint()..color = color..strokeWidth = 2.5..style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(Offset(graph.left + point.dx * graph.width, graph.bottom - point.dy * graph.height), 4.5, p);
    }
    if (points.length > 1) {
      final line = Paint()..color = color.withValues(alpha: .7)..strokeWidth = 1.6..style = PaintingStyle.stroke;
      final path = Path();
      path.moveTo(graph.left + points.first.dx * graph.width, graph.bottom - points.first.dy * graph.height);
      for (final point in points.skip(1)) {
        path.lineTo(graph.left + point.dx * graph.width, graph.bottom - point.dy * graph.height);
      }
      canvas.drawPath(path, line);
    }
  }

  void _text(Canvas canvas, String text, Offset position, Color color) {
    final painter = TextPainter(text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 11)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant IvGraphPainter oldDelegate) =>
      oldDelegate.resistorPoints != resistorPoints || oldDelegate.ledPoints != ledPoints;
}

class MixedCircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.navy..strokeWidth = 2.7..style = PaintingStyle.stroke;
    final x1 = size.width * .18;
    final x2 = size.width * .82;
    final y1 = size.height * .22;
    final y2 = size.height * .76;
    canvas.drawLine(Offset(x1, y1), Offset(x2, y1), p);
    canvas.drawLine(Offset(x1, y2), Offset(x2, y2), p);
    canvas.drawLine(Offset(x1, y1), Offset(x1, y2), p);
    canvas.drawLine(Offset(x2, y1), Offset(x2, y2), p);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width * .5, y1), width: 65, height: 25), p);
    canvas.drawRect(Rect.fromCenter(center: Offset(x1, size.height * .5), width: 24, height: 55), p);
    canvas.drawRect(Rect.fromCenter(center: Offset(x2, size.height * .5), width: 24, height: 55), p);
    _label(canvas, 'Rₗ', Offset(size.width * .47, y1 - 10));
    _label(canvas, '14 V', Offset(x1 - 32, size.height * .47));
    _label(canvas, '12 V', Offset(x2 + 8, size.height * .47));
    final arrow = Paint()..color = AppColors.cyan..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x1 + 4, y1 + 16), Offset(x2 - 12, y1 + 16), arrow);
    canvas.drawLine(Offset(x2 - 12, y1 + 16), Offset(x2 - 20, y1 + 10), arrow);
    canvas.drawLine(Offset(x2 - 12, y1 + 16), Offset(x2 - 20, y1 + 22), arrow);
  }

  void _label(Canvas canvas, String text, Offset position) {
    final painter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w600, fontSize: 11)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
