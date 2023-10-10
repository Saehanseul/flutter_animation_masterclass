import 'dart:math';

import 'package:flutter/material.dart';

class AnimationCardScreen extends StatefulWidget {
  const AnimationCardScreen({super.key});

  @override
  _AnimationCardScreenState createState() => _AnimationCardScreenState();
}

class _AnimationCardScreenState extends State<AnimationCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rotate() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: GestureDetector(
        onTap: _rotate,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi * _controller.value),
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(((_controller.value > 0.5) ? pi : 0.0)),
                  child: Text(
                    (_controller.value > 0.5) ? 'Back' : 'Front',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
