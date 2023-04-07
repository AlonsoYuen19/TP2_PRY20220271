//class future builder

// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/patient_service.dart';

import '../../../models/nurse.dart';
import '../../../pages/management/items/assign_appointment.dart';
import '../../../pages/management/team_work_nurse_profile.dart';
import '../../../services/team_work_service.dart';
import '../../widgets/alert_dialog.dart';
import '../constant_variables.dart';

class MyFutureBuilderPatientsByNurse extends StatefulWidget {
  final Future<List> myFuture;
  final int idNurse;
  const MyFutureBuilderPatientsByNurse(
      {super.key, required this.myFuture, required this.idNurse});

  @override
  State<MyFutureBuilderPatientsByNurse> createState() =>
      _MyFutureBuilderPatientsByNurseState();
}

class _MyFutureBuilderPatientsByNurseState
    extends State<MyFutureBuilderPatientsByNurse> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ));
                }
                return Container(
                  width: size.width * 0.9,
                  padding: const EdgeInsets.only(bottom: 5),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
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
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  '${data[index].fullName}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 20),
                                ),
                              ),
                              InkWell(
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.send,
                                      color: Colors.lightBlue, size: 28),
                                ),
                                onTap: () async {
                                  final patienService = PatientService();
                                  final nurseService = TeamWorkService();
                                  Nurse? nurse = await nurseService
                                      .getNurseByIdTW(widget.idNurse);
                                  int idPatient = data[index].id;
                                  String nameNurse = nurse!.fullName;
                                  List<String> nameNurseList =
                                      nameNurse.split(" ");
                                  nameNurse = nameNurseList[0];
                                  String name = data[index].fullName;
                                  List<String> namePatient = name.split(" ");
                                  name = namePatient[0];
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return AssignItineraryPage(
                                      idNurse: widget.idNurse,
                                      idPatient: idPatient,
                                    );
                                  }));
                                  /*await mostrarAlertaRegistroAsignacion(context,
                                      "¿Deseas seleccionar al paciente $name para ser atendido por el $nameNurse?",
                                      () {
                                    patienService.createAssignment(
                                        idPatient, widget.idNurse);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return AssignItineraryPage(
                                        idNurse: widget.idNurse,
                                        idPatient: idPatient,
                                      );
                                    }));
                                  }, color: Colors.yellow);*/
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 28),
                              const SizedBox(width: 10),
                              Text(
                                "Paciente",
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${data[index].address}',
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
