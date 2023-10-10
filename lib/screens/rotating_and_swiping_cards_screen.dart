import 'dart:math';

import 'package:flutter/material.dart';

class RotatingAndSwipingCardsScreen extends StatefulWidget {
  const RotatingAndSwipingCardsScreen({super.key});

  @override
  State<RotatingAndSwipingCardsScreen> createState() =>
      _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<RotatingAndSwipingCardsScreen>
    with TickerProviderStateMixin {
  List<String> questions = [
    "한국의 수도는?",
    "일본의 수도는?",
    "중국의 수도는?",
    "미국의 수도는?",
    "영국의 수도는?",
  ];

  List<String> answers = [
    "서울!",
    "도쿄!",
    "베이징!",
    "워싱턴!",
    "런던!",
  ];

  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  late final AnimationController _cardController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final Animation<double> _progressAnimation =
      Tween<double>(begin: 0, end: 1).animate(_progressController);

  int _index = 1;

  Color backgroundColor = Colors.blue;

  @override
  void dispose() {
    _position.dispose();
    _cardController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _rotate() {
    _cardController.forward();
  }

  void _progress() {
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    void _onHorizontalDragUpdate(DragUpdateDetails details) {
      setState(() {
        _position.value += details.delta.dx;
      });

      if (_position.value < -10) {
        backgroundColor = Colors.red;
      } else if (_position.value > 10) {
        backgroundColor = Colors.green;
      } else {
        backgroundColor = Colors.blue;
      }
    }

    void _whenComplete() {
      _position.value = 0;

      setState(() {
        _index = _index == 5 ? 1 : _index + 1;
      });

      _progress();
      _cardController.reset();
    }

    void _onHorizontalDragEnd(DragEndDetails details) {
      const bound = 0;
      final dropZone = size.width + 100;

      if (_position.value.abs() >= bound) {
        final factor = _position.value.isNegative ? -1 : 1;
        _position
            .animateTo(
              dropZone * factor,
              curve: Curves.bounceOut,
            )
            .whenComplete(_whenComplete);
      } else {
        _position.animateTo(
          0,
          curve: Curves.bounceOut,
        );
      }
    }

    void _onHorizontalClickEnd(DragEndDetails? details,
        {required double direction}) {
      final bound = size.width - 100;
      final dropZone = size.width + 100;

      if (_position.value.abs() >= bound || direction != 0.0) {
        final factor = direction != 0.0
            ? direction
            : (_position.value.isNegative ? -1 : 1);
        _position
            .animateTo(
              dropZone * factor,
              curve: Curves.easeOut,
            )
            .whenComplete(_whenComplete);
      } else {
        _position.animateTo(
          0,
          curve: Curves.easeOut,
        );
      }
    }

    return Scaffold(
        backgroundColor: Colors.blue,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: backgroundColor,
          child: AnimatedBuilder(
            animation: _position,
            builder: (context, child) {
              final angle = _rotation.transform(
                      (_position.value + size.width / 2) / size.width) *
                  pi /
                  180;
              final scale =
                  _scale.transform(_position.value.abs() / size.width);
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 200,
                    child: Transform.scale(
                      scale: min(scale, 1.0),
                      child: FrontCard(text: questions[_index]),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    child: GestureDetector(
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      onHorizontalDragEnd: _onHorizontalDragEnd,
                      child: Transform.translate(
                        offset: Offset(_position.value, 0),
                        child: Transform.rotate(
                          angle: angle,
                          child: GestureDetector(
                            onTap: _rotate,
                            child: AnimatedBuilder(
                              animation: _cardController,
                              builder: (_, child) {
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(pi * _cardController.value),
                                  child: Center(
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(((_cardController.value > 0.5)
                                            ? pi
                                            : 0.0)),
                                      child: (_cardController.value > 0.5)
                                          ? BackCard(text: answers[_index - 1])
                                          : FrontCard(
                                              text: questions[_index - 1]),
                                      // Text(
                                      //   (_controller.value > 0.5) ? 'Back' : 'Front',
                                      //   style: const TextStyle(color: Colors.black),
                                      // ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        print("value: ${_progressController.value}");
                        if (_progressController.value > (_index - 1) / 5) {
                          _progressController.stop();
                        }
                        return ProgressBar(
                          progress: _progressController.value,
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }
}

class FrontCard extends StatelessWidget {
  final String text;
  const FrontCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BackCard extends StatelessWidget {
  final String text;
  const BackCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress; // 0 to 4

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 12),
      painter: ProgressBarPainter(progress),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double progress;

  ProgressBarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    print('progress: $progress');

    Paint grayPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double sectionWidth = size.width;
    double progressWidth = (progress * sectionWidth);
    print('progressWidth: $progressWidth');
    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
      grayPaint,
    );

    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), Offset(progressWidth, size.height)),
      whitePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
