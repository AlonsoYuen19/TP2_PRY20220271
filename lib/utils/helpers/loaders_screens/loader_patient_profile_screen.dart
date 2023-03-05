import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoaderPatientProfileScreen extends StatefulWidget {
  const LoaderPatientProfileScreen({super.key});

  @override
  State<LoaderPatientProfileScreen> createState() =>
      _LoaderPatientProfileScreenState();
}

class _LoaderPatientProfileScreenState
    extends State<LoaderPatientProfileScreen> {
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
              color: Colors.white,
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
                        opacity: 10,
                        image: AssetImage('assets/loaders/sin-título.png'),
                        fit: BoxFit.fitWidth,
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
