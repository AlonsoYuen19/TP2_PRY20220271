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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox());
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
                  child: Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.only(bottom: 5, top: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: Card(
                      semanticContainer: true,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/patient-logo.png"),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.height * 0.02),
                                  Text(
                                    '${data[index].fullName}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Paciente',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${data[index].address}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: size.height * 0.015),
                                ],
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
