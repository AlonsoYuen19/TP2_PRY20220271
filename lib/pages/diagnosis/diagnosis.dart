// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ulcernosis/pages/diagnosis/take_photo_quick_diagnosis.dart';
import 'package:ulcernosis/services/diagnosis_service.dart';
import 'package:ulcernosis/utils/widgets/loader_dialog.dart';
import '../../models/quick_diagnosis.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
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
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seleccione una opción...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          prefs.imageQuickDiagFile = await galleryFunction();
                          final dialog = WaitDialog(context);
                          dialog.show();
                          if (prefs.idMedic != 0 &&
                              prefs.imageQuickDiagFile != '') {
                            avatar = File(prefs.imageQuickDiagFile)
                                .readAsBytesSync();
                            //avatar to a XFile
                            XFile image = XFile(prefs.imageQuickDiagFile);
                            DiagnosisService diagnosisService =
                                DiagnosisService();
                            QuickDiagnosis imageSend = await diagnosisService
                                .createQuickDiagnosis(avatar, context, true);

                            if (image.path != '' && imageSend != false) {
                              print("Galeria");
                              dialog.dispose();
                              return mostrarAlertaExito(context,
                                  "Imagen de la úlcera subida correctamente",
                                  () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ImagePreviewQuickDiagnosis(
                                              imagePath: image,
                                              isFromGallery: true,
                                              quickDiagnosis: imageSend,
                                            )));
                              });
                            } else {
                              dialog.dispose();
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
                            //setState(() {});
                          } else {
                            if (!mounted) {}
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Imagen no seleccionada !"),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          width: size.width * 0.32,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TakePhotoQuickDiagnosis()));
                        },
                        child: Container(
                          width: size.width * 0.32,
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 1,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Regresar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
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
              return const LoaderScreen();
            }
            return AppBarDrawer(
                isDiagnosis: true,
                title: "Diagnósticos",
                child: _selectOption());
          },
        ));
  }

  Widget _selectOption() {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Seleccione una opción para realizar el diagnóstico:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DiagnosisPatientPage()));
                },
                child: Container(
                  width: size.width * 0.43,
                  //height: 188,
                  padding: EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(210, 217, 254, 1), width: 2),
                      color: Color.fromRGBO(210, 217, 254, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.person,
                        size: 28,
                        color: Color.fromRGBO(95, 109, 186, 1),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Paciente\nRegistrado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(95, 109, 186, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await selectImage();
                },
                child: Container(
                  width: size.width * 0.43,
                  padding: EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(255, 217, 221, 1), width: 2),
                      color: Color.fromRGBO(255, 217, 221, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.medical_services,
                        size: 28,
                        color: Color.fromRGBO(178, 88, 97, 1),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Diagnóstico\nRápido",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(178, 88, 97, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 24,
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
                      color: Color.fromRGBO(210, 217, 254, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  showDuration: Duration(seconds: 6),
                  message:
                      "Seleccione la opción 'Paciente Registrado' si desea realizar un diagnóstico a un paciente registrado en el sistema.",
                  textStyle: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(95, 109, 186, 1)),
                  child: Icon(Icons.info_outline,
                      color: Color.fromRGBO(95, 109, 186, 1), size: 36)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 217, 221, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  showDuration: Duration(seconds: 6),
                  message:
                      "Seleccione la opción 'Diagnóstico Rápido' para realizar una revalidación de su diagnóstico.",
                  textStyle: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(178, 88, 97, 1)),
                  child: Icon(Icons.info_outline,
                      color: Color.fromRGBO(178, 88, 97, 1), size: 36)),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
