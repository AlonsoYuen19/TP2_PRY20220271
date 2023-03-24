import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';
import '../../shared/user_prefs.dart';

class ReturnAlert {
  static Future<bool?> showWarning(BuildContext context) async =>
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
                        prefs.login = true;

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
                        prefs.login = true;

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
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 2),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/alert-icon.png",
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  "¿Estas seguro que deseas cerrar la sesión?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 0, 255, 1)),
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            final token = Provider.of<AuthProvider>(context,
                                listen: false);
                            final prefs = SaveData();
                            final tokencito = UsersAuthService();
                            prefs.login = true;
                            if (!context.mounted) {
                              return;
                            }
                            await tokencito.logOutToken();
                            await token.deleteToken(context);
                            prefs.deleteIdUsers();
                            prefs.deleteIdMedic();
                            prefs.deleteIdNurse();
                            prefs.deleteIdPatient();
                            prefs.deleteImage();
                            prefs.deleteEmail();
                            prefs.deletePassword();
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (_) => false);
                          },
                          child: const Text("Confirmar")),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 18,
            height: 60,
            width: 60,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.transparent)),
              child: Image.asset("assets/images/equis.png"),
            ),
          ),
        ]),
      ),
    );
  }
}

const _secundary = Color.fromRGBO(34, 70, 95, 1);
mostrarAlertaError(BuildContext context, String subtitulo, Function function) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.priority_high_rounded,
                    color: Colors.white, size: 60),
              ),
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _secundary, fontSize: 20)),
                const SizedBox(height: 15.0),
                TextButton(
                  onPressed: function as void Function()?,
                  child: Container(
                    width: 150.0,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: _secundary)),
                    child: const Center(
                      child:
                          Text('Aceptar', style: TextStyle(color: _secundary)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

mostrarAlertaExito(BuildContext context, String subtitulo, Function function) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, color: Colors.white, size: 70),
              ),
            ),
            content: Column(
              children: [
                const SizedBox(height: 10),
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _secundary, fontSize: 26)),
                const SizedBox(height: 15.0),
                TextButton(
                  onPressed: function as void Function()?,
                  child: Container(
                    width: 150.0,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: _secundary)),
                    child: const Center(
                      child:
                          Text('Aceptar', style: TextStyle(color: _secundary)),
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
  );
}

mostrarAlertaRegistro(
    BuildContext context, String subtitulo, Function function,{Color? color}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Icon(Icons.info, color: color, size: 120),
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _secundary, fontSize: 26)),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: function as void Function()?,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Aceptar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
mostrarAlertaRegistroAsignacion(
    BuildContext context, String subtitulo, Function function,{Color? color}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Icon(Icons.info, color: color, size: 120),
            ),
            content: Column(
              children: [
                Text(subtitulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _secundary, fontSize: 26)),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancelar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: function as void Function()?,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Aceptar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
