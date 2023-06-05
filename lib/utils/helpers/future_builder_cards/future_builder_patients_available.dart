//class future builder

// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../models/nurse.dart';
import '../../../pages/management/items/assign_appointment.dart';
import '../../../services/team_work_service.dart';

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
    return FutureBuilder<List>(
      future: widget.myFuture,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data ?? [];
        return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
              return GestureDetector(
                onTap: () async {
                  final nurseService = TeamWorkService();
                  Nurse? nurse =
                      await nurseService.getNurseByIdTW(widget.idNurse);
                  int idPatient = data[index].id;
                  String nameNurse = nurse!.fullName;
                  List<String> nameNurseList = nameNurse.split(" ");
                  nameNurse = nameNurseList[0];
                  String name = data[index].fullName;
                  List<String> namePatient = name.split(" ");
                  name = namePatient[0];
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
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
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  semanticContainer: true,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1,
                    ),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              ExactAssetImage("assets/images/patient-logo.png"),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data[index].fullName}',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Paciente",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${data[index].address}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
