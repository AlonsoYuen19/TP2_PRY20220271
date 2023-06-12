// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import 'package:ulcernosis/utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';
import '../../utils/widgets/background_figure.dart';

class PatientProfileScreen extends StatefulWidget {
  bool? isName;
  bool? isEmail;
  bool? isStateCivil;
  bool? isAddress;
  bool? isPhone;
  bool? isAge;
  bool? isDni;
  PatientProfileScreen(
      {super.key,
      this.isName = false,
      this.isEmail = false,
      this.isStateCivil = false,
      this.isAddress = false,
      this.isPhone = false,
      this.isAge = false,
      this.isDni = false});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Patient patientUser = Patient();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stateCivilController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  Future init() async {
    final patientService = PatientService();
    patientUser = (await patientService.getPatientById())!;
    print("El id del paciente es ${prefs.idPatient}");
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  late Future _myFuture;
  String? name;
  String? email;
  String? stateCivil;
  String? address;
  String? phone;
  int? age;
  String? dni;

  @override
  void initState() {
    init();
    name = patientUser.fullName;
    email = patientUser.email;
    stateCivil = patientUser.civilStatus;
    address = patientUser.address;
    phone = patientUser.phone;
    age = patientUser.age;
    dni = patientUser.dni;
    _myFuture = delayPage();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _stateCivilController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: FutureBuilder(
              future: _myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoaderScreen());
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      backgroundFigureAppbarPatient(context, height: 0.1),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: size.width * 0.8,
                        child: Card(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    "assets/images/patient-logo.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          patientUser.fullName,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 26),
                                        ),
                                      ),
                                    ),
                                    btnEdit(
                                        "Edita el nombre del paciente",
                                        "Nombre completo",
                                        _nameController,
                                        TextInputType.name,
                                        validNameEditDoctor(
                                            "Escriba el nombre con el formato correcto"),
                                        Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        isName: true,
                                        btnText1: name!),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        patientUser.email,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.black87,
                                                fontSize: 20),
                                      ),
                                    ),
                                    btnEdit(
                                        "Edita el correo electrónico del paciente",
                                        "Correo Electrónico",
                                        _emailController,
                                        TextInputType.emailAddress,
                                        validEmail(
                                            "Escriba el correo electrónico con el formato correcto"),
                                        Icon(Icons.email,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isEmail: true,
                                        btnText1: email!),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person_4,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        patientUser.civilStatus,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.black87,
                                                fontSize: 20),
                                      ),
                                    ),
                                    btnEdit(
                                        "Edita el estado civil del paciente",
                                        "Estado civil",
                                        _stateCivilController,
                                        TextInputType.name,
                                        validStateCivil(
                                            "Escriba el estado civil con el formato correcto"),
                                        Icon(Icons.person_2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isStateCivil: true,
                                        btnText1: stateCivil!),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        patientUser.address,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.black87,
                                                fontSize: 20),
                                      ),
                                    ),
                                    btnEdit(
                                        "Edita la dirección del paciente",
                                        "Dirección",
                                        _addressController,
                                        TextInputType.streetAddress,
                                        validAddressEditDoctor(
                                            "Escriba la dirección con el formato correcto"),
                                        Icon(Icons.person_2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isDirection: true,
                                        btnText1: address!),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      patientUser.phone,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black87,
                                              fontSize: 20),
                                    ),
                                    btnEdit(
                                        "Edita el número de celular del paciente",
                                        "Número de celular",
                                        _phoneController,
                                        TextInputType.phone,
                                        validPhoneEditDoctor(
                                            "Escriba el número de celular con el formato correcto"),
                                        Icon(Icons.phone,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isPhone: true,
                                        btnText1: phone!),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.numbers,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${patientUser.age.toString()} años",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black87,
                                              fontSize: 20),
                                    ),
                                    btnEdit(
                                        "Edita la edad del paciente",
                                        "Edad",
                                        _ageController,
                                        TextInputType.number,
                                        validAgeEditDoctor(
                                            "Escriba la edad con el formato correcto",
                                            _ageController),
                                        Icon(Icons.document_scanner,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isAge: true,
                                        btnText1: age.toString()),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 50,
                                indent: 50,
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.document_scanner,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      patientUser.dni,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black87,
                                              fontSize: 20),
                                    ),
                                    btnEdit(
                                        "Edita el # del dni del paciente",
                                        "Dni",
                                        _dniController,
                                        TextInputType.number,
                                        validDniEditDoctor(
                                            "Escriba el dni con el formato correcto"),
                                        Icon(Icons.numbers,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        isDni: true,
                                        btnText1: dni!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      backgroundFigureFooterPatient(context,
                          footer: true, height: 0.1),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget btnEdit(
    String title,
    String content,
    TextEditingController controllerr,
    TextInputType keyboardType,
    FormFieldValidator<String>? validator,
    Icon icon, {
    bool isName = false,
    bool isEmail = false,
    bool isStateCivil = false,
    bool isDirection = false,
    bool isPhone = false,
    bool isAge = false,
    bool isDni = false,
    String? btnText1,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: 40,
      child: InkWell(
        onTap: () async {
          widget.isName = isName;
          widget.isEmail = isEmail;
          widget.isStateCivil = isStateCivil;
          widget.isAddress = isDirection;
          widget.isPhone = isPhone;
          widget.isAge = isAge;
          widget.isDni = isDni;

          final name = await openDialog(context, title, content, controllerr,
              keyboardType, icon, validator,
              isName: widget.isName,
              isEmail: widget.isEmail,
              isStateCivil: widget.isStateCivil,
              isDirection: widget.isAddress,
              isPhone: widget.isPhone,
              isAge: widget.isAge,
              isDni: widget.isDni);
          if (name == null) return;
          setState(() {
            if (widget.isName == true) {
              btnText1 = name;
            }
            if (widget.isEmail == true) {
              btnText1 = name;
            }
            if (widget.isStateCivil == true) {
              btnText1 = name;
            }
            if (widget.isAddress == true) {
              btnText1 = name;
            }
            if (widget.isPhone == true) {
              btnText1 = name;
            }
            if (widget.isAge == true) {
              btnText1 = name;
            }
            if (widget.isDni == true) {
              btnText1 = name;
            }
          });
        },
        child: const Icon(Icons.edit, color: Colors.blue, size: 30),
      ),
    );
  }

  Future<String?> openDialog(
      BuildContext context,
      String title,
      String content,
      TextEditingController controller,
      TextInputType keyboardType,
      Icon icon,
      FormFieldValidator<String>? validator,
      {bool? isName = false,
      bool? isEmail = false,
      bool? isStateCivil = false,
      bool? isDirection = false,
      bool? isPhone = false,
      bool? isAge = false,
      bool? isDni = false}) async {
    final size = MediaQuery.of(context).size;
    return showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        transitionBuilder: (context, al, _, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: al,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.blue, fontSize: 24)),
                    ),
                    const SizedBox(height: 20),
                    widget.isStateCivil == true
                        ? DropDownWithSearch(
                            searchController: controller,
                          )
                        : TextFormField(
                            validator: validator,
                            controller: controller,
                            keyboardType: keyboardType,
                            cursorColor:
                                Theme.of(context).colorScheme.onTertiary,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontSize: 20),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              labelStyle: TextStyle(
                                backgroundColor: Colors.transparent,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                              errorStyle: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 16)
                                    .fontSize,
                              ),
                              errorMaxLines: 2,
                              prefixIconColor:
                                  Theme.of(context).colorScheme.onTertiary,
                              prefixIcon: icon,
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    width: 5.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 5.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                      width: 5.0)),
                              labelText: content,
                            ),
                          ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar')),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: size.width * 0.3,
                        child: ElevatedButton(
                            onPressed: () async {
                              final patientService = PatientService();
                              final isValidForm =
                                  _formKey.currentState!.validate();
                              if (isValidForm) {
                                await patientService.updatePatient(context,
                                    fullName: isName!
                                        ? capitalizeSentences(
                                            controller.text.trim())
                                        : patientUser.fullName,
                                    email: isEmail!
                                        ? controller.text.trim()
                                        : patientUser.email,
                                    stateCivil: isStateCivil!
                                        ? controller.text.trim()
                                        : patientUser.civilStatus,
                                    address: isDirection!
                                        ? capitalizeSentences(
                                            controller.text.trim())
                                        : patientUser.address,
                                    phone: isPhone!
                                        ? controller.text.trim()
                                        : patientUser.phone,
                                    age: isAge!
                                        ? int.parse(controller.text.trim())
                                        : patientUser.age,
                                    dni: isDni!
                                        ? controller.text.trim()
                                        : patientUser.dni, onSuccess: () {
                                  setState(() {
                                    if (widget.isName == true) {
                                      patientUser.fullName =
                                          capitalizeSentences(controller.text);
                                    }
                                    if (widget.isEmail == true) {
                                      patientUser.email = controller.text;
                                    }
                                    if (widget.isStateCivil == true) {
                                      patientUser.civilStatus = controller.text;
                                    }
                                    if (widget.isAddress == true) {
                                      patientUser.address =
                                          capitalizeSentences(controller.text);
                                    }

                                    if (widget.isPhone == true) {
                                      patientUser.phone = controller.text;
                                    }
                                    if (widget.isAge == true) {
                                      patientUser.age =
                                          int.parse(controller.text);
                                    }
                                    if (widget.isDni == true) {
                                      patientUser.dni = controller.text;
                                    }
                                  });
                                });

                                //Navigator.of(context).pop(controller.text);
                              }
                            },
                            child: const Text("Guardar")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container();
        });
  }
}
