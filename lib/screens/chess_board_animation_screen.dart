import 'package:flutter/material.dart';

class ChessBoardAnimationScreen extends StatefulWidget {
  const ChessBoardAnimationScreen({Key? key}) : super(key: key);

  @override
  _ChessBoardAnimationScreenState createState() =>
      _ChessBoardAnimationScreenState();
}

class _ChessBoardAnimationScreenState extends State<ChessBoardAnimationScreen>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();

    // 1. 흰색과 검은색 타일을 위한 애니메이션 컨트롤러 초기화.
    // 흰색 타일은 0-7, 검은색 타일은 8-15의 인덱스를 가집니다.
    for (int i = 0; i < 16; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300), // 0.3초 동안 회전
        ),
      );
    }
    _startAnimation(isWhiteTile: true); // 흰색 타일 애니메이션 시작
  }

  // 2. 각 줄의 타일에 대한 애니메이션을 시작하는 함수
  void _startAnimation({required bool isWhiteTile}) {
    for (int i = 0; i < 8; i++) {
      // 각 줄의 타일은 이전 줄의 시작 후 0.1초 지연으로 시작합니다.
      Future.delayed(Duration(milliseconds: i * 100), () {
        _controllers[isWhiteTile ? i : i + 8].forward().then((value) {
          _controllers[isWhiteTile ? i : i + 8].reset();

          // 3. 마지막 줄이 완료되면 반대색 타일 애니메이션을 시작합니다.
          if (i == 7 && isWhiteTile) {
            _startAnimation(isWhiteTile: false);
          }
          // 4. 모든 줄의 검은색 타일 애니메이션 완료 후 다시 흰색 타일 애니메이션을 시작합니다.
          else if (i == 7 && !isWhiteTile) {
            _startAnimation(isWhiteTile: true);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Board Animation'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: _buildTile,
            itemCount: 64,
          ),
        ),
      ),
    );
  }

  // 5. 각 타일을 그리고 회전 애니메이션을 적용하는 함수
  Widget _buildTile(BuildContext context, int index) {
    bool isWhiteTile = (index % 2 == 0) ^ (index ~/ 8 % 2 == 0);

    int controllerIndex = (isWhiteTile ? index ~/ 8 : (index ~/ 8) + 8);

    return AnimatedBuilder(
      animation: _controllers[controllerIndex],
      builder: (context, child) {
        return Transform.rotate(
          angle: _controllers[controllerIndex].value * 3.141592653589793 / 2,
          child: Container(
            color: isWhiteTile ? Colors.grey.shade300 : Colors.black,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
