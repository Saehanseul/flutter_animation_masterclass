import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
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

  int _index = 1;

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onHorizontalDragUpdate(DragUpdateDetails details) {
      setState(() {
        _position.value += details.delta.dx;
      });
    }

    void _whenComplete() {
      _position.value = 0;

      setState(() {
        _index = _index == 5 ? 1 : _index + 1;
      });
    }

    void _onHorizontalDragEnd(DragEndDetails details) {
      final bound = size.width - 100;
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
        appBar: AppBar(
          title: const Text('Swiping Cards'),
        ),
        body: AnimatedBuilder(
          animation: _position,
          builder: (context, child) {
            final angle = _rotation.transform(
                    (_position.value + size.width / 2) / size.width) *
                pi /
                180;
            final scale = _scale.transform(_position.value.abs() / size.width);
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 100,
                  child: Transform.scale(
                      scale: min(scale, 1.0),
                      child: Card(
                        index: _index == 5 ? 1 : _index + 1,
                      )),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_position.value, 0),
                      child: Transform.rotate(
                        angle: angle,
                        child: Card(
                          index: _index,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  child: Row(
                    children: [
                      Material(
                        elevation: 5.0, // 그림자의 높이 설정
                        shape: const CircleBorder(), // 원형 테두리 설정
                        clipBehavior:
                            Clip.antiAlias, // 안티 앨리어싱을 적용하여 테두리가 깔끔하게 보이도록 함
                        child: IconButton(
                          onPressed: () {
                            _onHorizontalClickEnd(null, direction: -1.0);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Material(
                        elevation: 5.0, // 그림자의 높이 설정
                        shape: const CircleBorder(), // 원형 테두리 설정
                        clipBehavior:
                            Clip.antiAlias, // 안티 앨리어싱을 적용하여 테두리가 깔끔하게 보이도록 함
                        child: IconButton(
                          onPressed: () {
                            _onHorizontalClickEnd(null, direction: 1.0);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset("assets/covers/$index.jpeg", fit: BoxFit.cover),
      ),
    );
  }
}
