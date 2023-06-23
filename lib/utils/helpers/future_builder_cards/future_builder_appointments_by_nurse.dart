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
                return const Center(child: CircularProgressIndicator(
                  color: Colors.transparent
                ));
              }
              return Card(
                semanticContainer: true,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1,
                    )),
                margin: EdgeInsets.zero,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16, bottom: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.house,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data[index].address}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.delete_forever,
                                color: Colors.red, size: 28),
                            onTap: () async {
                              final appointmentService = AppointmentService();
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Fecha: ${data[index].dateAsigDiag}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            '${data[index].status}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: data[index].status == 'PENDIENTE'
                                        ? const Color.fromRGBO(245, 212, 36, 1)
                                        : Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
