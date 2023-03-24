//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../pages/management/team_work_nurse_profile.dart';
import '../../../services/team_work_service.dart';
import '../../widgets/alert_dialog.dart';
import '../constant_variables.dart';

class MyFutureBuilderNursesByMedicsTW extends StatefulWidget {
  final Future<List> myFuture;
  const MyFutureBuilderNursesByMedicsTW({super.key, required this.myFuture});

  @override
  State<MyFutureBuilderNursesByMedicsTW> createState() =>
      _MyFutureBuilderNursesByMedicsTWState();
}

class _MyFutureBuilderNursesByMedicsTWState
    extends State<MyFutureBuilderNursesByMedicsTW> {
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
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ));
                }
                return InkWell(
                  onTap: () async {
                    int idNurse = data[index].id;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TeamWorkNurseProfile(
                                  id: idNurse,
                                )));
                  },
                  child: Container(
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
                      color: colorCard,
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: paddingHori),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  "Enfermero",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: paddingHori),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${data[index].address}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    )
                                  ],
                                ),
                                InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Icon(Icons.delete_forever,
                                        color: Colors.red, size: 28),
                                  ),
                                  onTap: () async {
                                    final teamWorkService = TeamWorkService();
                                    String name = data[index]
                                        .fullName
                                        .toString()
                                        .substring(
                                            0,
                                            data[index]
                                                .fullName
                                                .toString()
                                                .indexOf(" "));
                                    await mostrarAlertaRegistro(context,
                                        "Desea eliminar al enfermero $name de tu equipo médico",
                                        () {
                                      int idNurse = data[index].id;
                                      teamWorkService
                                          .deleteNurseOfTheTeamWork(idNurse);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, 'manage', (route) => false);
                                    }, color: Colors.red);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
