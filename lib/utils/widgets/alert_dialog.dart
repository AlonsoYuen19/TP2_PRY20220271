import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
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
                            prefs.login = true;

                            if (!context.mounted) {
                              return;
                            }
                            await token.deleteToken(context);

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
