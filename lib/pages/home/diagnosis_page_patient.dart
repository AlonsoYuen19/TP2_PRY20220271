// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

import '../../services/diagnosis_service.dart';
import '../../services/patient_service.dart';
import '../../services/users_service.dart';

class DiagnosisPageByPatient extends StatefulWidget {
  final int idDiagnosis;
  final int idPatient;
  const DiagnosisPageByPatient(
      {super.key, required this.idDiagnosis, required this.idPatient});

  @override
  State<DiagnosisPageByPatient> createState() => _DiagnosisPageByPatientState();
}

class _DiagnosisPageByPatientState extends State<DiagnosisPageByPatient> {
  Users users = Users();
  Diagnosis? diagnosis = Diagnosis();
  Patient patient = Patient();
  String rol = "";
  final diagnosisService = DiagnosisService();
  final usersService = UsersAuthService();
  final patientService = PatientService();
  Future init() async {
    users = (await usersService.getUsersById())!;
    diagnosis = (await diagnosisService.getDiagnosisId(widget.idDiagnosis))!;
    patient = (await patientService.getPatientByIdDiagnosis(widget.idPatient))!;
    setState(() {
      print("El id del diagnóstico es: ${diagnosis!.id}");
    });
  }

  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 1), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    String creatorType = diagnosis!.creatorType;
    if (creatorType == "MEDIC") {
      rol = "Médico";
    } else {
      rol = "Enfermero";
    }
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        mostrarAlertaVolverDiagnosticos(context,
            "¿Esta usted seguro de que desea regresar a la pantalla principal?",
            () {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        }, color: Colors.orangeAccent);
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
            future: delayPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.transparent,
                  ),
                );
              }
              return Stack(
                children: [
                  SafeArea(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(100))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Text(
                                    "El $rol ${diagnosis!.creatorName} ha diagnosticado al paciente ${patient.fullName.split(" ")[0]} brindando el siguiente resultado",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1),
                            child: const Text("Resultados",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: size.width * 0.85,
                          height: size.height * 0.5,
                          child: pieChart(),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  'home',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Aceptar",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ))
                ],
              );
            }),
      ),
    );
  }

  Widget pieChart() {
    List<Color> colorList = const [
      Color.fromRGBO(244, 190, 55, 1),
      Color.fromRGBO(13, 37, 53, 1),
      Color.fromRGBO(255, 159, 64, 1),
      Color.fromRGBO(83, 136, 216, 1),
    ];
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            );
          }
          return PieChart(
            dataMap: {
              "Etapa 1": double.parse(diagnosis!.stage1),
              "Etapa 2": double.parse(diagnosis!.stage2),
              "Etapa 3": double.parse(diagnosis!.stage3),
              "Etapa 4": double.parse(diagnosis!.stage4),
            },
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 20,
            chartRadius: 300,
            colorList: colorList,
            initialAngleInDegree: 0,
            centerText: "UPP",
            chartType: ChartType.disc,
            centerTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
            ringStrokeWidth: 16,
            legendLabels: {
              "Etapa 1": "Etapa 1: ${formatNumber(diagnosis!.stage1)} %",
              "Etapa 2": "Etapa 2: ${formatNumber(diagnosis!.stage2)} %",
              "Etapa 3": "Etapa 3: ${formatNumber(diagnosis!.stage3)} %",
              "Etapa 4": "Etapa 4: ${formatNumber(diagnosis!.stage4)} %",
            },
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 18),
            ),
            chartValuesOptions: const ChartValuesOptions(
              chartValueBackgroundColor: Colors.lightBlue,
              chartValueStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              showChartValueBackground: true,
              showChartValues: false,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          );
        });
  }

  String formatNumber(String numberString) {
    double number = double.parse(numberString);

    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(3).replaceAll(RegExp(r"0*$"), "");
    }
  }
}
