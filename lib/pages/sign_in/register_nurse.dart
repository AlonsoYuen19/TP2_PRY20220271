// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import '../../shared/user_prefs.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down_aux.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';
import '../../utils/widgets/text_form_field.dart';

class RegisterNurseScreen extends StatefulWidget {
  const RegisterNurseScreen({super.key});

  @override
  State<RegisterNurseScreen> createState() => _RegisterNurseScreenState();
}

class _RegisterNurseScreenState extends State<RegisterNurseScreen> {
  String name = "";
  String password = "";
  String email = "";
  String address = "";
  String phone = "";
  String dni = "";
  String age = "";
  String cep = "";
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _dni = TextEditingController();
  final _age = TextEditingController();
  final _stateCivil = TextEditingController();
  final _cep = TextEditingController();
  final _auxiliar = TextEditingController();

  final nurseService = NurseAuthService();
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
    _cep.dispose();
    _auxiliar.dispose();
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
      if (_currentStep == 0 &&
          email == "" &&
          password == "" &&
          _formKey.currentState!.validate()) {
        print(_formKey.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 1 &&
          cep == "" &&
          dni == "" &&
          _formKey2.currentState!.validate()) {
        print(_formKey2.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 2 &&
          name == "" &&
          address == "" &&
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
                bool isAuxiliar;
                if (isValidForm &&
                    isValidForm2 &&
                    isValidForm3 &&
                    isValidForm4) {
                  print("Nombre Completo: " + capitalizeSentences(_name.text));
                  print("Contraseña: " + _password.text);
                  print("Correo: " + _email.text);
                  print("Direccion: " + capitalizeSentences(_address.text));
                  print("phone: " + _phone.text);
                  print("DNI: " + _dni.text);
                  print("Edad: " + _age.text);
                  print("CEP: " + _cep.text);
                  print("Estado Civil: " + _stateCivil.text);
                  print("Auxiliar: " + _auxiliar.text);
                  if (_auxiliar.text == "Si") {
                    isAuxiliar = true;
                  } else {
                    isAuxiliar = false;
                  }
                  print("El valor es :" + isAuxiliar.toString());
                  await nurseService.registerNurse(
                      context,
                      capitalizeSentences(_name.text.trim()),
                      _email.text.trim(),
                      _password.text.trim(),
                      _dni.text.trim(),
                      _age.text.trim(),
                      capitalizeSentences(_address.text.trim()),
                      _phone.text.trim(),
                      _cep.text.trim(),
                      "ROLE_NURSE",
                      _stateCivil.text.trim(),
                      isAuxiliar);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep == 0) {
          return true;
        } else {
          setState(() {
            _currentStep = _currentStep - 1;
          });
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: _currentStep == 2 ? true : false,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            leading: _currentStep == 0
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 16, bottom: 16),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  )
                : Container(),
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
                color: Theme.of(context).colorScheme.onBackground,
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
                      : Theme.of(context).colorScheme.onSecondary,
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
                            color: Theme.of(context).colorScheme.onSecondary)),
                  ),
                  content: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 350,
                        child: SingleChildScrollView(
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
                                  controllerr: _email,
                                  option: TextInputAction.next),
                              const SizedBox(height: 20),
                              GetTextFormField(
                                  labelText: "Contraseña",
                                  placeholder: password,
                                  icon: const Icon(Icons.lock),
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: validPassword(""),
                                  controllerr: _password,
                                  option: TextInputAction.next,
                                  onSubmit: (value) {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _currentStep += 1;
                                      print(_formKey.currentState!.validate());
                                      FocusScope.of(context).unfocus();
                                      setState(() {});
                                    }
                                  }),
                              //SizedBox(height: size.height * 0.225),
                            ],
                          ),
                        ),
                      ),
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
                            color: Theme.of(context).colorScheme.onSecondary)),
                  ),
                  content: Form(
                    key: _formKey2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 400,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GetTextFormField(
                                labelText: "CEP",
                                placeholder: cep,
                                icon: const Icon(Icons.code),
                                keyboardType: TextInputType.phone,
                                validator: validCep(
                                    "El número de teléfono debe ser de 6 dígitos"),
                                obscureText: false,
                                controllerr: _cep,
                                option: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              GetTextFormField(
                                labelText: "Dni",
                                placeholder: dni,
                                icon: const Icon(Icons.article_outlined),
                                keyboardType: TextInputType.number,
                                validator: validDni(
                                    "El número del dni debe ser de 8 dígitos"),
                                obscureText: false,
                                controllerr: _dni,
                                option: TextInputAction.none,
                                onSubmit: (value) {
                                  if (_formKey2.currentState!.validate()) {
                                    _formKey2.currentState!.save();
                                    _currentStep += 1;
                                    print(_formKey2.currentState!.validate());
                                    setState(() {});
                                  }
                                },
                              ),
                              SizedBox(height: size.height * 0.295),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled),
              Step(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        _currentStep == 2 ? "Información\npersonal" : "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary)),
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
                          obscureText: false,
                          option: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        GetTextFormField(
                          labelText: "Telefono",
                          placeholder: phone,
                          icon: const Icon(Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: validPhone(
                              "El número de teléfono debe ser de 9 dígitos"),
                          obscureText: false,
                          controllerr: _phone,
                          option: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        GetTextFormField(
                          maxLength: 50,
                          labelText: "Dirección",
                          placeholder: address,
                          icon: const Icon(Icons.house),
                          keyboardType: TextInputType.streetAddress,
                          validator: validAddress(
                              "Escriba la dirección con el formato correcto"),
                          obscureText: false,
                          controllerr: _address,
                          option: TextInputAction.send,
                          onSubmit: (value) {
                            if (_formKey3.currentState!.validate()) {
                              _formKey3.currentState!.save();
                              _currentStep += 1;
                              print(_formKey3.currentState!.validate());
                              setState(() {});
                            }
                          },
                        ),
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
                    child: Text(
                        _currentStep == 3 ? "Información\nadicional" : "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary)),
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
                            controllerr: _age,
                            option: TextInputAction.done),
                        SizedBox(height: 20),
                        title("Estado Civil"),
                        DropDownWithSearch(
                          searchController: _stateCivil,
                        ),
                        const SizedBox(height: 20),
                        title("¿Estará disponible para ser enfermero auxiliar"),
                        DropDownWithAuxiliar(
                          searchController: _auxiliar,
                        ),
                        SizedBox(height: size.height * 0.17),
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
      ),
    );
  }
}
