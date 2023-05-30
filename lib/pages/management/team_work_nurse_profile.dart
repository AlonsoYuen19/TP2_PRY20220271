import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import '../../models/medic.dart';
import '../../models/nurse.dart';
import '../../services/team_work_service.dart';
import 'items/assign_patient.dart';
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
      child: SafeArea(
        child: Scaffold(
            body: Stack(children: [
          Container(
            height: size.height * 0.315,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.elliptical(400, 80))),
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
                                vertical: size.height * 0.04),
                            child: Column(children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    child: Icon(
                                      Icons.arrow_back_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, "manage", (route) => false);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 16.0,
                                      )),
                                      backgroundColor: MaterialStateProperty
                                          .all(Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer), // <-- Button color
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.1,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Perfil del Enfermero",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
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
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.06,
                                    ),
                                    Text(
                                      "Enfermero asignado al médico ${medic.fullName}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgImages/correo.svg",
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Correo: ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          nurse.email,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgImages/dni.svg",
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "CEP: ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          nurse.cep,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgImages/dni.svg",
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Aux: ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          nurse.isAuxiliar == true
                                              ? "Autorizado"
                                              : "No autorizado",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgImages/usuario.svg",
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "Fecha de registro: ",
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
                                            "$mes $dia, $anio",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Row(
                                children: [
                                  cardSelector(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      text: "Registro de Citas",
                                      icon: Icons.replay,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        RegisterAttendancePage(
                                                          idNurse: widget.id,
                                                        )));
                                      }),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  cardSelector(
                                      color: Color.fromRGBO(42, 81, 152, 1),
                                      text: "Asignar Cita",
                                      icon: Icons.calendar_today_rounded,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AssignPatientPage(
                                                          idNurse: widget.id,
                                                        )));
                                      }),
                                ],
                              ),
                            ]))));
              })
        ])),
      ),
    );
  }

  Widget cardSelector(
      {Color? color, String? text, IconData? icon, Function? onTap}) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.215,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 32,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
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
