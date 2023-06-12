//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../pages/diagnosis/take_photo.dart';

class MyFutureBuilderDiagnosis extends StatefulWidget {
  final Future<List> myFuture;
  const MyFutureBuilderDiagnosis({super.key, required this.myFuture});

  @override
  State<MyFutureBuilderDiagnosis> createState() =>
      _MyFutureBuilderDiagnosisState();
}

class _MyFutureBuilderDiagnosisState extends State<MyFutureBuilderDiagnosis> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: widget.myFuture,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data ?? [];
        return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: Colors.transparent));
              }
              return GestureDetector(
                onTap: () {
                  int idPaciente = data[index].id;
                  print("El id del usuario es : ${data[index].id}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakePhotoDiagnosis(
                                idPatient: idPaciente,
                              )));
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
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              ExactAssetImage("assets/images/patient-logo.png"),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data[index].fullName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Paciente',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${data[index].address}',
                              overflow: TextOverflow.ellipsis,
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
