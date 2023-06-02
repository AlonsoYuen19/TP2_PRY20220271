// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          backgroundFigure(context, height: 0.3),
          const StarsView(
            fps: 60,
            starsConfig: StarsConfig(
              starCount: 30,
              minStarSize: 2,
              maxStarSize: 5,
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: size.height * 0.15,
                          width: size.width * 0.5,
                          padding: const EdgeInsets.only(bottom: 50),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/hospital-bed.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: size.width * 0.4,
                            child: AnimatedTextKit(
                                repeatForever: true,
                                displayFullTextOnTap: false,
                                animatedTexts: [
                                  ScaleAnimatedText(
                                    texts[0],
                                    textAlign: TextAlign.center,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  ScaleAnimatedText(
                                    texts[1],
                                    textAlign: TextAlign.center,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  ScaleAnimatedText(
                                    texts[2],
                                    textAlign: TextAlign.center,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  ScaleAnimatedText(
                                    texts[3],
                                    textAlign: TextAlign.center,
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.15),
                    //CARD
                    SizedBox(
                      width: size.width * 0.9,
                      child: Card(
                        semanticContainer: true,
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 20,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.03),
                            Center(
                                child: SvgPicture.asset(
                              'assets/images/Ulsernosis.svg',
                              fit: BoxFit.cover,
                              height: 55,
                            )),
                            SizedBox(height: size.height * 0.035),
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
                            ),
                            SizedBox(height: size.height * 0.03),
                            GetTextFormField(
                              labelText: "Contraseña",
                              placeholder: password,
                              controllerr: passwordController,
                              icon: const Icon(Icons.lock),
                              keyboardType: TextInputType.visiblePassword,
                              validator:
                                  validPasswordLogin("Rellene la contraseña"),
                              obscureText: true,
                              isRegisterPassword: false,
                            ),
                            SizedBox(height: size.height * 0.02),
                            signInButton(context),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No tienes una cuenta?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "preRegister");
                                    },
                                    child: Text("Registrate",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline)))
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: !isLogged ? Colors.red : Colors.green,
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
      //await token.updateToken(context);

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
      setState(() {
        _isPressed = true;
        Future.delayed(const Duration(seconds: 6), () {
          setState(() {
            _isPressed = false;
          });
        });
      });
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
          _isPressed = false;
        });
      } else {
        _fetchData(context, true);
        _prefs.email = email;
        _prefs.password = password;
        _prefs.login = true;
        //Obtener el token
        await token.updateToken(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              type == "ROLE_MEDIC"
                  ? "Médico logueado correctamente"
                  : "Enfermero logueado correctamente",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
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
    return ElevatedButton(
        onPressed: _isPressed == false ? _handleButton : null,
        child: Container(
          width: size.width * 0.71,
          padding: const EdgeInsets.all(5.0),
          child: Text("Iniciar sesión",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.white)),
        ));
  }
}
