import 'package:flutter/material.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Color> _colors = [
    Color.fromRGBO(255, 161, 158, 1),
    Color.fromRGBO(235, 235, 235, 1),
  ];

  int _currentSquareIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentSquareIndex = (_currentSquareIndex + 1) % 5;
          });
          _animationController.reset();
          _animationController.forward();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/just_logo.png',
                fit: BoxFit.cover,
                height: 70,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      final color =
                          _colors[index == _currentSquareIndex ? 0 : 1];
                      final colorOpacity =
                          index == _currentSquareIndex ? 1.0 : _animation.value;
                      return AnimatedOpacity(
                        opacity: colorOpacity,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          width: 15,
                          height: 15,
                          margin: EdgeInsets.all(10),
                          color: color,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
