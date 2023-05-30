// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/patient_service.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';
import '../../utils/widgets/text_form_field.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  String name = "";
  String email = "";
  String address = "";
  String phone = "";
  String dni = "";
  String age = "";
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _dni = TextEditingController();
  final _age = TextEditingController();
  final _stateCivil = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  @override
  void dispose() {
    _stateCivil.dispose();
    super.dispose();
  }

  Widget title(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  continuedStep() {
    setState(() {
      if (_currentStep < 1) {
        _currentStep++;
      }
    });
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget controlBuilders(context, details) {
    final size = MediaQuery.of(context).size;
    final patientService = PatientService();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_currentStep > 0) ...[
            SizedBox(
              width: size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, elevation: 0),
                onPressed: details.onStepCancel,
                child: Text(
                  "Retroceder",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromRGBO(255, 161, 158, 1),
                ),
                onPressed: () async {
                  final isValidForm = _formKey.currentState!.validate();
                  if (isValidForm) {
                    print("Nombre Completo: " + _name.text);
                    print("Correo: " + _email.text);
                    print("Direccion: " + _address.text);
                    print("phone: " + _phone.text);
                    print("DNI: " + _dni.text);
                    print("Edad: " + _age.text);
                    print("Estado Civil: " + _stateCivil.text);
                    print("El id del medico es: " + prefs.idMedic.toString());
                    int age = int.parse(_age.text.trim());
                    print(age);
                    await patientService.registerPatient(
                      context,
                      _name.text.trim(),
                      _email.text.trim(),
                      _dni.text.trim(),
                      _phone.text.trim(),
                      age,
                      _address.text.trim(),
                      _stateCivil.text.trim(),
                    );
                    if (!mounted) {
                      return;
                    }
                  }
                },
                child: Text(
                  "Registrarse",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                ),
              ),
            ),
          ] else if (_currentStep == 0) ...[
            SizedBox(
              width: size.width * 0.75,
              child: ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(255, 161, 158, 1)),
                child: Text('Siguiente',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                        )),
              ),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: FloatingActionButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.outline,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: size.width * 0.1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: paddingHori, vertical: 20),
                          child: Text(
                            "Registro de Paciente",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSeed(
                            primary: Theme.of(context).colorScheme.onSecondary,
                            error: Colors.red,
                            onBackground:
                                Theme.of(context).colorScheme.onBackground,
                            seedColor:
                                Theme.of(context).colorScheme.onBackground)),
                    child: Stepper(
                      margin:
                          const EdgeInsets.only(left: 55, right: 25, top: 5),
                      type: StepperType.vertical,
                      physics: const ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepCancel: cancel,
                      onStepContinue: continuedStep,
                      onStepTapped: tapped,
                      controlsBuilder: controlBuilders,
                      elevation: 0,
                      steps: [
                        Step(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingHori),
                              child: Text("Información del Contacto",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      )),
                            ),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GetTextFormField(
                                    labelText: "Nombre Completo",
                                    placeholder: name,
                                    icon: const Icon(
                                        Icons.person_add_alt_1_sharp),
                                    keyboardType: TextInputType.name,
                                    validator: validName(
                                        "Escriba el nombre con el formato correcto"),
                                    controllerr: _name,
                                    obscureText: false),
                                const Divider(
                                  thickness: 1.3,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: size.height * 0.01),
                                GetTextFormField(
                                    labelText: "Correo",
                                    placeholder: email,
                                    icon: const Icon(Icons.email),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: validEmail(
                                        "Escriba el correo con el formato correcto"),
                                    obscureText: false,
                                    controllerr: _email),
                                const Divider(
                                  thickness: 1.3,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: size.height * 0.01),
                                GetTextFormField(
                                    labelText: "Telefono",
                                    placeholder: phone,
                                    icon: const Icon(Icons.phone),
                                    keyboardType: TextInputType.phone,
                                    validator: validPhone(
                                        "El número de teléfono debe ser de 9 dígitos"),
                                    obscureText: false,
                                    controllerr: _phone),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0
                                ? StepState.complete
                                : StepState.disabled),
                        Step(
                            title: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingHori),
                                child: Text("Detalles Personales",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ))),
                            content: Column(
                              children: [
                                GetTextFormField(
                                    labelText: "Dirección",
                                    placeholder: address,
                                    icon: const Icon(Icons.house),
                                    keyboardType: TextInputType.streetAddress,
                                    validator: validAddress(
                                        "Escriba la dirección con el formato correcto"),
                                    obscureText: false,
                                    controllerr: _address),
                                const Divider(
                                  thickness: 1.3,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: size.height * 0.01),
                                GetTextFormField(
                                    labelText: "Dni",
                                    placeholder: dni,
                                    icon: const Icon(Icons.card_membership),
                                    keyboardType: TextInputType.number,
                                    validator: validDni(
                                        "El número del dni debe ser de 8 dígitos"),
                                    obscureText: false,
                                    controllerr: _dni),
                                const Divider(
                                  thickness: 1.3,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: size.height * 0.01),
                                GetTextFormField(
                                    labelText: "Edad",
                                    placeholder: age,
                                    icon: const Icon(Icons.numbers),
                                    keyboardType: TextInputType.number,
                                    validator: validAgePatient(
                                        "La edad debe ser válida con el formato correcto",
                                        _age),
                                    obscureText: false,
                                    controllerr: _age),
                                const Divider(
                                  thickness: 1.3,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: size.height * 0.01),
                                title("Estado Civil"),
                                DropDownWithSearch(
                                  searchController: _stateCivil,
                                ),
                                SizedBox(height: size.height * 0.03),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1
                                ? StepState.complete
                                : StepState.disabled),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
