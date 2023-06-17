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
      if (_currentStep == 0 && _formKey.currentState!.validate()) {
        print(_formKey.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 1 && _formKey2.currentState!.validate()) {
        print(_formKey2.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 2 && _formKey3.currentState!.validate()) {
        print(_formKey3.currentState!.validate());
        _currentStep++;
      } else if (_currentStep == 3 && _formKey4.currentState!.validate()) {
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

  Widget controlBuilders(context, details) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_currentStep == 3) ...[
          SizedBox(
            width: size.width * 1,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromRGBO(255, 161, 158, 1),
              ),
              onPressed: _formKey4.currentState == null ||
                      !_formKey4.currentState!.validate() ||
                      _age.text == "" ||
                      onceTime == false
                  ? null
                  : () async {
                      final isValidForm = _formKey.currentState!.validate();
                      final isValidForm2 = _formKey2.currentState!.validate();
                      final isValidForm3 = _formKey3.currentState!.validate();
                      final isValidForm4 = _formKey4.currentState!.validate();
                      if (isValidForm &&
                          isValidForm2 &&
                          isValidForm3 &&
                          isValidForm4) {
                        //onceTime = false;
                        print("Nombre Completo: " + _name.text);
                        print("Contraseña: " + _password.text);
                        print("Correo: " + _email.text);
                        print("Direccion: " + _address.text);
                        print("phone: " + _phone.text);
                        print("DNI: " + _dni.text);
                        print("Edad: " + _age.text);
                        print("Estado Civil: " + _stateCivil.text);
                        print("CMP: " + _cmp.text);
                        print(onceTime);
                        setState(() {
                          onceTime = false;
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              onceTime = true;
                            });
                          });
                        });
                        await authService.registerMedic(
                          context,
                          capitalizeSentences(_name.text.trim()),
                          _email.text.trim(),
                          _password.text.trim(),
                          _dni.text.trim(),
                          _age.text.trim(),
                          capitalizeSentences(_address.text.trim()),
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
            height: 50,
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
            height: 50,
            child: ElevatedButton(
              onPressed: _formKey.currentState == null ||
                      !_formKey.currentState!.validate() ||
                      _email.text == "" ||
                      _password.text == ""
                  ? null
                  : details.onStepContinue,
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
        ] else if (_currentStep == 1) ...[
          Column(
            children: [
              SizedBox(
                width: size.width * 1,
                height: 50,
                child: ElevatedButton(
                  onPressed: _formKey2.currentState == null ||
                          !_formKey2.currentState!.validate() ||
                          _cmp.text == "" ||
                          _dni.text == ""
                      ? null
                      : details.onStepContinue,
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
                height: 50,
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
        ] else if (_currentStep == 2) ...[
          Column(
            children: [
              SizedBox(
                width: size.width * 1,
                height: 50,
                child: ElevatedButton(
                  onPressed: _formKey3.currentState == null ||
                          !_formKey3.currentState!.validate() ||
                          _name.text == "" ||
                          _phone.text == "" ||
                          _address.text == ""
                      ? null
                      : details.onStepContinue,
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
                height: 50,
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

  bool onceTime = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);
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
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            leading: _currentStep == 0
                ? Padding(
                    padding: size.longestSide < 600
                        ? const EdgeInsets.only(
                            left: 20, right: 20, top: 8, bottom: 8)
                        : const EdgeInsets.only(
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
            toolbarHeight: size.longestSide < 600 ? 70 : 90,
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
                    padding: const EdgeInsets.all(6.0),
                    child: Text(_currentStep == 0 ? "Credenciales" : "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSecondary)),
                  ),
                  content: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Container(
                        height: size.longestSide < 600
                            ? size.height - 280
                            : size.height - 350,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: GetTextFormField(
                                  labelText: "Correo",
                                  placeholder: email,
                                  maxLength: 60,
                                  icon: const Icon(Icons.email),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _email.text == ""
                                      ? null
                                      : validEmail(
                                          "Escriba el correo con el formato correcto"),
                                  obscureText: false,
                                  controllerr: _email,
                                  option: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(height: 15),
                              GetTextFormField(
                                labelText: "Contraseña",
                                placeholder: password,
                                icon: const Icon(Icons.lock),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                validator: _password.text == ""
                                    ? null
                                    : validPassword(""),
                                controllerr: _password,
                                option: TextInputAction.done,
                                onSubmit: (value) {
                                  if (_formKey.currentState!.validate()) {
                                    //_currentStep += 1;
                                    _formKey.currentState!.save();
                                    print(_formKey.currentState!.validate());
                                    //FocusScope.of(context).unfocus();
                                    setState(() {});
                                  }
                                },
                              ),
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
                  child: Text(
                    _currentStep == 1 ? "Identificacion" : "",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                  ),
                ),
                content: Form(
                  key: _formKey2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: Container(
                      height: size.longestSide < 600
                          ? size.height - 325
                          : size.height - 400,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GetTextFormField(
                                labelText: "CMP",
                                placeholder: cmp,
                                icon: const Icon(Icons.code),
                                keyboardType: TextInputType.phone,
                                validator: _cmp.text == ""
                                    ? null
                                    : validCmp(
                                        "El número del cmp debe de iniciar con 0 tener 6 dígitos",
                                      ),
                                obscureText: false,
                                controllerr: _cmp,
                                option: TextInputAction.next,
                              ),
                            ),
                            SizedBox(height: 20),
                            GetTextFormField(
                              labelText: "Dni",
                              placeholder: dni,
                              icon: const Icon(Icons.article_outlined),
                              keyboardType: TextInputType.number,
                              validator: _dni.text == ""
                                  ? null
                                  : validDni(
                                      "El número del dni debe ser de 8 dígitos"),
                              obscureText: false,
                              controllerr: _dni,
                              option: TextInputAction.done,
                              onSubmit: (value) {
                                if (_formKey2.currentState!.validate()) {
                                  _formKey2.currentState!.save();

                                  print(_formKey2.currentState!.validate());
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        _currentStep == 2 ? "Información\npersonal" : "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSecondary)),
                  ),
                  content: Form(
                    key: _formKey3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      height: size.longestSide < 600
                          ? size.height - 325
                          : size.height - 400,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GetTextFormField(
                                labelText: "Nombre Completo",
                                maxLength: 36,
                                placeholder: name,
                                icon: const Icon(Icons.person_add_alt_1_sharp),
                                keyboardType: TextInputType.visiblePassword,
                                validator: _name.text == ""
                                    ? null
                                    : validName(
                                        "Escriba el nombre con el formato correcto"),
                                controllerr: _name,
                                obscureText: false,
                                option: TextInputAction.next,
                              ),
                            ),
                            SizedBox(height: 15),
                            GetTextFormField(
                              labelText: "Telefono",
                              placeholder: phone,
                              icon: const Icon(Icons.phone),
                              keyboardType: TextInputType.phone,
                              validator: _phone.text == ""
                                  ? null
                                  : validPhone(
                                      "El número de teléfono debe ser de 9 dígitos"),
                              obscureText: false,
                              controllerr: _phone,
                              option: TextInputAction.next,
                            ),
                            SizedBox(height: 15),
                            GetTextFormField(
                              maxLength: 50,
                              labelText: "Dirección",
                              placeholder: address,
                              icon: const Icon(Icons.house),
                              keyboardType: TextInputType.streetAddress,
                              validator: _address.text == ""
                                  ? null
                                  : validAddress(
                                      "Escriba la dirección con el formato correcto"),
                              obscureText: false,
                              controllerr: _address,
                              option: TextInputAction.none,
                              onSubmit: (value) {
                                if (_formKey3.currentState!.validate()) {
                                  _formKey3.currentState!.save();
                                  //_currentStep += 1;
                                  print(_formKey3.currentState!.validate());
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
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
                    child: Container(
                      height: size.longestSide < 600
                          ? size.height - 325
                          : size.height - 400,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GetTextFormField(
                                  labelText: "Edad",
                                  placeholder: age,
                                  icon: const Icon(Icons.numbers),
                                  keyboardType: TextInputType.number,
                                  validator: _age.text == ""
                                      ? null
                                      : validAge(
                                          "La edad debe tener el formato correcto",
                                          _age),
                                  obscureText: false,
                                  controllerr: _age,
                                  option: TextInputAction.none),
                            ),
                            SizedBox(height: 15),
                            title("Estado Civil"),
                            DropDownWithSearch(
                              searchController: _stateCivil,
                            ),
                          ],
                        ),
                      ),
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
