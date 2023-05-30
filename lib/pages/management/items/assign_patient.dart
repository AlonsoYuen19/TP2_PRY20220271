import 'package:flutter/material.dart';

import '../../../services/patient_service.dart';
import '../../../utils/helpers/future_builder_cards/future_builder_patients_available.dart';

class AssignPatientPage extends StatefulWidget {
  final int idNurse;
  const AssignPatientPage({super.key, required this.idNurse});

  @override
  State<AssignPatientPage> createState() => _AssignPatientPageState();
}

class _AssignPatientPageState extends State<AssignPatientPage> {
  List listPatients = [];
  final patientService = PatientService();
  Future init() async {
    listPatients = await patientService.getPatientsNotassigned();
    setState(() {
      print("El tamaño de la lista es: ${listPatients.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.05),
            child: Column(children: [
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  ElevatedButton(
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16.0,
                      )),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer), // <-- Button color
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.08,
                  ),
                  Flexible(
                    child: Text(
                      "Seleccionar al Paciente",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 21,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              listPatients.isEmpty
                  ? FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 2)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.transparent,
                          ));
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.15,
                            ),
                            Container(
                              height: 280,
                              width: 280,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/out-of-stock.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "No hay Registros de Pacientes Disponibles",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))
                          ],
                        );
                      })
                  : MyFutureBuilderPatientsByNurse(
                      myFuture: patientService.getPatientsNotassigned(),
                      idNurse: widget.idNurse,
                    ),
            ]),
          ),
        ))
      ]),
    );
  }
}
