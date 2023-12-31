import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({
    super.key,
    required this.index,
  });

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  )..repeat(reverse: true);

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  );

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 3000,
    ),
    reverseDuration: const Duration(
      milliseconds: 1000,
    ),
  );

  late final Curve _menuCurve = Curves.easeInOutCubic;

  late final Animation<double> _screenScale = Tween(
    begin: 1.0,
    end: 0.7,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.0,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: const Offset(
      0.5,
      0,
    ),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.2,
        0.4,
        curve: _menuCurve,
      ),
    ),
  );

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  late final Animation<double> _closeButtonOpacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.3,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _logOutSlide = Tween<Offset>(
    begin: const Offset(
      -1.0,
      0.0,
    ),
    end: const Offset(
      0.0,
      0.0,
    ),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.8,
        1.0,
        curve: _menuCurve,
      ),
    ),
  );

  late final List<Animation<Offset>> _menuAnimations = [
    for (var i = 0; i < _menus.length; i++)
      Tween<Offset>(
        begin: const Offset(
          -1.0,
          0.0,
        ),
        end: const Offset(
          0.0,
          0.0,
        ),
      ).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(
            0.4 + (0.1 * i),
            0.7 + (0.1 * i),
            curve: _menuCurve,
          ),
        ),
      ),
  ];

  String formatDuration(double value) {
    int totalSeconds = (value * 60).toInt();
    int minutes = totalSeconds ~/ 60; // integer division
    int seconds = totalSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  @override
  void initState() {
    super.initState();
    _marqueeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  final ValueNotifier<double> _volume = ValueNotifier(0);
  late final size = MediaQuery.of(context).size;
  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;

    _volume.value = _volume.value.clamp(
      0.0,
      size.width - 80,
    );
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "title": "Profile",
    },
    {
      "icon": Icons.notifications,
      "title": "Notifications",
    },
    {
      "icon": Icons.settings,
      "title": "Settings",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: FadeTransition(
              opacity: _closeButtonOpacity,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: _closeMenu,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                for (var i = 0; i < _menus.length; i++) ...[
                  SlideTransition(
                    position: _menuAnimations[i],
                    child: Row(
                      children: [
                        Icon(
                          _menus[i]["icon"],
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _menus[i]["title"],
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
                const Spacer(),
                SlideTransition(
                  position: _logOutSlide,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 200),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Interstellar"),
                actions: [
                  IconButton(
                    onPressed: _openMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),
              body: Column(
                children: [
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: "${widget.index}",
                      child: Container(
                        height: 320,
                        width: 320,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/covers/${widget.index}.jpeg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(size.width - 80, 5),
                        painter: ProgressBar(
                          progressValue: _progressController.value,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            Text(
                              formatDuration(_progressController.value),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatDuration(1 - _progressController.value),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Interstellar",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SlideTransition(
                    position: _marqueeTween,
                    child: const Text(
                      "A Film By Christopher Nolan - Original Motion Picture Sounctrack",
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: _onPlayPauseTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _playPauseController,
                          size: 60,
                        ),
                        // LottieBuilder.asset(
                        //   "assets/animations/play_and_pause_lottie3.json",
                        //   height: 60,
                        //   width: 60,
                        //   controller: _playPauseController,
                        //   onLoaded: (composition) {
                        //     _playPauseController.duration = composition.duration;
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onHorizontalDragUpdate: _onVolumeDragUpdate,
                    onHorizontalDragStart: (_) => _toggleDragging(),
                    onHorizontalDragEnd: (_) => _toggleDragging(),
                    child: AnimatedScale(
                      scale: _dragging ? 1.1 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.bounceOut,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: _volume,
                          builder: (context, value, child) {
                            return CustomPaint(
                              size: Size(size.width - 80, 50),
                              painter: VolumePainter(
                                volume: value,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;
    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(
      trackRRect,
      trackPaint,
    );

    // progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 10, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePainter extends CustomPainter {
  final double volume;

  VolumePainter({
    required this.volume,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;

    final bgRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;

    final volumeRect = Rect.fromLTWH(0, 0, volume, size.height);

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
