import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoaderManageScreen extends StatefulWidget {
  const LoaderManageScreen({super.key});

  @override
  State<LoaderManageScreen> createState() => _LoaderManageScreenState();
}

class _LoaderManageScreenState extends State<LoaderManageScreen> {

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
              color: const Color.fromRGBO(194, 233, 248, 1),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.6,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/loaders/manage_loader.gif'),
                        fit: BoxFit.contain,
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
