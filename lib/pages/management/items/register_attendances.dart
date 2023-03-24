import 'package:flutter/material.dart';

class RegisterAttendancePage extends StatefulWidget {
  const RegisterAttendancePage({super.key});

  @override
  State<RegisterAttendancePage> createState() => _RegisterAttendancePageState();
}

class _RegisterAttendancePageState extends State<RegisterAttendancePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.05),
            child: Column(children: [
              Row(
                children: [
                  InkWell(
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () => Navigator.pop(context)),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  const Flexible(
                    child: Text(
                      "Registro de Asistencias",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.15,
              ),
              Column(
                children: [
                  Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: Colors.transparent),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/out-of-stock.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("No hay Registros de Asistencias Disponibles",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 30,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ]),
          ),
        ))
      ]),
    );
  }
}
