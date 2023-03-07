import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulcernosis/utils/helpers/loaders_screens/loader_manage_screen.dart';

import '../../utils/helpers/appbar_drawer/appbar_drawer.dart';
import '../../utils/widgets/alert_dialog.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
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
              return const LoaderManageScreen();
            }
            return AppBarDrawer(isManagement: true, child: managePage());
          },
        ));
  }

  Widget managePage() {
    return const Text("data");
  }
}
