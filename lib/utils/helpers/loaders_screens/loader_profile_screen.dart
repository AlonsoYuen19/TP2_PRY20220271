import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoaderProfileScreen extends StatefulWidget {
  const LoaderProfileScreen({super.key});

  @override
  State<LoaderProfileScreen> createState() => _LoaderProfileScreenState();
}

class _LoaderProfileScreenState extends State<LoaderProfileScreen> {
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
              color: const Color.fromRGBO(210, 231, 232, 1),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width * 1,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/loaders/profile_loader.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                      strokeWidth: 10,
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText("Cargando...",
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontSize: 26,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.bold))
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
