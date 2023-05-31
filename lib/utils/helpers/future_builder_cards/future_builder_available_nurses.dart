//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../services/team_work_service.dart';
import '../../widgets/alert_dialog.dart';


class MyFutureBuilderAvailableNurses extends StatefulWidget {
  final Future<List> myFuture;
  const MyFutureBuilderAvailableNurses({super.key, required this.myFuture});

  @override
  State<MyFutureBuilderAvailableNurses> createState() =>
      _MyFutureBuilderAvailableNursesState();
}

class _MyFutureBuilderAvailableNursesState
    extends State<MyFutureBuilderAvailableNurses> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Future.delayed(const Duration(seconds: 1));
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
                    final teamWorkService = TeamWorkService();
                    String name = data[index].fullName.toString().substring(
                        0, data[index].fullName.toString().indexOf(" "));
                    await mostrarAlertaRegistro(context,
                        "Desea registrar al enfermero $name a tu equipo médico",
                        () {
                      int idNurse = data[index].id;
                      teamWorkService.createTeamWork(context, idNurse);
                    }, color: Theme.of(context).colorScheme.onSecondary);
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
                            vertical: 12.0, horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/patient-logo.png"),
                            ),
                            SizedBox(width: size.width * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.02),
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
                                  "Enfermero",
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
                                const SizedBox(height: 5),
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
