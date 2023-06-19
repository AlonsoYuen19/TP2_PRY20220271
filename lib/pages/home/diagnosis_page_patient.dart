// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

class DiagnosisPageByPatient extends StatefulWidget {
  final int idDiagnosis;
  final int idPatient;
  final Diagnosis? diagnosis;
  final Patient? patient;
  const DiagnosisPageByPatient(
      {super.key,
      required this.idDiagnosis,
      required this.idPatient,
      required this.diagnosis,
      required this.patient});

  @override
  State<DiagnosisPageByPatient> createState() => _DiagnosisPageByPatientState();
}

class _DiagnosisPageByPatientState extends State<DiagnosisPageByPatient> {
  String rol = "";
  String porcentaje = "";
  String fullName = "";

  @override
  Widget build(BuildContext context) {
    String creatorType = widget.diagnosis!.creatorType;
    if (creatorType == "MEDIC") {
      rol = "Médico";
    } else {
      rol = "Enfermero";
    }
    if (widget.diagnosis!.stagePredicted == "1") {
      porcentaje = widget.diagnosis!.stage1;
    } else if (widget.diagnosis!.stagePredicted == "2") {
      porcentaje = widget.diagnosis!.stage2;
    } else if (widget.diagnosis!.stagePredicted == "3") {
      porcentaje = widget.diagnosis!.stage3;
    } else if (widget.diagnosis!.stagePredicted == "4") {
      porcentaje = widget.diagnosis!.stage4;
    }
    if (widget.patient!.fullName.contains(" ")) {
      fullName = widget.patient!.fullName.split(" ")[0];
    } else {
      fullName = widget.patient!.fullName;
    }
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          mostrarAlertaVolverDiagnosticos(context,
              "¿Esta usted seguro de que desea regresar a la pantalla principal?",
              () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          }, color: Colors.orangeAccent);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
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
                "Resultado",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            body: Stack(
              children: [
                SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: size.width * 1,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 21),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Etapa: ${widget.diagnosis!.stagePredicted}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${porcentaje.substring(0, 5)}% de predicción",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Información Adicional",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "El $rol ${widget.diagnosis!.creatorName} ha diagnosticado al paciente $fullName con la condición médica en etapa ${widget.diagnosis!.stagePredicted} de su úlcera por presión. Según el diagnóstico, la probabilidad de que el paciente se encuentre en esa etapa es de un ${porcentaje.substring(0, 5)}% de predicción",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 56,
                          width: size.width * 1,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
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
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ))
              ],
            )));
  }
}
