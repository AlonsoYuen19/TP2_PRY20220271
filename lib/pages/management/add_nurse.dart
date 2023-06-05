import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/team_work_service.dart';

import '../../utils/helpers/future_builder_cards/future_builder_available_nurses.dart';

class AddNursePage extends StatefulWidget {
  const AddNursePage({super.key});

  @override
  State<AddNursePage> createState() => _AddNursePageState();
}

class _AddNursePageState extends State<AddNursePage> {
  final nurseAvailableService = TeamWorkService();
  List nursesAvailable = [];
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(milliseconds: 900), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future init() async {
    nursesAvailable = await nurseAvailableService.getAvailableNurses();
    print("El tamaño de la lista es de: " + nursesAvailable.length.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer), // <-- Button color
                elevation: MaterialStateProperty.all(0), // <-- Splash color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_outlined,
                  color: Theme.of(context).colorScheme.onTertiary, size: 18)),
        ),
        leadingWidth: 96,
        centerTitle: true,
        toolbarHeight: 98,
        automaticallyImplyLeading: false,
        title: Text(
          "Enfermeros disponibles",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
        ),
        SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            FutureBuilder(
                future: delayPage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        nursesAvailable.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.18,
                                  ),
                                  Container(
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0, color: Colors.transparent),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/out-of-stock.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text("No hay enfermeros disponibles",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: MyFutureBuilderAvailableNurses(
                                  myFuture: nurseAvailableService
                                      .getAvailableNurses(),
                                ),
                              ),
                      ]);
                }),
          ],
        ))),
      ]),
    );
  }
}
