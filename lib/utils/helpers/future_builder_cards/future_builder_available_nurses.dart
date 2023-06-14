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
    return FutureBuilder<List>(
      future: widget.myFuture,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data ?? [];
        return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                    color: Colors.transparent,
                  ),
                ));
              }
              return InkWell(
                onTap: () async {
                  final teamWorkService = TeamWorkService();
                  String fullName = data[index].fullName.toString();
                  int spaceIndex = fullName.indexOf(" ");
                  String? name;
                  if (spaceIndex != -1) {
                    name = fullName.substring(0, spaceIndex);
                  } else {
                    name = fullName;
                  }
                  await mostrarAlertaRegistro(context,
                      "Desea registrar al enfermero $name a tu equipo médico",
                      () {
                    int idNurse = data[index].id;
                    teamWorkService.createTeamWork(context, idNurse);
                  }, color: Theme.of(context).colorScheme.onSecondary);
                },
                child: Card(
                  semanticContainer: true,
                  borderOnForeground: true,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: ExactAssetImage(
                              "assets/images/enfermero_logo1.png"),
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
                            const SizedBox(height: 6),
                            Text(
                              data[index].isAuxiliar == false
                                  ? "Enfermero"
                                  : "Enfermero Auxiliar",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${data[index].address}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
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
