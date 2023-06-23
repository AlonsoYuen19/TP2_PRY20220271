import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/appointment_service.dart';
import '../../../utils/helpers/future_builder_cards/future_builder_appointments_by_nurse.dart';

class RegisterAttendancePage extends StatefulWidget {
  final int idNurse;
  const RegisterAttendancePage({super.key, required this.idNurse});

  @override
  State<RegisterAttendancePage> createState() => _RegisterAttendancePageState();
}

class _RegisterAttendancePageState extends State<RegisterAttendancePage> {
  List listAppointments = [];
  final appointmentService = AppointmentService();
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(milliseconds: 200), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future init() async {
    listAppointments =
        await appointmentService.getAppointmentsByNurseId(widget.idNurse);
    setState(() {
      print("El tamaño de la lista es: ${listAppointments.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
            "Registro de Citas",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onBackground,
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
            child: Column(children: [
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                  future: delayPage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    }
                    return listAppointments.isEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.24,
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset(
                                    'assets/images/Group.png',
                                    color: Colors.grey,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                    "No se encontraron registros de citas disponibles",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(213, 213, 213, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: MyFutureBuilderAppointmentByNurse(
                              myFuture: appointmentService
                                  .getAppointmentsByNurseId(widget.idNurse),
                              idNurse: widget.idNurse,
                            ),
                          );
                  })
            ]),
          ))
        ]),
      ),
    );
  }
}
