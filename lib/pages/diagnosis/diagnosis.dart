// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ulcernosis/pages/diagnosis/take_photo_quick_diagnosis.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/helpers/loaders_screens/loader_diagnosis_screen.dart';
import '../../utils/widgets/alert_dialog.dart';
import 'diagnosis_patient.dart';
import 'image_preview_quick_diagnosis.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  Uint8List avatar = Uint8List(0);
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future selectImage() {
    final size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Evalué una imágen de una escara desde tu...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          prefs.imageQuickDiagFile = await galleryFunction();
                          if (prefs.idMedic != 0 &&
                              prefs.imageQuickDiagFile != '') {
                            avatar = File(prefs.imageQuickDiagFile)
                                .readAsBytesSync();
                            //avatar to a XFile
                            XFile image = XFile(prefs.imageQuickDiagFile);
                            if (image.path != '') {
                              print("Galeria");
                              return mostrarAlertaExito(context,
                                  "Imagen de la úlcera subida correctamente",
                                  () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ImagePreviewQuickDiagnosis(
                                              imagePath: image,
                                            )));
                              });
                            } else {
                              return mostrarAlertaError(context,
                                  "No se pudo subir correctamente la imagen",
                                  () async {
                                Navigator.pop(context);
                              });
                            }
                          }
                          if (prefs.imageQuickDiagFile != '') {
                            if (!mounted) {}
                            Navigator.of(context).pop();
                            setState(() {});
                          } else {
                            if (!mounted) {}
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Imagen no seleccionada !"),
                            ));
                          }
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/gallery-icon.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Galería',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TakePhotoQuickDiagnosis()));
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/take_a_photo.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Cámara',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: const Text('Regresar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
            return AppBarDrawer(isDiagnosis: true, title: "Diagnósticos", child: _selectOption());
          },
        ));
  }

  Widget _selectOption() {
    return Column(
      children: [
        const SizedBox(
          height: 70,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "Seleccione una opción para realizar el diagnóstico:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiagnosisPatientPage()));
              },
              child: Container(
                width: 160,
                height: 180,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Paciente Registrado",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                selectImage();
              },
              child: Container(
                width: 160,
                height: 180,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.medical_services,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Diagnóstico Rápido",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  showDuration: Duration(seconds: 6),
                  message:
                      "Seleccione la opción 'Paciente Registrado' si desea realizar un diagnóstico a un paciente registrado en el sistema",
                  textStyle: TextStyle(fontSize: 18),
                  child: Icon(Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 50)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  showDuration: Duration(seconds: 6),
                  message:
                      "Seleccione la opción 'Diagnóstico Rápido' si desea realizar un diagnóstico a un paciente que no se encuentra registrado en el sistema",
                  textStyle: TextStyle(fontSize: 18),
                  child: Icon(Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 50)),
            ),
          ],
        )
      ],
    );
  }
}
