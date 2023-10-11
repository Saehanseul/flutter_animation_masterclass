import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ContainerTransformScreen extends StatefulWidget {
  const ContainerTransformScreen({super.key});

  @override
  State<ContainerTransformScreen> createState() =>
      _ContainerTransformScreenState();
}

class _ContainerTransformScreenState extends State<ContainerTransformScreen> {
  bool _isGrid = false;

  void _toggleGrid() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Transform'),
        actions: [
          IconButton(
            onPressed: _toggleGrid,
            icon: const Icon(
              Icons.grid_4x4,
            ),
          ),
        ],
      ),
      body: _isGrid
          ? GridView.builder(
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1 / 1.5,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => OpenContainer(
                transitionDuration: const Duration(
                  milliseconds: 2000,
                ),
                closedBuilder: (context, action) => Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.asset(
                        "assets/covers/${index % 5 + 1}.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Text("달리기를 합시당~~!"),
                    const Text(
                      "무라카미 하루키",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                openBuilder: (context, action) => DetailScreen(
                  image: index % 5 + 1,
                ),
              ),
            )
          : ListView.separated(
              itemBuilder: (context, index) => OpenContainer(
                closedElevation: 0,
                openElevation: 0,
                transitionDuration: const Duration(milliseconds: 2000),
                closedBuilder: (context, action) => ListTile(
                  title: const Text("달리기를 매일 꾸준히 하자"),
                  subtitle: const Text("무라카미 하루키"),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/covers/${index % 5 + 1}.jpeg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                openBuilder: (context, action) => DetailScreen(
                  image: index % 5 + 1,
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
              itemCount: 20,
            ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final image;

  const DetailScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text("Detail Screen"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.asset(
              "assets/covers/$image.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          const Text(
            "Detail Screen",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
