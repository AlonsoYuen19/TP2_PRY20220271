//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ulcernosis/services/appointment_service.dart';
import '../../../pages/management/team_work_nurse_profile.dart';
import '../../widgets/alert_dialog.dart';

class MyFutureBuilderAppointmentByNurse extends StatefulWidget {
  final Future<List> myFuture;
  final int idNurse;
  const MyFutureBuilderAppointmentByNurse(
      {super.key, required this.myFuture, required this.idNurse});

  @override
  State<MyFutureBuilderAppointmentByNurse> createState() =>
      _MyFutureBuilderAppointmentByNurseState();
}

class _MyFutureBuilderAppointmentByNurseState
    extends State<MyFutureBuilderAppointmentByNurse> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox());
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
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 20,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.house,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 28),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${data[index].address}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              InkWell(
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.delete_forever,
                                      color: Colors.red, size: 28),
                                ),
                                onTap: () async {
                                  final appointmentService =
                                      AppointmentService();
                                  await mostrarAlertaRegistro(
                                      context, "¿Desea eliminar la cita?", () {
                                    int idNurse = data[index].id;
                                    appointmentService
                                        .deleteAppointByNurseId(idNurse);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamWorkNurseProfile(
                                                    id: widget.idNurse)));
                                  }, color: Colors.red);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Fecha: ${data[index].dateAsigDiag}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text(
                                  '${data[index].status}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontSize: 15,
                                          color:
                                              data[index].status == 'PENDIENTE'
                                                  ? const Color.fromRGBO(
                                                      245, 212, 36, 1)
                                                  : Colors.green),
                                ),
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
