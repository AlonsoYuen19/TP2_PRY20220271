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
import '../../utils/helpers/loaders_screens/loader_diagnosis_screen.dart';
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
              return const LoaderDiagnosisScreen();
            }
            return AppBarDrawer(
                isDiagnosisNurse: true,
                title: "Diangósticos",
                child: _selectOption());
          },
        ));
  }

  Widget _selectOption() {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03, vertical: size.height * 0.05),
        child: Column(
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
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.08,
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
                              "No hay Registros de Pacientes Disponibles",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))
                        ],
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
