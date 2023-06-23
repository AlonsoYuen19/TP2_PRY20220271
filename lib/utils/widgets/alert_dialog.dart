import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';
import 'package:ulcernosis/utils/widgets/loader_dialog.dart';
import '../../shared/user_prefs.dart';

class ReturnAlert {
  /*static Future<bool?> showWarning(BuildContext context) async =>
      showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("¿Estas seguro que deseas cerrar la sesión?"),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancelar")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        final token =
                            Provider.of<AuthProvider>(context, listen: false);
                        final prefs = SaveData();
                        prefs.login = false;

                        if (!context.mounted) {
                          return;
                        }
                        await token.deleteToken(context);

                        Navigator.pushNamedAndRemoveUntil(
                            context, 'login', (_) => false);
                      },
                      child: const Text("Confirmar")),
                ],
              ));*/
  static Future<bool?> showWarningHome(BuildContext context) async =>
      showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("¿Estas seguro que deseas cerrar la sesión?"),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancelar")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        final token =
                            Provider.of<AuthProvider>(context, listen: false);
                        final prefs = SaveData();
                        prefs.login = false;

                        if (!context.mounted) {
                          return;
                        }
                        await token.deleteToken(context);

                        Navigator.pushNamedAndRemoveUntil(
                            context, 'login', (_) => false);
                      },
                      child: const Text("Confirmar")),
                ],
              ));
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/alert-icon.png",
                height: 50,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "¿Estas seguro que deseas cerrar la sesión?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 56,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                        onPressed: () async {
                          final dialog = WaitDialog(context);
                          dialog.show();
                          final token =
                              Provider.of<AuthProvider>(context, listen: false);
                          final prefs = SaveData();
                          final tokencito = UsersAuthService();
                          prefs.login = false;
                          if (!context.mounted) {
                            return;
                          }
                          var response = await tokencito.logOutToken();
                          await token.deleteToken(context);
                          prefs.deleteIdUsers();
                          prefs.deleteIdMedic();
                          prefs.deleteIdNurse();
                          prefs.deleteIdPatient();
                          prefs.deleteImage();
                          prefs.deleteEmail();
                          prefs.deletePassword();
                          prefs.deleteLogin();
                          prefs.deleteImageDiag();
                          prefs.deleteImageQuickDiag();
                          prefs.deleteImageQuickDiagFile();
                          if (response == false) {
                            dialog.dispose();
                            return mostrarAlertaError(context,
                                "El servidor se encuentra en mantenimiento, espero unos momentos...",
                                () {
                              exit(0);
                            });
                          }
                          dialog.dispose();
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'login', (_) => false);
                        },
                        child: const Text("Confirmar",
                            style: TextStyle(fontSize: 16))),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 56,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                width: 1),
                            backgroundColor: Color.fromRGBO(255, 232, 230, 1)),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancelar",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer))),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ]),
    );
  }
}

const _secundary = Color.fromRGBO(34, 70, 95, 1);
mostrarAlertaError(BuildContext context, String subtitulo, Function function,
    {bool faltaDatos = false}) {
  final size = MediaQuery.of(context).size;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Wrap(
          children: [
            AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: Image.asset(
                "assets/images/alert-icon.png",
                height: 50,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              content: Column(
                children: [
                  Text(subtitulo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: function as void Function()?,
                    child: Container(
                      width: size.width * 1,
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer)),
                      child: const Center(
                        child: Text('Aceptar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

mostrarAlertaExito(BuildContext context, String subtitulo, Function function) {
  final size = MediaQuery.of(context).size;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Wrap(
          children: [
            AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: Image.asset(
                "assets/images/alert-icon.png",
                height: 50,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              content: Column(
                children: [
                  Text(subtitulo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: function as void Function()?,
                    child: Container(
                      width: size.width * 1,
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer)),
                      child: const Center(
                        child: Text('Aceptar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

mostrarAlertaRegistro(BuildContext context, String subtitulo, Function function,
    {Color? color}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Image.asset(
              "assets/images/alert-icon.png",
              height: 50,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      onPressed: function as void Function()?,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Aceptar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              width: 1)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

mostrarAlertaRegistroAsignacion(
    BuildContext context, String subtitulo, Function function,
    {Color? color}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Image.asset(
              "assets/images/alert-icon.png",
              height: 50,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      onPressed: function as void Function()?,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Aceptar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              width: 1)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

mostrarAlertaVolverDiagnosticos(
    BuildContext context, String subtitulo, Function function,
    {Color? color}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Image.asset(
              "assets/images/alert-icon.png",
              height: 50,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      onPressed: function as void Function()?,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Aceptar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              width: 1)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
