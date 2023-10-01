import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomRive2Screen extends StatefulWidget {
  const CustomRive2Screen({super.key});

  @override
  State<CustomRive2Screen> createState() => _CustomRive2ScreenState();
}

class _CustomRive2ScreenState extends State<CustomRive2Screen> {
  late final StateMachineController _stateMachineController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Rive'),
      ),
      body: const Stack(
        children: [
          RiveAnimation.asset(
            "assets/animations/custom-rive-button.riv",
            stateMachines: [
              "State Machine 1",
            ],
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
