import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoaderDiagnosisScreen extends StatefulWidget {
  const LoaderDiagnosisScreen({super.key});

  @override
  State<LoaderDiagnosisScreen> createState() => _LoaderDiagnosisScreenState();
}

class _LoaderDiagnosisScreenState extends State<LoaderDiagnosisScreen> {
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(56, 136, 251, 1),
                      Color.fromRGBO(27, 103, 205, 1),
                    ],
                  ),
                )),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width * 1,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: Colors.transparent),
                      image: const DecorationImage(
                        image:
                            AssetImage('assets/loaders/diagnosis_loader.gif'),
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
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
