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
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.05),
            child: Column(children: [
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  ElevatedButton(
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16.0,
                      )),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer), // <-- Button color
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.12,
                  ),
                  Flexible(
                    child: Text(
                      "Registro de Citas",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 21,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              FutureBuilder(
                  future: delayPage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    }
                    return listAppointments.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.15,
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
                              const Text(
                                  "No hay Registros de Asistencias Disponibles",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        : MyFutureBuilderAppointmentByNurse(
                            myFuture: appointmentService
                                .getAppointmentsByNurseId(widget.idNurse),
                            idNurse: widget.idNurse,
                          );
                  })
            ]),
          ),
        ))
      ]),
    );
  }
}
