import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/services/team_work_service.dart';
import 'package:timezone/timezone.dart' as tz;

class AssignItineraryPage extends StatefulWidget {
  final int idNurse;
  const AssignItineraryPage({super.key, required this.idNurse});

  @override
  State<AssignItineraryPage> createState() => _AssignItineraryPageState();
}

class _AssignItineraryPageState extends State<AssignItineraryPage> {
  Nurse? nurse = Nurse();
  final teamWorkService = TeamWorkService();
  Uint8List avatar = Uint8List(0);
  late int hour2;
  late int minute2;
  late TimeOfDay time2;
  Future init() async {
    nurse = await teamWorkService.getNurseByIdTW(widget.idNurse);
    avatar = (await teamWorkService.getNurseImageTeamWork(widget.idNurse));
    setState(() {
      print("El enfermero es: ${nurse!.fullName}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    hour2 = DateTime.now().hour - 5;
    minute2 = DateTime.now().minute;
    time2 = TimeOfDay(hour: hour2, minute: minute2);
    print(time2);
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
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.05),
            child: Column(children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Asignar Itinerario",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              cardNurse(),
              const SizedBox(
                height: 20,
              ),
              assingTime(),
            ]),
          ),
        ))
      ]),
    );
  }

  Widget cardNurse() {
    final size = MediaQuery.of(context).size;
    return Card(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: Text(
                    nurse!.fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  avatar.isEmpty
                      ? Container(
                          height: size.width * 0.2,
                          margin: const EdgeInsets.only(
                            top: 24.0,
                            bottom: 16.0,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/enfermero-logo.png"),
                                fit: BoxFit.fitHeight),
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                        )
                      : ClipOval(
                          child: Image.memory(avatar,
                              height: size.width * 0.2,
                              width: size.width * 0.2,
                              fit: BoxFit.cover),
                        )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "CEP: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: Text(
                    nurse!.cep,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Aux: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      nurse!.isAuxiliar == true
                          ? "Autorizado"
                          : "No autorizado",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dirección: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: Text(
                    nurse!.address,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ));
  }

  Widget assingTime() {
    // Obtener la zona horaria de Lima

    // Obtener la hora actual en Lima
    final hours = time2.hour.toString().padLeft(2, '0');
    final minutes = time2.minute.toString().padLeft(2, '0');
    final amPm = time2.period == DayPeriod.am ? 'AM' : 'PM';
    return Card(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'La hora actual en Lima es $hours:$minutes $amPm',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: time2,
                        );
                        if (newTime != null) {
                          setState(() => time2 = newTime);
                          print(time2);
                          print(newTime);
                        }
                      },
                      child: const Icon(Icons.calendar_month_outlined,
                          color: Colors.black)),
                ],
              ),
            ],
          ),
        ));
  }
}
