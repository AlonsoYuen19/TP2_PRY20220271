import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoaderHomeScreen extends StatefulWidget {
  const LoaderHomeScreen({super.key});

  @override
  State<LoaderHomeScreen> createState() => _LoaderHomeScreenState();
}

class _LoaderHomeScreenState extends State<LoaderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color.fromRGBO(114, 195, 201, 1),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.6,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/loaders/home_loader.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                      strokeWidth: 10,
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText("Cargando...",
                          textStyle: const TextStyle(fontSize: 26))
                    ],
                    isRepeatingAnimation: true,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
