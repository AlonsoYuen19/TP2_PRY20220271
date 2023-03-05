// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/doctor.dart';

import '../../services/user_auth_service.dart';
import '../../shared/user_prefs.dart';
import '../../utils/providers/auth_token.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';

class TestA extends StatefulWidget {
  const TestA({super.key});

  @override
  State<TestA> createState() => _TestAState();
}

class _TestAState extends State<TestA> with SingleTickerProviderStateMixin {
  Doctor doctorUser = Doctor();

  final userAuth = UserServiceAuth();
  final prefs = SaveData();
  Future init() async {
    var userId = await userAuth.getAuthenticateId(prefs.email, prefs.password);
    doctorUser = (await userAuth.getDoctorById(userId.toString()))!;
    Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      print(prefs.email);
      print(
          "El usuario con info es el siguiente :${doctorUser.fullNameDoctor}");
      print("El usuario con id es el siguiente :" + userId!.toString());
    });
  }

  Future<String?> _getData(
      {bool hasError = false, bool hasData = true, String? data}) async {
    await Future.delayed(const Duration(seconds: 3));
    if (hasError) {
      return Future.error("An error occurred");
    }
    if (!hasData) {
      return Future.error("No existe información");
    }
    return data;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getData(data: doctorUser.fullNameDoctor),
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const LoaderHomeScreen();
          }
          var datos = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      var token = await userAuth.getBearerToken(
                          prefs.email, prefs.password);
                      prefs.token = token.toString();
                      if (!mounted) {
                        return;
                      }
                      Navigator.pushNamed(context, 'home');
                    },
                    child: Text(
                      datos.toString(),
                      style: const TextStyle(color: Colors.black),
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}
