import 'dart:math';

import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isAnimating = false;
  bool isRepeating = false;
  late DateTime _startTime;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get timerString {
    int totalSeconds;
    if (isAnimating || isRepeating) {
      totalSeconds = 10 -
          (DateTime.now().difference(_startTime).inSeconds + _elapsedSeconds);
    } else {
      totalSeconds = 10 - _elapsedSeconds;
    }
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(300, 300),
                        painter: MyPainter(_controller.value),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Text(
                      timerString,
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    size: 50,
                    icon: Icons.repeat,
                    color: Colors.grey,
                    onPressed: () {
                      _controller.reset();
                      setState(() {
                        _elapsedSeconds = 0;
                        isAnimating = false;
                        isRepeating = false;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    size: 100,
                    icon: isAnimating ? Icons.pause : Icons.play_arrow,
                    color: Colors.red,
                    onPressed: () {
                      if (isAnimating) {
                        _controller.stop();
                        _elapsedSeconds +=
                            DateTime.now().difference(_startTime).inSeconds;
                      } else if (isRepeating) {
                        _controller.repeat();
                      } else {
                        if (_controller.isCompleted) {
                          _elapsedSeconds = 0;
                        }
                        _controller.forward();
                      }
                      _startTime = DateTime
                          .now(); // Do not reset the start time if resuming
                      setState(() {
                        isAnimating = !isAnimating;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    size: 50,
                    icon: Icons.stop,
                    color: Colors.grey,
                    onPressed: () {
                      _controller.value = 1.0;
                      setState(() {
                        _elapsedSeconds = 10;
                        isAnimating = false;
                        isRepeating = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double size, // 이 부분이 추가된 파라미터입니다.
  }) {
    return SizedBox(
      // SizedBox 위젯으로 버튼의 크기를 강제하고 있습니다.
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // backgroundColor를 primary로 변경할 수 있습니다.
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(1),
        ),
        onPressed: onPressed,
        child: Center(
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ), // 아이콘 크기도 동적으로 조절합니다.
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double value;
  MyPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addArc(
          Rect.fromCenter(
            center: size.center(Offset.zero),
            width: size.width,
            height: size.height,
          ),
          -pi / 2,
          -2 * pi * (1 - value) // 주의: 각도가 음수입니다!
          );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
