import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/loaders_screens/loader_diagnosis_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: ((context) => const CustomDialogWidget()));
          return false;
        },
        child: FutureBuilder(
          future: delayPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderDiagnosisScreen();
            }
            return AppBarDrawer(isDiagnosis: true, child: diagnosisPage());
          },
        ));
  }

  Widget diagnosisPage() {
    return const Text("data");
  }
}
