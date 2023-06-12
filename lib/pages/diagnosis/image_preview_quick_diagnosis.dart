// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/helpers/loaders_screens/loader_home_screen.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

import '../../models/quick_diagnosis.dart';
import '../../services/diagnosis_service.dart';
import '../../services/users_service.dart';
import '../../utils/helpers/zoom_preview_image/preview_image.dart';

class ImagePreviewQuickDiagnosis extends StatefulWidget {
  final XFile imagePath;
  final bool isFromGallery;
  const ImagePreviewQuickDiagnosis(
      {super.key, required this.imagePath, required this.isFromGallery});

  @override
  State<ImagePreviewQuickDiagnosis> createState() =>
      _ImagePreviewQuickDiagnosisState();
}

class _ImagePreviewQuickDiagnosisState
    extends State<ImagePreviewQuickDiagnosis> {
  Users users = Users();
  Diagnosis? diagnosis = Diagnosis();
  QuickDiagnosis? quickDiagnosis = QuickDiagnosis();
  final diagnosisService = DiagnosisService();
  final usersService = UsersAuthService();
  String? stage;
  String? stage1;
  String? stage2;
  String? stage3;
  String? stage4;
  String porcentaje = "";
  Future init() async {
    users = (await usersService.getUsersById())!;
    quickDiagnosis = await diagnosisService.createQuickDiagnosis(
        File(widget.imagePath.path).readAsBytesSync(),
        context,
        widget.isFromGallery);
    print("El id del Quick diagnóstico es: ${quickDiagnosis!.stage1}");
    setState(() {});
  }

  Future<Widget> delayPage() async {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });
    if (quickDiagnosis!.stagePredicted == "1") {
      porcentaje = quickDiagnosis!.stage1;
    } else if (quickDiagnosis!.stagePredicted == "2") {
      porcentaje = quickDiagnosis!.stage2;
    } else if (quickDiagnosis!.stagePredicted == "3") {
      porcentaje = quickDiagnosis!.stage3;
    } else if (quickDiagnosis!.stagePredicted == "4") {
      porcentaje = quickDiagnosis!.stage4;
    }
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  String tag = "diagnosisQuick";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          mostrarAlertaVolverDiagnosticos(context,
              "¿Esta usted seguro de que desea regresar a la pantalla para escoger a los pacientes a diagnosticar?",
              () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'diagnosis', (route) => false);
          }, color: Colors.orangeAccent);
          return false;
        },
        child: SafeArea(
            child: FutureBuilder(
                future: delayPage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      porcentaje == "") {
                    return LoaderScreen();
                  }
                  if (porcentaje != "" &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Scaffold(
                        backgroundColor: Colors.white,
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        body: SafeArea(
                            child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Uint8List bytess =
                                          File(widget.imagePath.path)
                                              .readAsBytesSync();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreviewImagePage(
                                                    avatar: bytess,
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
                                          height: size.height * 0.25,
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
                                    width: size.width * 1,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Etapa ${quickDiagnosis!.stagePredicted}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiary),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          porcentaje.isEmpty
                                              ? "$porcentaje"
                                              : "${porcentaje.substring(0, 5)}% de predicción",
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Información Adicional",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: size.width * 1,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                porcentaje.isEmpty
                                    ? ""
                                    : "El médico ${users.fullName} ha realizado el siguiente diagnóstico rápido, cuyo resultado se encuentra en la etapa ${quickDiagnosis!.stagePredicted}. De acuerdo a este resultado, la probabilidad de que el diagnóstico se encuentre en esta etapa es de un ${porcentaje.substring(0, 5)}% de predicción",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: size.width * 1,
                                      height: 56,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                          onPressed: () async {
                                            mostrarAlertaVolverDiagnosticos(
                                                context,
                                                "¿Está seguro de confirmar el diagnóstico para finalizar con la operación?",
                                                () async {
                                              if (prefs.idMedic != 0) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        'home',
                                                        (route) => false);
                                              }
                                              prefs.deleteImageQuickDiag();
                                              prefs.deleteImageQuickDiagFile();
                                            },
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary);
                                          },
                                          child: Text(
                                            "Confirmar Diagnóstico",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
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
                        )));
                  } else {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    );
                  }
                })));
  }

  Widget pieChart() {
    List<Color> colorList = const [
      Color.fromRGBO(244, 190, 55, 1),
      Color.fromRGBO(13, 37, 53, 1),
      Color.fromRGBO(255, 159, 64, 1),
      Color.fromRGBO(83, 136, 216, 1),
    ];
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 7)),
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
              "Etapa 1": double.parse(quickDiagnosis!.stage1),
              "Etapa 2": double.parse(quickDiagnosis!.stage2),
              "Etapa 3": double.parse(quickDiagnosis!.stage3),
              "Etapa 4": double.parse(quickDiagnosis!.stage4),
            },
            animationDuration: const Duration(milliseconds: 500),
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
              "Etapa 1": "Etapa 1: ${formatNumber(quickDiagnosis!.stage1)} %",
              "Etapa 2": "Etapa 2: ${formatNumber(quickDiagnosis!.stage2)} %",
              "Etapa 3": "Etapa 3: ${formatNumber(quickDiagnosis!.stage3)} %",
              "Etapa 4": "Etapa 4: ${formatNumber(quickDiagnosis!.stage4)} %",
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
