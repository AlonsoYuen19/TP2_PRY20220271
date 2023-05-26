// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';
import '../../models/quick_diagnosis.dart';
import '../../services/diagnosis_service.dart';
import '../../services/nurse_services.dart';
import 'image_preview_quick_diagnosis.dart';

List<CameraDescription> cameras = [];

class TakePhotoQuickDiagnosis extends StatefulWidget {
  const TakePhotoQuickDiagnosis({super.key});

  @override
  State<TakePhotoQuickDiagnosis> createState() =>
      _TakePhotoQuickDiagnosisState();
}

class _TakePhotoQuickDiagnosisState extends State<TakePhotoQuickDiagnosis> {
  CameraController? controller;
  int indexCamaraActive = 0; // 1 Front, 0 Back
  Uint8List avatar = Uint8List(0);
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final nurseService = NurseAuthService();
  Medic medic = Medic();
  QuickDiagnosis image = QuickDiagnosis();
  Patient patient = Patient();
  bool _isPressed = false;
  Future init() async {
    if (prefs.idMedic != 0) {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      print("El nombre del medico es: ${medic.fullName}");
    }

    setState(() {});
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
            child: Column(children: [
              const SizedBox(
                height: 30,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Toma la foto de la herida',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              (cameras == null)
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      height: size.height * 0.55,
                                      width: size.width * 0.75,
                                      color: Colors.transparent,
                                      child: controller == null
                                          ? Container()
                                          : CameraPreview(controller!))),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  ElevatedButton(
                                    onPressed: _isPressed == false
                                        ? handleButton
                                        : null,
                                    child: _isPressed == true
                                        ? Container(
                                            width: 280,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      114, 146, 171, 1),
                                                  strokeWidth: 5,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Text(
                                                    'Por favor espere ...',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            114, 146, 171, 1),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text('Toma la foto',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 35),
                                      child: Text('Regresar',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
            ]),
          ))
        ]),
      ),
    );
  }

  void handleButton() {
    try {
      setState(() {
        _isPressed = true;
        Future.delayed(const Duration(seconds: 10), () {
          setState(() {
            _isPressed = false;
          });
        });
      });
      controller!.takePicture().then((value) async {
        prefs.imageQuickDiag = value.path;
        avatar = await value.readAsBytes();
        if (prefs.idMedic != 0) {
          QuickDiagnosis image =
              await diagnosisService.createQuickDiagnosis(avatar, context);
          if (image.stagePredicted.isNotEmpty) {
            return mostrarAlertaExito(
                context, "Tomó la foto de la herida exitosamente", () async {
              setState(() {
                _isPressed = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ImagePreviewQuickDiagnosis(
                            imagePath: value,
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
