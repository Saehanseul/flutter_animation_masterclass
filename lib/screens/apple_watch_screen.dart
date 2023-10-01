import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late final _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _redProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(
    _curve,
  );

  late Animation<double> _greenProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(
    _curve,
  );

  late Animation<double> _blueProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(
    _curve,
  );

  void _animateValues() {
    setState(() {
      _redProgress = Tween(
        begin: _redProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(
        _curve,
      );

      _greenProgress = Tween(
        begin: _greenProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(
        _curve,
      );

      _blueProgress = Tween(
        begin: _blueProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(
        _curve,
      );
    });

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Apple Watch'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: AnimatedBuilder(
            animation:
                Listenable.merge([_redProgress, _greenProgress, _blueProgress]),
            builder: (context, child) {
              return CustomPaint(
                painter: AppleWatchPainter(
                  redProgress: _redProgress.value,
                  greenProgress: _greenProgress.value,
                  blueProgress: _blueProgress.value,
                ),
                size: const Size(350, 350),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _animateValues,
          child: const Icon(Icons.refresh),
        ));
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redProgress;
  final double greenProgress;
  final double blueProgress;

  const AppleWatchPainter({
    required this.redProgress,
    required this.greenProgress,
    required this.blueProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    const startingAngle = -0.5 * pi;

    // draw red
    final redCirclePaint = Paint()
      ..color = Colors.red.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = size.width / 2 * 0.9;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    // draw green
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final greenCircleRadius = size.width / 2 * 0.74;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    // draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final blueCircleRadius = size.width / 2 * 0.58;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      redProgress * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);

    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);

    final blueArcPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );

    /*
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()..color = Colors.blue;

    canvas.drawRect(rect, paint);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20,
    );
    */
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.redProgress != redProgress;
  }
}
