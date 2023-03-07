import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medic.dart';
import '../../services/nurse_services.dart';
import '../../services/medic_service.dart';
import '../../utils/helpers/appbar_drawer/appbar_drawer.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/helpers/loaders_screens/loader_profile_screen.dart';
import '../../utils/helpers/searchable.dart';
import '../../utils/providers/auth_token.dart';
import '../../utils/widgets/alert_dialog.dart';

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
  Medic? doctorUser = Medic();
  var userId = 0;
  Future init() async {
    final doctorProvider = Provider.of<MedicAuthServic>(context, listen: false);
    final nurseProvider = Provider.of<NurseAuthService>(context, listen: false);
    userId =
        (await doctorProvider.getAuthenticateId(prefs.email, prefs.password))!;
    print(userId.toString());
    doctorUser = await doctorProvider.getMedicById(userId.toString());
    setState(() {});
  }

  @override
  void initState() {
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
                          selectedImagePath = prefs.image;
                          prefs.image = await galleryFunction();
                          print('Image_Path: Hecho por la galería de fotos');
                          print(selectedImagePath);
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
                          final doctorProvider = Provider.of<MedicAuthServic>(
                              context,
                              listen: false);
                          var userId = await doctorProvider.getAuthenticateId(
                              prefs.email, prefs.password);
                          selectedImagePath = prefs.image;
                          prefs.image = await camaraFunction();
                          print('Image_Path: Hecho por cámara');
                          print(prefs.image);
                          final bytes = File(prefs.image).readAsBytesSync();
                          String img64 = base64Encode(bytes);
                          print("Hola" + img64);
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
    String fullName = doctorUser!.fullName;
    final nurseProvider = Provider.of<NurseAuthService>(context, listen: false);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Card(
            color: Colors.grey[150],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 35),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 26,
                            ),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        prefs.image == ''
                            ? const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage("assets/images/doctor-logo.png"),
                                radius: 50,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: FileImage(File(prefs.image)),
                                radius: 50,
                              )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 68.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'editProfile');
                        },
                        icon: const Icon(Icons.edit, size: 26),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24),
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
                        "Grado académico del doctor",
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
                        Icons.school_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "UPC-Lima-Perú",
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
                        doctorUser!.address,
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
                        doctorUser!.phone,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black87, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
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
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'registerPatient');
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Text(
                    "Seleccione el icono de búsqueda\npara filtrar por nombres del\npaciente",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
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
                        Provider.of<AuthProvider>(context, listen: false)
                            .updateToken(context);
                        await showSearch(
                          context: context,
                          delegate: SearchUser(isHome: true),
                        );
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
          /*Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            child: FutureBuilder<List<Nurse>>(
              future: nurseProvider.getNurses(),
              builder: (context, snapshot) {
                List<Nurse>? data = snapshot.data;
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                        child: FancyCard(
                          image: Image.asset("assets/images/patient-logo.png"),
                          title: snapshot.data![index].fullName,
                          date: snapshot.data![index].email,
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
          ),*/
        ],
      ),
    );
  }
}
