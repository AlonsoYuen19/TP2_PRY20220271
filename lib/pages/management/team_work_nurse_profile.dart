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
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 16, bottom: 16),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer), // <-- Button color
                      elevation:
                          MaterialStateProperty.all(0), // <-- Splash color
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "manage", (route) => false);
                    },
                    child: Icon(Icons.arrow_back_outlined,
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: 18)),
              ),
              leadingWidth: 96,
              centerTitle: true,
              toolbarHeight: 98,
              automaticallyImplyLeading: false,
              title: Text(
                "Perfil del Enfermero",
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
                height: size.height * 0.22,
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
                          color: Colors.transparent,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(children: [
                        Column(children: [
                          avatar.isEmpty
                              ? StreamBuilder<Object>(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/enfermero-logo.png",
                                            ),
                                            fit: BoxFit.fitHeight),
                                        color: Colors.black26,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  })
                              : ClipOval(
                                  child: Image.memory(avatar,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover),
                                ),
                          const SizedBox(
                            height: 11,
                          ),
                          Text(
                            nurse.fullName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 67,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgImages/correo.svg",
                                height: 18,
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              Text(
                                "Correo: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                nurse.email,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgImages/dni.svg",
                                height: 18,
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              Text(
                                "CEP: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                nurse.cep,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgImages/dni.svg",
                                height: 18,
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              Text(
                                "Aux: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                nurse.isAuxiliar == true
                                    ? "Autorizado"
                                    : "No autorizado",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgImages/usuario.svg",
                                height: 18,
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              const Text(
                                "Fecha de registro: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Text(
                                  "$mes $dia, $anio",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          builder: (BuildContext context) =>
                                              RegisterAttendancePage(
                                                idNurse: widget.id,
                                              )));
                                }),
                            cardSelector(
                                color: Color.fromRGBO(42, 81, 152, 1),
                                text: "Asignar Cita",
                                icon: Icons.calendar_today_rounded,
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
                      ]),
                    )));
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
          margin: EdgeInsets.zero,
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: size.width * 0.43,
            height: 188,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
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
