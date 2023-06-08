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
    return SafeArea(
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
                    backgroundColor: MaterialStateProperty.all(Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer), // <-- Button color
                    elevation: MaterialStateProperty.all(0), // <-- Splash color
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
              "Selecciona al Paciente",
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
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                SizedBox(
                  height: 16,
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
                      : Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: MyFutureBuilderDiagnosis(
                            myFuture: diagnosisService.getPatientsNoAssigned(),
                          ),
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
                      : Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: MyFutureBuilderDiagnosis(
                            myFuture: patientService.getPatientsByNurse(),
                          ),
                        ),
                ],
              ]),
            )
          ])),
    );
  }
}
