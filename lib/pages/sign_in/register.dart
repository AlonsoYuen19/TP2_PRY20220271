// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/pages/sign_in/login.dart';
import 'package:ulcernosis/services/user_auth_service.dart';
import 'package:ulcernosis/utils/widgets/background_figure.dart';

import '../../shared/user_prefs.dart';
import '../../utils/providers/auth_token.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/drop_down.dart';
import '../../utils/widgets/text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = "";
  String password = "";
  String email = "";
  String address = "";
  String phone = "";
  String dni = "";
  String age = "";
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _dni = TextEditingController();
  final _age = TextEditingController();
  final _stateCivil = TextEditingController();

  final authService = UserServiceAuth();
  final prefs = SaveData();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  @override
  void dispose() {
    _stateCivil.dispose();
    super.dispose();
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingHori, vertical: 5),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.lightBlue),
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
    final tokenProvider = Provider.of<AuthProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_currentStep > 0) ...[
            SizedBox(
              width: size.width * 0.35,
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
            SizedBox(
              width: size.width * 0.35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 10),
                ),
                onPressed: () async {
                  final isValidForm = _formKey.currentState!.validate();
                  if (isValidForm) {
                    print("Nombre Completo: " + _name.text);
                    print("Contrase??a: " + _password.text);
                    print("Correo: " + _email.text);
                    print("Direccion: " + _address.text);
                    print("phone: " + _phone.text);
                    print("DNI: " + _dni.text);
                    print("Edad: " + _age.text);
                    print("Estado Civil: " + _stateCivil.text);
                    prefs.email = _email.text;
                    prefs.password = _password.text;
                    await authService.registerDoctor(
                        _name.text.trim(),
                        _password.text.trim(),
                        _email.text.trim(),
                        _stateCivil.text.trim(),
                        _address.text.trim(),
                        _phone.text.trim(),
                        _dni.text.trim(),
                        _age.text.trim());
                    await tokenProvider.updateToken(context);
                    if (!mounted) {
                      return;
                    }

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
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
              width: size.width * 0.35,
              child: ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(0, 0, 255, 10)),
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
        registerBackgroundFigure(context),
        Center(
          child: SingleChildScrollView(
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
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: size.width * 0.1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingHori, vertical: 20),
                            child: Text(
                              "Registro",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Colors.lightBlue,
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
                              primary: Colors.lightBlue,
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
                                child: Text("Informaci??n del Contacto",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 20,
                                            color: Colors.lightBlue)),
                              ),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  title("Nombre Completo"),
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
                                  title("Contrase??a"),
                                  GetTextFormField(
                                    labelText: "Contrase??a",
                                    placeholder: password,
                                    icon: const Icon(Icons.lock),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: validPassword(""),
                                    controllerr: _password,
                                  ),
                                  const Divider(
                                    thickness: 1.3,
                                    color: Colors.grey,
                                  ),
                                  title("Correo Electr??nico"),
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
                                  title("Telefono	"),
                                  GetTextFormField(
                                      labelText: "Telefono",
                                      placeholder: phone,
                                      icon: const Icon(Icons.phone),
                                      keyboardType: TextInputType.phone,
                                      validator: validPhone(
                                          "El n??mero de tel??fono debe ser de 9 d??gitos"),
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
                                              color: Colors.lightBlue))),
                              content: Column(
                                children: [
                                  title("Direcci??n"),
                                  GetTextFormField(
                                      labelText: "Direcci??n",
                                      placeholder: address,
                                      icon: const Icon(Icons.house),
                                      keyboardType: TextInputType.streetAddress,
                                      validator: validAddress(
                                          "Escriba el correo con el formato correcto"),
                                      obscureText: false,
                                      controllerr: _address),
                                  const Divider(
                                    thickness: 1.3,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  title("Dni"),
                                  GetTextFormField(
                                      labelText: "Dni",
                                      placeholder: dni,
                                      icon: const Icon(Icons.card_membership),
                                      keyboardType: TextInputType.number,
                                      validator: validDni(
                                          "El n??mero del dni debe ser de 8 d??gitos"),
                                      obscureText: false,
                                      controllerr: _dni),
                                  const Divider(
                                    thickness: 1.3,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  title("Edad"),
                                  GetTextFormField(
                                      labelText: "Edad",
                                      placeholder: age,
                                      icon: const Icon(Icons.numbers),
                                      keyboardType: TextInputType.number,
                                      validator: validAge(
                                          "La edad debe tener el formato correcto",
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
          ),
        )
      ]),
    );
  }
}
