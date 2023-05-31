//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../pages/management/team_work_nurse_profile.dart';
import '../../../services/team_work_service.dart';
import '../../widgets/alert_dialog.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/patient-logo.png"),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data[index].fullName}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Enfermero especializado",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${data[index].address}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.09),
                              child: InkWell(
                                child: Icon(Icons.delete_forever,
                                    color: Colors.red, size: 30),
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
                            ),
                          ],
                        ),
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
