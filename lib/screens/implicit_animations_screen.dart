import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            TweenAnimationBuilder(
              // tween: Tween(begin: 10.0, end: 20.0),
              tween: ColorTween(begin: Colors.purple, end: Colors.red),
              curve: Curves.bounceInOut,
              duration: const Duration(seconds: 5),
              builder: (context, value, child) {
                return Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png",
                  color: value,
                  colorBlendMode: BlendMode.colorBurn,
                );
              },
            ),
            */

            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.elasticOut,
              width: size.width * 0.8,
              height: size.width * 0.8,
              transform: Matrix4.rotationZ(_visible ? 1 : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),

            /*
            AnimatedAlign(
              duration: const Duration(seconds: 2),
              alignment: _visible ? Alignment.topLeft : Alignment.topRight,
              child: AnimatedOpacity(
                opacity: _visible ? 1 : 0.1,
                duration: const Duration(seconds: 2),
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  color: Colors.amber,
                ),
              ),
            ),
            */
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text("Go!"),
            ),
          ],
        ),
      ),
    );
  }
}
