// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/pages/profile/patient_profile.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/users_service.dart';
import '../../models/nurse.dart';
import '../../services/patient_service.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/helpers/Searchable/searchable_patients.dart';
import '../../utils/helpers/loaders_screens/loader_profile_screen.dart';
import '../../utils/widgets/alert_dialog.dart';
import '../../utils/widgets/fancy_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  late Future _myFuture;
  String selectedImagePath = '';
  Users users = Users();
  Nurse nurse = Nurse();
  Uint8List avatar = Uint8List(0);
  Uint8List avatar2 = Uint8List(0);
  Uint8List avatar3 = Uint8List(0);
  Future init() async {
    final userService = Provider.of<UsersAuthService>(context, listen: false);
    final nurseService = NurseAuthService();
    //final patientService = Provider.of<PatientService>(context, listen: false);
    users = (await userService.getUsersById())!;

    if (prefs.idMedic != 0) {
      avatar = (await userService.getMedicImageFromBackend());
    }
    if (prefs.idNurse != 0) {
      nurse = (await nurseService.getNurseById(context))!;
      avatar2 = (await userService.getNurseImageFromBackend());
    }
    //avatar3 = (await patientService.getAvatarPatient());
    setState(() {});
  }

  String? equipoMedico;
  Color? colorEquipoMedico;
  @override
  void initState() {
    print("Imagen: " + prefs.image);
    print("Id del paciente: " + prefs.idPatient.toString());
    init();
    _myFuture = delayPage();
    super.initState();
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
          future: _myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderProfileScreen();
            }
            return AppBarDrawer(isProfile: true, child: profilePage());
          },
        ));
  }

  Future selectImage() {
    final size = MediaQuery.of(context).size;
    final userService = Provider.of<UsersAuthService>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selecciona una imagen desde tu...',
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
                          prefs.image = await galleryFunction();
                          if (prefs.idMedic != 0 && prefs.image != '') {
                            avatar = File(prefs.image).readAsBytesSync();
                            print(avatar);
                            bool result;
                            result = await userService.updatePhotoMedic(avatar);
                            if (result == true) {
                              print("Galeria");
                              return mostrarAlertaExito(context,
                                  "Se actualizó exitosamente la foto de perfil del Médico",
                                  () async {
                                Navigator.pushReplacementNamed(
                                    context, 'profile');
                              });
                            } else {
                              return mostrarAlertaError(context,
                                  "No se pudo actualizar la foto de perfil del Médico",
                                  () async {
                                Navigator.pop(context);
                              });
                            }
                          }
                          if (prefs.idNurse != 0 && prefs.image != '') {
                            avatar2 = File(prefs.image).readAsBytesSync();
                            print(avatar2);
                            bool result;
                            result =
                                await userService.updatePhotoNurse(avatar2);
                            if (result == true) {
                              return mostrarAlertaExito(context,
                                  "Se actualizó exitosamente la foto de perfil del Enfermero",
                                  () async {
                                Navigator.pushReplacementNamed(
                                    context, 'profile');
                              });
                            } else {
                              return mostrarAlertaError(context,
                                  "No se pudo actualizar la foto de perfil del Enfermero",
                                  () async {
                                Navigator.pop(context);
                              });
                            }
                          }
                          if (prefs.image != '') {
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
                              padding: const EdgeInsets.all(12.0),
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
                        onTap: () async {
                          //selectedImagePath = prefs.image;
                          prefs.image = await camaraFunction();
                          print('Image_Path: Hecho por cámara');
                          print(prefs.image);
                          if (prefs.idMedic != 0 && prefs.image != '') {
                            avatar = File(prefs.image).readAsBytesSync();
                            print(avatar);

                            bool result;
                            result = await userService.updatePhotoMedic(avatar);
                            if (result == true) {
                              return mostrarAlertaExito(context,
                                  "Se actualizó exitosamente la foto de perfil del Médico",
                                  () async {
                                Navigator.pushReplacementNamed(
                                    context, 'profile');
                              });
                            } else {
                              return mostrarAlertaError(context,
                                  "No se pudo actualizar la foto de perfil del Médico",
                                  () async {
                                Navigator.pop(context);
                              });
                            }
                          }
                          if (prefs.idNurse != 0 && prefs.image != '') {
                            avatar2 = File(prefs.image).readAsBytesSync();
                            print(avatar2);
                            bool result;
                            result =
                                await userService.updatePhotoNurse(avatar2);
                            if (result == true) {
                              return mostrarAlertaExito(context,
                                  "Se actualizó exitosamente la foto de perfil del Enfermero",
                                  () async {
                                Navigator.pushReplacementNamed(
                                    context, 'profile');
                              });
                            } else {
                              return mostrarAlertaError(context,
                                  "No se pudo actualizar la foto de perfil del Enfermero",
                                  () async {
                                Navigator.pop(context);
                              });
                            }
                          }
                          /*final bytes = File(prefs.image).readAsBytesSync();
                          String img64 = base64Encode(bytes);
                          print("Hola" + img64);*/
                          if (prefs.image != '') {
                            if (!mounted) {}
                            Navigator.pop(context);
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
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/camera-icon.png',
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

  Widget profilePage() {
    String role = "";
    if (users.role == 'ROLE_MEDIC') {
      role = "Médico especialista";
    } else {
      role = "Enfermero especialista";
    }

    if (nurse.itWasNotified == true) {
      equipoMedico = "¡Usted actualmente se encuentra en un equipo médico!";
      colorEquipoMedico = Colors.lightBlue;
    } else {
      equipoMedico = "¡Usted actualmente no se encuentra en un equipo médico!";
      colorEquipoMedico = Colors.redAccent;
    }
    final size = MediaQuery.of(context).size;
    final patientService = PatientService();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(children: [
        SizedBox(
          height: users.role == "ROLE_NURSE" ? 90 : 12,
        ),
        Card(
          color: Colors.grey[150],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 35),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipOval(
                    child: Container(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'editProfile');
                        },
                        icon: const Icon(Icons.edit, size: 26),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Container(
                          color: Theme.of(context).colorScheme.tertiary,
                          //margin: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      avatar.isEmpty && avatar2.isEmpty
                          ? CircleAvatar(
                              backgroundColor: Colors.lightBlue,
                              backgroundImage: AssetImage(prefs.idMedic == 0
                                  ? "assets/images/enfermero-logo.png"
                                  : "assets/images/doctor-logo.png"),
                              radius: 55,
                            )
                          : ClipOval(
                              child: Image.memory(
                                  prefs.idMedic != 0 ? avatar : avatar2,
                                  height: size.width * 0.3,
                                  width: size.width * 0.3,
                                  fit: BoxFit.cover),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: Text(
                    users.fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        role,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        users.dni,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.house,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        users.address,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        users.phone,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                users.role == "ROLE_NURSE"
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(equipoMedico!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: colorEquipoMedico, fontSize: 22)),
                      )
                    : const SizedBox(),
                const SizedBox(height: 9),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        if (users.role == "ROLE_MEDIC") ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Lista de Pacientes",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                users.role == "ROLE_MEDIC"
                    ? InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'registerPatient');
                        },
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 30,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Text(
                    "Seleccione el icono de búsqueda\npara filtrar por nombres del\npaciente",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        )),
                      ),
                      onPressed: () async {
                        if (users.role == "ROLE_MEDIC") {
                          await showSearch(
                            context: context,
                            delegate: SearchUserPatient(isMedic: true),
                          );
                        } else {
                          await showSearch(
                            context: context,
                            delegate: SearchUserPatient(isMedic: false),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: 30,
                      )),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            child: FutureBuilder<List<Patient>>(
              future: patientService.getPatientsByMedics(),
              builder: (context, snapshot) {
                List<Patient>? data = snapshot.data;
                //var nurse = nurseProvider.getNurses();
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                }
                if (data!.isEmpty) {
                  return Center(
                    child: Text("No hay pacientes registrados",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.red)),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Future.delayed(const Duration(seconds: 1));
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error al cargar los datos",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.red)),
                  );
                }
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String anio = data[index].createdAt.substring(0, 4);
                      String mes = data[index].createdAt.substring(5, 7);
                      String dia = data[index].createdAt.substring(8, 10);
                      //mapa de meses
                      mes = meses[mes]!;
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                        child: FancyCard(
                          image: Image.asset("assets/images/patient-logo.png"),
                          //image2: avatar3,
                          title: snapshot.data![index].fullName,
                          date: "$dia de $mes del $anio",
                          function: () {
                            //id para enviar a la siguiente pantalla
                            prefs.idPatient = snapshot.data![index].id;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientProfileScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    });
              },
            ),
          ),
        ]
      ]),
    );
  }
}
