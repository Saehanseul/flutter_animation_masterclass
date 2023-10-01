import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomRiveScreen extends StatefulWidget {
  const CustomRiveScreen({super.key});

  @override
  State<CustomRiveScreen> createState() => _CustomRiveScreenState();
}

class _CustomRiveScreenState extends State<CustomRiveScreen> {
  late final StateMachineController _stateMachineController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Rive'),
      ),
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/animations/balls-animation.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: const Center(
                child: Text(
                  "Welcome to Ai app",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
