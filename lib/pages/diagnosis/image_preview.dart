// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/pages/diagnosis/take_photo.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

import '../../services/diagnosis_service.dart';
import '../../services/patient_service.dart';
import '../../services/users_service.dart';
import '../../utils/helpers/zoom_preview_image/preview_image.dart';

class ImagePreview extends StatefulWidget {
  final XFile imagePath;
  final int idDiagnosis;
  final int idPatient;
  const ImagePreview(
      {super.key,
      required this.imagePath,
      required this.idDiagnosis,
      required this.idPatient});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Users users = Users();
  Diagnosis? diagnosis = Diagnosis();
  Patient patient = Patient();
  String porcentaje = "";
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

  String tag = "diagnosis";
  @override
  Widget build(BuildContext context) {
    String role = users.role;
    if (role == "ROLE_MEDIC") {
      rol = "Médico";
    } else {
      rol = "Enfermero";
    }
    if (diagnosis!.stagePredicted == "1") {
      porcentaje = diagnosis!.stage1;
    } else if (diagnosis!.stagePredicted == "2") {
      porcentaje = diagnosis!.stage2;
    } else if (diagnosis!.stagePredicted == "3") {
      porcentaje = diagnosis!.stage3;
    } else if (diagnosis!.stagePredicted == "4") {
      porcentaje = diagnosis!.stage4;
    }
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        mostrarAlertaVolverDiagnosticos(context,
            "¿Esta usted seguro de que desea regresar a la sección de diagnósticos?",
            () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'diagnosis', (route) => false);
        }, color: Colors.orangeAccent);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 96,
            centerTitle: true,
            toolbarHeight: 98,
            automaticallyImplyLeading: false,
            title: Text(
              "Resultado",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
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
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Uint8List bytes = File(widget.imagePath.path)
                                      .readAsBytesSync();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PreviewImagePage(
                                                avatar: bytes,
                                                tag: tag,
                                              )));
                                },
                                child: Hero(
                                  tag: tag,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: SizedBox(
                                      height: size.height * 0.24,
                                      width: size.width * 1,
                                      child: Image.file(
                                        File(widget.imagePath.path),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                //height: size.height * 0.11,
                                width: size.width * 1,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Etapa: ${diagnosis!.stagePredicted}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "${porcentaje.substring(0, 5)}% de predicción",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: size.width * 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Información Adicional",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: size.width * 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "El $rol ${diagnosis!.creatorName} ha diagnosticado al paciente ${patient.fullName.split(" ")[0]} con la condición médica en etapa ${diagnosis!.stagePredicted} de su úlcera por presión. Según el diagnóstico, la probabilidad de que el paciente se encuentre en esa etapa es de un ${porcentaje.substring(0, 5)}% de predicción",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size.width * 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                      onPressed: () async {
                                        mostrarAlertaVolverDiagnosticos(context,
                                            "¿Está seguro de confirmar el diagnóstico para finalizar con la operación?",
                                            () async {
                                          if (prefs.idMedic != 0) {
                                            await diagnosisService
                                                .confirmDiagnosticMedic(
                                                    context, diagnosis!.id);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'home',
                                                (route) => false);
                                          } else {
                                            await diagnosisService
                                                .confirmDiagnosticNurse(
                                                    context, diagnosis!.id);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'home',
                                                (route) => false);
                                          }
                                        },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "Confirmar Diagnóstico",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  width: size.width * 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          elevation: 0,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    TakePhotoDiagnosis(
                                                        idPatient: widget
                                                            .idPatient))));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "Reintentar Diagnóstico",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                );
              }),
        ),
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
            chartValuesOptions: ChartValuesOptions(
              chartValueBackgroundColor:
                  Theme.of(context).colorScheme.onSecondary,
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
