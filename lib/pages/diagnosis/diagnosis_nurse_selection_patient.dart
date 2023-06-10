// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../models/users.dart';
import '../../services/diagnosis_service.dart';
import '../../services/patient_service.dart';
import '../../services/users_service.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builder_cards/future_builder_patients_diagnosis.dart';

import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class DiagnosisNurseSelectionScreen extends StatefulWidget {
  const DiagnosisNurseSelectionScreen({super.key});

  @override
  State<DiagnosisNurseSelectionScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisNurseSelectionScreen> {
  Uint8List avatar = Uint8List(0);
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  List<Patient> patientsNurses = [];
  Users user = Users();
  final diagnosisService = DiagnosisService();
  final patientService = PatientService();
  final userService = UsersAuthService();
  Future init() async {
    user = (await userService.getUsersById())!;
    if (user.role == "ROLE_NURSE") {
      patientsNurses = await patientService.getPatientsByNurse();
      print("El tamaño de la lista es: ${patientsNurses.length}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
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
              return const LoaderScreen();
            }
            return AppBarDrawer(
                isDiagnosisNurse: true,
                title: "Diagnósticos",
                child: _selectOption());
          },
        ));
  }

  Widget _selectOption() {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selecciona al Paciente Asignado",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            patientsNurses.isEmpty
                ? FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.transparent,
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.2,
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
                              height: 16,
                            ),
                            const Text(
                                "No se encontraron registros de pacientes asignados",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(213, 213, 213, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      );
                    })
                : MyFutureBuilderDiagnosis(
                    myFuture: patientService.getPatientsByNurse(),
                  ),
          ],
        ),
      ),
    ));
  }
}
