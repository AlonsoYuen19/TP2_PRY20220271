// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/pages/profile/patient_profile.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/users_service.dart';
import '../../models/nurse.dart';
import '../../services/patient_service.dart';
import '../../utils/helpers/Searchable/searchable_widget.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/helpers/Searchable/searchable_patients.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
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
  List<Patient> patientsLength = [];
  Users users = Users();
  Nurse nurse = Nurse();
  Uint8List avatar = Uint8List(0);
  Uint8List avatar2 = Uint8List(0);
  Uint8List avatar3 = Uint8List(0);
  Future init() async {
    final userService = Provider.of<UsersAuthService>(context, listen: false);
    final nurseService = NurseAuthService();
    final patientService = PatientService();
    //final patientService = Provider.of<PatientService>(context, listen: false);
    users = (await userService.getUsersById())!;

    if (prefs.idMedic != 0) {
      avatar = (await userService.getMedicImageFromBackend());
      patientsLength = (await patientService.getPatientsByMedics());
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
              return const LoaderScreen();
            }
            return AppBarDrawer(
                isProfile: true,
                title: "Mi Perfil",
                color: Theme.of(context).colorScheme.surface,
                child: profilePage());
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
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Elige una opción para cambiar tu avatar...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
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
                        child: SizedBox(
                          width: size.width * 0.32,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
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

  Widget subTitle(String icon, String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 22,
            child: SvgPicture.asset(
              icon,
              height: 20,
              fit: BoxFit.cover,
              color: Theme.of(context).colorScheme.tertiary,
              /*colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSecondary, BlendMode.dst),*/
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(35, 35, 35, 1),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget profilePage() {
    final size = MediaQuery.of(context).size;
    print(size);
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
    final patientService = PatientService();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: avatar.isEmpty && avatar2.isEmpty
                    ? Center(
                        child: Stack(children: [
                          CircleAvatar(
                            backgroundColor: Color(0xF1F1F1),
                            radius: 66,
                            child: Image.asset(
                              prefs.idMedic == 0
                                  ? "assets/images/enfermero_logo1.png"
                                  : "assets/images/medico_logo1.png",
                              fit: BoxFit.fill,
                              height: 150,
                            ),
                          ),
                          Positioned(
                            left: 82,
                            top: 82,
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey[200],
                                child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )
                    : Stack(children: [
                        ClipOval(
                          child: Image.memory(
                              prefs.idMedic != 0 ? avatar : avatar2,
                              height: 125,
                              width: 125,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          left: 75,
                          top: 75,
                          child: ClipOval(
                            child: Container(
                              color: Colors.grey[200],
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 28,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Flexible(
                child: Text(
                  users.fullName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'editProfile');
                },
                child: Text(
                  "Editar Datos Personales",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        subTitle("assets/svgImages/especialidad.svg", "Especialidad: ", role),
        const SizedBox(
          height: 14,
        ),
        subTitle("assets/svgImages/dni.svg", "DNI: ", users.dni),
        const SizedBox(
          height: 14,
        ),
        subTitle("assets/svgImages/celular.svg", "Celular: ", users.phone),
        const SizedBox(
          height: 14,
        ),
        subTitle(
            "assets/svgImages/direccion.svg", "Dirección: ", users.address),
        const SizedBox(
          height: 28,
        ),
        users.role == "ROLE_NURSE"
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: Image.asset(
                        'assets/images/Group.png',
                        color: colorEquipoMedico,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(equipoMedico!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colorEquipoMedico,
                            fontSize: 20,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              )
            : const SizedBox(),
        Column(children: [
          users.role == "ROLE_NURSE"
              ? const SizedBox()
              : Divider(
                  height: 0,
                  thickness: .5,
                ),
          if (users.role == "ROLE_MEDIC") ...[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lista de Pacientes (${patientsLength.length})",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  users.role == "ROLE_MEDIC"
                      ? Flexible(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'registerPatient');
                              },
                              child: Text("Registrar",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ))),
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            FutureBuilder<List<Patient>>(
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: Image.asset(
                            'assets/images/Group.png',
                            color: Colors.grey,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                            "No se encontraron registros de pacientes disponibles",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(213, 213, 213, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Future.delayed(const Duration(seconds: 1));
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(color: Colors.transparent),
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
                return Column(
                  children: [
                    SearchableTitle(
                      title: "Buscar pacientes...",
                      onChanged: () async {
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
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 12,
                              ),
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length > 5
                              ? 5
                              : snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            String anio = data[index].createdAt.substring(0, 4);
                            String mes = data[index].createdAt.substring(5, 7);
                            String dia = data[index].createdAt.substring(8, 10);
                            //mapa de meses
                            mes = meses[mes]!;
                            return FancyCard(
                              image:
                                  Image.asset("assets/images/patient-logo.png"),
                              //image2: avatar3,
                              title: snapshot.data![index].fullName,
                              date: "$mes $dia, $anio",
                              function: () {
                                //id para enviar a la siguiente pantalla
                                prefs.idPatient = snapshot.data![index].id;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PatientProfileScreen(),
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ]
        ]),
      ]),
    );
  }
}
