import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../pages/profile/profile.dart';

Widget backgroundFigure(BuildContext context,
    {double x = 400,
    double y = 80,
    double height = 0.37,
    bool footer = false}) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 2),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: size.height * height,
        width: size.width * 1,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 242, 241, 1),
          borderRadius: footer
              ? BorderRadius.vertical(top: Radius.elliptical(x, y))
              : BorderRadius.vertical(bottom: Radius.elliptical(x, y)),
        ),
      ),
    ),
  ]);
}

Widget backgroundFigureAppbarPatient(BuildContext context,
    {double x = 400,
    double y = 80,
    double height = 0.37,
    bool footer = false}) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 2),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: size.height * height,
        width: size.width * 1,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: footer
              ? BorderRadius.vertical(top: Radius.elliptical(x, y))
              : BorderRadius.vertical(bottom: Radius.elliptical(x, y)),
        ),
      ),
    ),
    Positioned(
      top: 10,
      left: size.width * 0.12,
      child: Container(
          width: size.width * 0.8,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Perfil del Paciente",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 32),
          )),
    )
  ]);
}

Widget backgroundFigureFooterPatient(BuildContext context,
    {double x = 400,
    double y = 80,
    double height = 0.37,
    bool footer = false}) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 2),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: size.height * height,
        width: size.width * 1,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: footer
              ? BorderRadius.vertical(top: Radius.elliptical(x, y))
              : BorderRadius.vertical(bottom: Radius.elliptical(x, y)),
        ),
      ),
    ),
    Positioned(
      top: 10,
      left: size.width * 0.3,
      child: Container(
        width: size.width * 0.4,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              "Regresar",
              style: TextStyle(color: Colors.blue, fontSize: 24),
            )),
      ),
    )
  ]);
}

Widget backgroundFigureAppBar(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
      height: size.height * 1,
      width: size.width * 1,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_images/6.png'),
          fit: BoxFit.cover,
        ),
      ));
}

Widget registerBackgroundFigure(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Container(
      height: size.height * 1,
      width: size.width * 1,
      color: Theme.of(context).colorScheme.surface,
    ),
  ]);
}

Widget preRegisterBackgroundFigure(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Container(
      height: size.height * 1,
      width: size.width * 1,
      color: Theme.of(context).colorScheme.onTertiary,
    ),
  ]);
}
