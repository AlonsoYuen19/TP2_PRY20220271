// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';
import '../../services/diagnosis_service.dart';
import '../../services/nurse_services.dart';
import '../../services/patient_service.dart';
import 'image_preview.dart';

List<CameraDescription> cameras = [];

class TakePhotoDiagnosis extends StatefulWidget {
  final int idPatient;
  const TakePhotoDiagnosis({super.key, required this.idPatient});

  @override
  State<TakePhotoDiagnosis> createState() => _TakePhotoDiagnosisState();
}

class _TakePhotoDiagnosisState extends State<TakePhotoDiagnosis> {
  CameraController? controller;
  int indexCamaraActive = 0; // 1 Front, 0 Back
  Uint8List avatar = Uint8List(0);
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final patientService = PatientService();
  final nurseService = NurseAuthService();
  Medic medic = Medic();
  Nurse nurse = Nurse();
  Patient patient = Patient();
  bool _isPressed = false;
  Future init() async {
    patient = (await patientService.getPatientByIdDiagnosis(widget.idPatient))!;
    if (prefs.idMedic != 0) {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      print("El nombre del medico es: ${medic.fullName}");
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      print("El nombre del enfermero es: ${nurse.fullName}");
    }

    setState(() {
      print("El nombre del paciente es: ${patient.fullName}");
      print("El id del paciente es: ${widget.idPatient}");
    });
  }

  @override
  void initState() {
    init();
    getCameras();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(
            context, 'diagnosis', (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
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
                    color: Theme.of(context).colorScheme.onTertiary, size: 18)),
          ),
          leadingWidth: 96,
          centerTitle: true,
          toolbarHeight: 98,
          automaticallyImplyLeading: false,
          title: Text(
            "Realizar Diagnóstico",
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
          SafeArea(
              child: Column(children: [
            (cameras == null)
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Captura la foto de la herida",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, top: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                              child: Container(
                                  height: size.height * 0.5,
                                  width: double.infinity,
                                  child: controller == null
                                      ? Container()
                                      : CameraPreview(
                                          controller!,
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                  onPressed:
                                      _isPressed == false ? handleButton : null,
                                  child: _isPressed == true
                                      ? Container(
                                          height: 36,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 15,
                                                width: 15,
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      114, 146, 171, 1),
                                                  strokeWidth: 5,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Text('Por favor espere ...',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          114, 146, 171, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          width: size.width * 1,
                                          height: 38,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text('Capture la imagen',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                      elevation: 0,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "diagnosis", (route) => false);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: size.width * 1,
                                    height: 36,
                                    child: Text('Regresar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
          ]))
        ]),
      ),
    );
  }

  void handleButton() {
    try {
      setState(() {
        _isPressed = true;
        /*Future.delayed(const Duration(seconds: 9), () {
          setState(() {
            _isPressed = false;
          });
        });*/
      });
      controller!.takePicture().then((value) async {
        prefs.imageDiag = value.path;
        avatar = await value.readAsBytes();
        int idDiag;
        int idDiag2;
        if (prefs.idMedic != 0) {
          idDiag = await diagnosisService.createDiagnosisMedic(
              avatar, widget.idPatient);
          print(idDiag);
          if (!idDiag.isNaN && idDiag != 0) {
            return mostrarAlertaExito(
                context, "Se capturó la imagen de la herida exitosamente",
                () async {
              setState(() {
                _isPressed = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ImagePreview(
                            imagePath: value,
                            idDiagnosis: idDiag,
                            idPatient: widget.idPatient,
                          )));
            });
          } else {
            return mostrarAlertaError(
                context, "Ocurrió un error al tomar la foto de la herida",
                () async {
              Navigator.pop(context);
              setState(() {
                _isPressed = false;
              });
            });
          }
        } else {
          idDiag2 = await diagnosisService.createDiagnosisNurse(
              avatar, widget.idPatient);
          print(idDiag2);
          if (!idDiag2.isNaN) {
            return mostrarAlertaExito(
                context, "Se capturó la imagen de la herida exitosamente",
                () async {
              setState(() {
                _isPressed = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ImagePreview(
                            imagePath: value,
                            idDiagnosis: idDiag2,
                            idPatient: widget.idPatient,
                          )));
            });
          } else {
            return mostrarAlertaError(
                context, "Ocurrió un error al tomar la foto de la herida",
                () async {
              Navigator.pop(context);
              setState(() {
                _isPressed = false;
              });
            });
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  getCameras() async {
    try {
      cameras = await availableCameras();
      print('camera ${cameras.length}');
      if (cameras.length == 1 || cameras.isEmpty) {
        controller = null;
        setState(() {});
      } else {
        controller = CameraController(
            cameras[indexCamaraActive], ResolutionPreset.medium);

        controller!.initialize().then((_) {
          if (!mounted) {
            setState(() {});
            return;
          }
          setState(() {});
        });
      }
    } catch (ex) {
      mostrarAlertaError(context, "Sucedio un error al obtener las cámaras",
          () {
        Navigator.pop(context);
      });
    }
  }
}
