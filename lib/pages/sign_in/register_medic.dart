// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/medic_service.dart';
import '../../shared/user_prefs.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';
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
  String cmp = "";
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _dni = TextEditingController();
  final _age = TextEditingController();
  final _stateCivil = TextEditingController();
  final _cmp = TextEditingController();

  final authService = MedicAuthServic();
  final prefs = SaveData();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  int _currentStep = 0;
  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    _email.dispose();
    _address.dispose();
    _phone.dispose();
    _dni.dispose();
    _age.dispose();
    _stateCivil.dispose();
    _cmp.dispose();
    super.dispose();
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  continuedStep() {
    setState(() {
      if (_currentStep == 0 &&
          email == "" &&
          password == "" &&
          _formKey.currentState!.validate()) {
        print(_formKey.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 1 &&
          cmp == "" &&
          dni == "" &&
          _formKey2.currentState!.validate()) {
        print(_formKey2.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 2 &&
          name == "" &&
          address == "" &&
          phone == "" &&
          _formKey3.currentState!.validate()) {
        print(_formKey3.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 3 &&
          age == "" &&
          _formKey4.currentState!.validate()) {
        print(_formKey4.currentState!.validate());
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_currentStep == 3) ...[
          SizedBox(
            width: size.width * 1,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromRGBO(255, 161, 158, 1),
              ),
              onPressed: () async {
                final isValidForm = _formKey.currentState!.validate();
                final isValidForm2 = _formKey2.currentState!.validate();
                final isValidForm3 = _formKey3.currentState!.validate();
                final isValidForm4 = _formKey4.currentState!.validate();
                if (isValidForm &&
                    isValidForm2 &&
                    isValidForm3 &&
                    isValidForm4) {
                  print("Nombre Completo: " + _name.text);
                  print("Contraseña: " + _password.text);
                  print("Correo: " + _email.text);
                  print("Direccion: " + _address.text);
                  print("phone: " + _phone.text);
                  print("DNI: " + _dni.text);
                  print("Edad: " + _age.text);
                  print("Estado Civil: " + _stateCivil.text);
                  print("CMP: " + _cmp.text);
                  await authService.registerMedic(
                    context,
                    _name.text.trim(),
                    _email.text.trim(),
                    _password.text.trim(),
                    _dni.text.trim(),
                    _age.text.trim(),
                    _address.text.trim(),
                    _phone.text.trim(),
                    _cmp.text.trim(),
                    "ROLE_MEDIC",
                    _stateCivil.text.trim(),
                  );
                }
              },
              child: Text(
                "Registrarse",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: size.width * 1,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromRGBO(255, 161, 158, 1), width: 1.5),
                  backgroundColor: Color.fromRGBO(255, 242, 241, 1),
                  elevation: 0),
              onPressed: details.onStepCancel,
              child: Text(
                "Retroceder",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Color.fromRGBO(255, 161, 158, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
          ),
        ] else if (_currentStep == 0) ...[
          SizedBox(
            width: size.width * 1,
            height: 56,
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color.fromRGBO(255, 161, 158, 1)),
              child: Text('Siguiente',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ] else if (_currentStep > 0 && _currentStep < 3) ...[
          Column(
            children: [
              SizedBox(
                width: size.width * 1,
                height: 56,
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Color.fromRGBO(255, 161, 158, 1)),
                  child: Text('Siguiente',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: size.width * 1,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color: Color.fromRGBO(255, 161, 158, 1), width: 1.5),
                      backgroundColor: Color.fromRGBO(255, 242, 241, 1),
                      elevation: 0),
                  onPressed: details.onStepCancel,
                  child: Text(
                    "Retroceder",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Color.fromRGBO(255, 161, 158, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ]
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer), // <-- Button color
                  elevation: MaterialStateProperty.all(0), // <-- Splash color
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_outlined,
                    color: Theme.of(context).colorScheme.onTertiary, size: 18)),
          ),
          leadingWidth: 96,
          centerTitle: true,
          toolbarHeight: 90,
          automaticallyImplyLeading: false,
          title: Text(
            "Registro",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        body: Stepper(
          stepIconBuilder: (stepIndex, stepState) {
            return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: stepIndex == _currentStep
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "${stepIndex + 1}",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 14),
                ),
              ),
            );
          },
          margin: EdgeInsets.zero,
          type: StepperType.horizontal,
          onStepTapped: null,
          physics: const BouncingScrollPhysics(),
          currentStep: _currentStep,
          onStepCancel: cancel,
          onStepContinue: continuedStep,
          //onStepTapped: tapped,
          controlsBuilder: controlBuilders,
          elevation: 0,
          steps: [
            Step(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentStep == 0 ? "Credenciales" : "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline)),
                ),
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GetTextFormField(
                          labelText: "Correo",
                          placeholder: email,
                          maxLength: 20,
                          icon: const Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: validEmail(
                              "Escriba el correo con el formato correcto"),
                          obscureText: false,
                          controllerr: _email),
                      SizedBox(height: 20),
                      GetTextFormField(
                        labelText: "Contraseña",
                        placeholder: password,
                        icon: const Icon(Icons.lock),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: validPassword(""),
                        controllerr: _password,
                      ),
                      SizedBox(height: size.height * 0.225),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 0
                    ? StepState.complete
                    : StepState.disabled),
            Step(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentStep == 1 ? "Identificacion" : "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline)),
                ),
                content: Form(
                  key: _formKey2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      GetTextFormField(
                          labelText: "CMP",
                          placeholder: cmp,
                          icon: const Icon(Icons.code),
                          keyboardType: TextInputType.phone,
                          validator: validCmp(
                              "El número del cmp debe de iniciar con 0 tener 6 dígitos"),
                          obscureText: false,
                          controllerr: _cmp),
                      SizedBox(height: 20),
                      GetTextFormField(
                          labelText: "Dni",
                          placeholder: dni,
                          icon: const Icon(Icons.article_outlined),
                          keyboardType: TextInputType.number,
                          validator: validDni(
                              "El número del dni debe ser de 8 dígitos"),
                          obscureText: false,
                          controllerr: _dni),
                      SizedBox(height: size.height * 0.295),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 1
                    ? StepState.complete
                    : StepState.disabled),
            Step(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentStep == 2 ? "Información\npersonal" : "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline)),
                ),
                content: Form(
                  key: _formKey3,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      GetTextFormField(
                          labelText: "Nombre Completo",
                          maxLength: 36,
                          placeholder: name,
                          icon: const Icon(Icons.person_add_alt_1_sharp),
                          keyboardType: TextInputType.name,
                          validator: validName(
                              "Escriba el nombre con el formato correcto"),
                          controllerr: _name,
                          obscureText: false),
                      SizedBox(height: 20),
                      GetTextFormField(
                          labelText: "Telefono",
                          placeholder: phone,
                          icon: const Icon(Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: validPhone(
                              "El número de teléfono debe ser de 9 dígitos"),
                          obscureText: false,
                          controllerr: _phone),
                      SizedBox(height: 20),
                      GetTextFormField(
                          labelText: "Dirección",
                          placeholder: address,
                          icon: const Icon(Icons.house),
                          keyboardType: TextInputType.streetAddress,
                          validator: validAddress(
                              "Escriba la dirección con el formato correcto"),
                          obscureText: false,
                          controllerr: _address),
                      SizedBox(height: size.height * 0.19),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 2
                    ? StepState.complete
                    : StepState.disabled),
            Step(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentStep == 3 ? "Información\nadicional" : "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline)),
                ),
                content: Form(
                  key: _formKey4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      GetTextFormField(
                          labelText: "Edad",
                          placeholder: age,
                          icon: const Icon(Icons.numbers),
                          keyboardType: TextInputType.number,
                          validator: validAge(
                              "La edad debe tener el formato correcto", _age),
                          obscureText: false,
                          controllerr: _age),
                      SizedBox(height: 20),
                      title("Estado Civil"),
                      DropDownWithSearch(
                        searchController: _stateCivil,
                      ),
                      SizedBox(height: size.height * 0.3),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 3
                    ? StepState.complete
                    : StepState.disabled),
          ],
        ),
      ),
    );
  }
}
