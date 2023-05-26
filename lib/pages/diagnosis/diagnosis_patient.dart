import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../models/users.dart';
import '../../services/diagnosis_service.dart';
import '../../services/patient_service.dart';
import '../../services/users_service.dart';
import '../../utils/helpers/future_builder_cards/future_builder_patients_diagnosis.dart';

class DiagnosisPatientPage extends StatefulWidget {
  const DiagnosisPatientPage({super.key});

  @override
  State<DiagnosisPatientPage> createState() => _DiagnosisPatientPageState();
}

class _DiagnosisPatientPageState extends State<DiagnosisPatientPage> {
  List<Patient> patientsMedics = [];
  List<Patient> patientsNurses = [];
  Users user = Users();
  final diagnosisService = DiagnosisService();
  final patientService = PatientService();
  final userService = UsersAuthService();
  Future init() async {
    user = (await userService.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      patientsMedics = await diagnosisService.getPatientsNoAssigned();
      print("El tamaño de la lista es: ${patientsMedics.length}");
    } else {
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(100))),
      ),
      SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06, vertical: size.height * 0.05),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      "Selecciona al Paciente",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            if (user.role == "ROLE_MEDIC") ...[
              patientsMedics.isEmpty
                  ? FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 2)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                      myFuture: diagnosisService.getPatientsNoAssigned(),
                    ),
            ] else ...[
              patientsNurses.isEmpty
                  ? FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 2)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
          ]),
        ),
      ))
    ]));
  }
}
