import 'dart:math';
import 'package:flutter/material.dart';

/// Лоадер с фиксированной длиной сегмента.
class MovingSegmentProgressIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double thickness;
  final Color color;
  final double segmentSize;
  final Duration duration;

  const MovingSegmentProgressIndicator({
    required this.segmentSize,
    required this.width,
    required this.height,
    super.key,
    this.color = Colors.blue,
    this.thickness = 4.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<MovingSegmentProgressIndicator> createState() =>
      _MovingSegmentProgressIndicatorState();
}

class _MovingSegmentProgressIndicatorState
    extends State<MovingSegmentProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CircularSegmentPainter(
            color: widget.color,
            thickness: widget.thickness,
            progress: _animation.value,
            segmentSize: widget.segmentSize,
          ),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
          ),
        );
      },
    );
  }
}

class _CircularSegmentPainter extends CustomPainter {
  final double thickness;
  final Color color;
  final double progress;
  final double segmentSize;

  _CircularSegmentPainter({
    required this.thickness,
    required this.color,
    required this.progress,
    required this.segmentSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    final startAngle = 2 * pi * progress;
    final sweepAngle = 2 * pi * segmentSize;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularSegmentPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.segmentSize != segmentSize;
  }
}
