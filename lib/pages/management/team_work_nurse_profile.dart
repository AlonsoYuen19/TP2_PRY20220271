import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

import '../../models/medic.dart';
import '../../models/nurse.dart';
import '../../services/team_work_service.dart';
import 'items/assign_itenary.dart';
import 'items/assign_patient.dart';
import 'items/list_patients.dart';
import 'items/register_attendances.dart';

class TeamWorkNurseProfile extends StatefulWidget {
  final int id;
  const TeamWorkNurseProfile({super.key, required this.id});

  @override
  State<TeamWorkNurseProfile> createState() => _TeamWorkNurseProfileState();
}

class _TeamWorkNurseProfileState extends State<TeamWorkNurseProfile> {
  Nurse nurse = Nurse();
  Medic medic = Medic();
  Uint8List avatar = Uint8List(0);
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(milliseconds: 200), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future init() async {
    final teamWorkService = TeamWorkService();
    final medicService = MedicAuthServic();
    nurse = (await teamWorkService.getNurseByIdTW(widget.id))!;
    medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
    avatar = (await teamWorkService.getNurseImageTeamWork(widget.id));
    print("El nombre del médico encargado es: " + medic.fullName);
    print("El nombre del enfermero es: " + nurse.fullName);
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100))),
        ),
        FutureBuilder(
            future: delayPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              String anio = nurse.createdAt.substring(0, 4);
              String mes = nurse.createdAt.substring(5, 7);
              String dia = nurse.createdAt.substring(8, 10);
              //mapa de meses
              mes = meses[mes]!;
              return SafeArea(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: size.height * 0.05),
                          child: Column(children: [
                            Row(
                              children: [
                                InkWell(
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, "manage")),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                const Flexible(
                                  child: Text(
                                    "Perfil del Enfermero",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                    width: size.width * 0.9,
                                    padding: const EdgeInsets.all(18),
                                    child: Column(children: [
                                      avatar.isEmpty
                                          ? Container(
                                              height: size.width * 0.3,
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
                                                  height: size.width * 0.3,
                                                  width: size.width * 0.3,
                                                  fit: BoxFit.cover),
                                            ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        nurse.fullName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 28),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Enfermero asignado al médico ${medic.fullName}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Email: ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            nurse.email,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "CEP: ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            nurse.cep,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Aux: ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            nurse.isAuxiliar == true
                                                ? "Autorizado"
                                                : "No autorizado",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Registrado el: ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "$dia de $mes del $anio",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]))),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Row(
                              children: [
                                cardSelector(
                                    color:
                                        const Color.fromRGBO(234, 124, 124, 1),
                                    text: "Registro de Asistencias",
                                    icon: Icons.assignment_turned_in_outlined,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const RegisterAttendancePage()));
                                    }),
                                const SizedBox(
                                  width: 5,
                                ),
                                cardSelector(
                                    color:
                                        const Color.fromRGBO(12, 119, 233, 1),
                                    text: "Asignar Paciente",
                                    icon: Icons.person_add_alt,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AssignPatientPage(
                                                    idNurse: widget.id,
                                                  )));
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              children: [
                                cardSelector(
                                    color:
                                        const Color.fromRGBO(243, 181, 42, 1),
                                    text: "Lista de Pacientes",
                                    icon: Icons.assignment_ind_outlined,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ListPatientsPage(
                                                    idNurse: widget.id,
                                                  )));
                                    }),
                                const SizedBox(
                                  width: 5,
                                ),
                                cardSelector(
                                    color:
                                        const Color.fromRGBO(57, 122, 111, 1),
                                    text: "Asignar Itinerario",
                                    icon: Icons.assignment_add,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AssignItineraryPage(
                                                    idNurse: widget.id,
                                                  )));
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            itineraryShow()
                          ]))));
            })
      ])),
    );
  }

  Widget cardSelector(
      {Color? color, String? text, IconData? icon, Function? onTap}) {
    final size = MediaQuery.of(context).size;
    return Card(
        color: color,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: size.width * 0.39,
          height: size.height * 0.19,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: onTap as void Function()?,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 32,
                      ))
                ],
              ),
              Text(
                text!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  Widget itineraryShow() {
    final size = MediaQuery.of(context).size;
    return Card(
        color: const Color.fromRGBO(42, 147, 243, 1),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ver itinerario",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                  onTap: () {})
            ],
          ),
        ));
  }
}
