import 'package:flutter/material.dart';

class Line {
  final Offset start;
  final Offset end;
  final Color color;
  final double strokeWidth;

  Line(this.start, this.end, {this.color = Colors.black, this.strokeWidth = 2.0});
}

class LinesPainter extends CustomPainter {
  final List<Line> lines;

  LinesPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.lines != lines;
  }
}

class LineOverlay extends StatelessWidget {
  final Widget child;
  final List<Line> lines;
  final double height;
  final double width;

  LineOverlay({required this.child, required this.lines, this.height = 500, this.width = 500});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          child,
          IgnorePointer(
            child: CustomPaint(
              painter: LinesPainter(lines),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}
