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
                  child: CircularProgressIndicator(color: Colors.transparent),
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
                child: Card(
                  semanticContainer: true,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1,
                    ),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16, bottom: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: ExactAssetImage(
                              "assets/images/enfermero_logo1.png"),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data[index].fullName}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                                            .outline,
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
                                            .outline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
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
                              teamWorkService.deleteNurseOfTheTeamWork(idNurse);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'manage', (route) => false);
                            }, color: Colors.red);
                          },
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
