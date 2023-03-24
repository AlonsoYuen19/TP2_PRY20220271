import 'package:flutter/material.dart';
import 'package:ulcernosis/services/nurse_services.dart';

import '../../../models/nurse.dart';
import '../../../services/patient_service.dart';
import '../../../utils/helpers/future_builder_cards/future_builder_list_patients_manage_by_nurse_id.dart';

class ListPatientsPage extends StatefulWidget {
  final int idNurse;
  const ListPatientsPage({super.key, required this.idNurse});

  @override
  State<ListPatientsPage> createState() => _ListPatientsPageState();
}

class _ListPatientsPageState extends State<ListPatientsPage> {
  List listPatients = [];
  Nurse nurse = Nurse();
  final patientService = PatientService();
  final nurseService = NurseAuthService();
  Future init() async {
    listPatients =
        await patientService.getPatientsByNurseManageArea(widget.idNurse);
    nurse = (await nurseService.getNurseByIdManage(widget.idNurse))!;
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
                  Flexible(
                    child: Text(
                      "Lista de Pacientes Asignados al enfermero ${nurse.fullName}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                  : MyFutureBuilderListPatientsByNurseId(
                      myFuture: patientService
                          .getPatientsByNurseManageArea(widget.idNurse),
                      idNurse: widget.idNurse,
                    ),
            ]),
          ),
        ))
      ]),
    );
  }
}
