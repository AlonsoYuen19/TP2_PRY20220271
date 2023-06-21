// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';

class PatientProfileScreen extends StatefulWidget {
  bool? isName;
  bool? isEmail;
  bool? isStateCivil;
  bool? isAddress;
  bool? isPhone;
  bool? isAge;
  bool? isDni;
  final Patient? patient;
  PatientProfileScreen(
      {super.key,
      this.isName = false,
      this.isEmail = false,
      this.isStateCivil = false,
      this.isAddress = false,
      this.isPhone = false,
      this.isAge = false,
      this.isDni = false,
      this.patient});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 1), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stateCivilController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? stateCivil;
  String? address;
  String? phone;
  int? age;
  String? dni;

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
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(250, 250, 250, 1),
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
                "Perfil del paciente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: size.width * 1,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage:
                            AssetImage("assets/images/patient-logo.png"),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                widget.patient?.fullName ?? "Nombre",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 18),
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                isName: true,
                                btnText1: name ?? ""),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                widget.patient?.email ?? "Correo Electrónico",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isEmail: true,
                                btnText1: email ?? ""),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Text(widget.patient?.civilStatus ?? "Estado civil",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            btnEdit(
                                "Edita el estado civil del paciente",
                                "Estado civil",
                                _stateCivilController,
                                TextInputType.name,
                                validStateCivil(
                                    "Escriba el estado civil con el formato correcto"),
                                Icon(Icons.person_2,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isStateCivil: true,
                                btnText1: stateCivil ?? ""),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                widget.patient?.address ?? "Dirección",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 18),
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isDirection: true,
                                btnText1: address ?? ""),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.patient?.phone ?? "Número de celular",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 18),
                            ),
                            btnEdit(
                                "Edita el número de celular del paciente",
                                "Número de celular",
                                _phoneController,
                                TextInputType.phone,
                                validPhoneEditDoctor(
                                    "Escriba el número de celular con el formato correcto"),
                                Icon(Icons.phone,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isPhone: true,
                                btnText1: phone ?? ""),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.patient?.age.toString()} años",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 18),
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isAge: true,
                                btnText1: age.toString()),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.patient?.dni ?? "Dni",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 18),
                            ),
                            btnEdit(
                                "Edita el # del dni del paciente",
                                "Dni",
                                _dniController,
                                TextInputType.number,
                                validDniEditDoctor(
                                    "Escriba el dni con el formato correcto"),
                                Icon(Icons.numbers,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                isDni: true,
                                btnText1: dni ?? ""),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: size.width * 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Regresar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ))));
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
          //setState(() {
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
          //});
        },
        child: Icon(Icons.edit,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 24),
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
        transitionBuilder: (context, a1, _, child) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          final screenHeight = MediaQuery.of(context).size.height;
          final dialogHeight = screenHeight * 0.7;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: a1,
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.easeOutCubic),
              child: Container(
                height: dialogHeight,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  content: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        widget.isStateCivil == true
                            ? DropDownWithSearch(
                                searchController: controller,
                              )
                            : TextFormField(
                                validator: validator,
                                controller: controller,
                                keyboardType: keyboardType,
                                cursorColor:
                                    Theme.of(context).colorScheme.tertiary,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                      backgroundColor: Colors.transparent,
                                      color: Color.fromRGBO(180, 168, 170, 1),
                                      fontWeight: FontWeight.w400),
                                  errorStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 12)
                                        .fontSize,
                                  ),
                                  errorMaxLines: 2,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        width: 1.2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        width: 1.2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          width: 1.2)),
                                  labelText: content,
                                ),
                              ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: size.width * 1,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        Color.fromRGBO(255, 161, 158, 1),
                                  ),
                                  onPressed: () async {
                                    final patientService = PatientService();
                                    final isValidForm =
                                        _formKey.currentState!.validate();
                                    if (isValidForm) {
                                      var result = await patientService
                                          .updatePatient(context,
                                              fullName: isName!
                                                  ? capitalizeSentences(
                                                      controller.text.trim())
                                                  : widget.patient!.fullName,
                                              email: isEmail!
                                                  ? controller.text.trim()
                                                  : widget.patient!.email,
                                              stateCivil: isStateCivil!
                                                  ? controller.text.trim()
                                                  : widget.patient!.civilStatus,
                                              address: isDirection!
                                                  ? capitalizeSentences(
                                                      controller.text.trim())
                                                  : widget.patient!.address,
                                              phone: isPhone!
                                                  ? controller.text.trim()
                                                  : widget.patient!.phone,
                                              age: isAge!
                                                  ? int.parse(
                                                      controller.text.trim())
                                                  : widget.patient!.age,
                                              dni: isDni!
                                                  ? controller.text.trim()
                                                  : widget.patient!.dni,
                                              onSuccess: () {
                                        //setState(() {
                                        if (widget.isName == true) {
                                          widget.patient!.fullName =
                                              capitalizeSentences(
                                                  controller.text);
                                        }
                                        if (widget.isEmail == true) {
                                          widget.patient!.email =
                                              controller.text;
                                        }
                                        if (widget.isStateCivil == true) {
                                          widget.patient!.civilStatus =
                                              controller.text;
                                        }
                                        if (widget.isAddress == true) {
                                          widget.patient!.address =
                                              capitalizeSentences(
                                                  controller.text);
                                        }

                                        if (widget.isPhone == true) {
                                          widget.patient!.phone =
                                              controller.text;
                                        }
                                        if (widget.isAge == true) {
                                          widget.patient!.age =
                                              int.parse(controller.text);
                                        }
                                        if (widget.isDni == true) {
                                          widget.patient!.dni = controller.text;
                                        }
                                      });
                                      print(result);
                                      if (result != null) {
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: Text("Guardar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          )))),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: size.width * 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                        color: Color.fromRGBO(255, 161, 158, 1),
                                        width: 1.5),
                                    backgroundColor:
                                        Color.fromRGBO(255, 242, 241, 1),
                                    elevation: 0),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancelar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color:
                                              Color.fromRGBO(255, 161, 158, 1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                )),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container();
        });
  }
}
