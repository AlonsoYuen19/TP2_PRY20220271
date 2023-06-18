// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/utils/widgets/background_figure.dart';
import '../../models/users.dart';
import '../../services/medic_service.dart';
import '../../services/users_service.dart';
import '../../shared/user_prefs.dart';
import '../../utils/providers/auth_token.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/text_form_field.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String email = "";
String password = "";

class _LoginScreenState extends State<LoginScreen> {
  final _prefs = SaveData();
  final authService = MedicAuthServic();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPressed = false;
  @override
  void initState() {
    print("token : " + prefs.token);
    print(prefs.login);
    init();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  void checkLogin() async {
    var isLogin = _prefs.login;
    var email = _prefs.email;
    var password = _prefs.password;
    print("Email rialnofaik: $email");
    print("Password rialnofaik: $password");
    if (!mounted) {
      return;
    }
    if (isLogin == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List<String> medic = [];
  Users users = Users();
  Future init() async {
    //obtener el token
    Provider.of<AuthProvider>(context, listen: false);
    print("Id del user: " + prefs.idUsers.toString());
    print("Id del enfermero: " + prefs.idNurse.toString());
    print("Id del medico: " + prefs.idMedic.toString());
  }

  final texts = ["Brindar", "Ayudar", "Diagnosticar", "En ese orden"];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  backgroundFigure(
                    context,
                    height: 0.3,
                  ),
                  Positioned(
                    bottom: 40,
                    left: size.width * 0.39,
                    child: Image.asset(
                      'assets/images/just_logo.png',
                      fit: BoxFit.cover,
                      height: 55,
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.043),
                    GetTextFormField(
                      labelText: "Correo",
                      placeholder: email,
                      controllerr: emailController,
                      icon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: validEmail(
                          "Escriba el correo con el formato correcto"),
                      obscureText: false,
                      isRegisterPassword: false,
                      option: TextInputAction.next,
                    ),
                    SizedBox(height: 28),
                    GetTextFormField(
                        labelText: "Contraseña",
                        placeholder: password,
                        controllerr: passwordController,
                        icon: const Icon(Icons.lock),
                        keyboardType: TextInputType.visiblePassword,
                        validator: validPasswordLogin("Rellene la contraseña"),
                        obscureText: true,
                        isRegisterPassword: false,
                        option: TextInputAction.send,
                        onChanged:
                            (_isPressed == false ? _handleButton : null)),
                    SizedBox(height: size.height * 0.096),
                    signInButton(context),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Aún no tienes una cuenta? ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                          ),
                          GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, "preRegister");
                              },
                              child: Text("Crear cuenta",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontSize: 16,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer)))
                        ],
                      ),
                    ),
                    size.longestSide < 600
                        ? SizedBox(height: 40)
                        : SizedBox(height: size.height * 0.15),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(213, 213, 213, 1),
                      ),
                      child: const Text("$appTitle"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _fetchData(BuildContext context, bool isLogged,
      [bool mounted = true]) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: !isLogged
                            ? Colors.red
                            : Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Cargando...',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black, fontSize: 18))
                    ],
                  ),
                ),
              ),
            );
          });
        });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (isLogged == true) {
      Navigator.pushNamed(context, "home");
    } else {
      Navigator.of(context).pop();
    }
  }

  void _handleButton() async {
    final token = Provider.of<AuthProvider>(context, listen: false);
    final isValidForm = _formKey.currentState!.validate();
    if (isValidForm) {
      final medicService = Provider.of<MedicAuthServic>(context, listen: false);
      final nurseService =
          Provider.of<NurseAuthService>(context, listen: false);
      final userService = Provider.of<UsersAuthService>(context, listen: false);
      var email = emailController.text.trim();
      var password = passwordController.text.trim();
      var id = await userService.getAuthenticateUserId(email, password);
      var idMedic = await medicService.getAuthenticateId(email, password);
      var idNurse = await nurseService.getAuthenticateId(email, password);
      var type = await userService.getAuthenticateIdRole(email, password);
      if (id != null && type == "ROLE_MEDIC") {
        _prefs.idUsers = id;
        _prefs.idMedic = idMedic!;
      }
      if (id != null && type == "ROLE_NURSE") {
        _prefs.idUsers = id;
        _prefs.idNurse = idNurse!;
      }
      if (email == "" || password == "") {
        return;
      }
      /*if (id == -1) {
              print("Error de conexion");
              return;
            }*/
      _isPressed = true;

      if (id == null) {
        _fetchData(context, false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              "Usuario o contraseña incorrectas",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        print("No existe en la base de datos");
        setState(() {
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _isPressed = false;
            });
          });
        });
      } else {
        _fetchData(context, true);
        _prefs.email = email;
        _prefs.password = password;
        _prefs.login = true;
        //Obtener el token
        await token.updateToken(context);
        setState(() {
          Future.delayed(const Duration(seconds: 6), () {
            setState(() {
              _isPressed = false;
            });
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              type == "ROLE_MEDIC"
                  ? "Médico logueado correctamente"
                  : "Enfermero logueado correctamente",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        );
        if (type == "ROLE_MEDIC") {
          print("Médico existe en la base de datos");
        } else {
          print("Enfermero existe en la base de datos");
        }
      }
      if (!mounted) {
        return;
      }
    }
  }

  Widget signInButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          onPressed: _isPressed == false ? _handleButton : null,
          child: Container(
            width: size.width * 1,
            padding: const EdgeInsets.all(6),
            child: Text("Ingresar",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          )),
    );
  }
}
