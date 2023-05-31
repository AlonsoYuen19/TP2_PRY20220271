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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  return const Center(child: SizedBox());
                }
                return Container(
                  width: size.width * 0.85,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Card(
                    semanticContainer: true,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              InkWell(
                                child: Icon(Icons.delete_forever,
                                    color: Colors.red, size: 28),
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
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${data[index].status}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: data[index].status == 'PENDIENTE'
                                            ? const Color.fromRGBO(
                                                245, 212, 36, 1)
                                            : Colors.green),
                              ),
                              const SizedBox(width: 20),
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
