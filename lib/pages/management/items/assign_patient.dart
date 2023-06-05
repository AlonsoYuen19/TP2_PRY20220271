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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer), // <-- Button color
                elevation: MaterialStateProperty.all(0), // <-- Splash color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_outlined,
                  color: Theme.of(context).colorScheme.onTertiary, size: 18)),
        ),
        leadingWidth: 96,
        centerTitle: true,
        toolbarHeight: 98,
        automaticallyImplyLeading: false,
        title: Text(
          "Seleccionar al Paciente",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 16,
            ),
            listPatients.isEmpty
                ? FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: MyFutureBuilderPatientsByNurse(
                      myFuture: patientService.getPatientsNotassigned(),
                      idNurse: widget.idNurse,
                    ),
                  ),
          ]),
        ))
      ]),
    );
  }
}
