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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${data[index].fullName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 20),
                              ),
                              GestureDetector(
                                onTap: () {
                                  int idPaciente = data[index].id;
                                  print(
                                      "El id del usuario es : ${data[index].id}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TakePhotoDiagnosis(
                                                  idPatient: idPaciente,
                                              )));
                                },
                                child: Icon(Icons.send_sharp,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 30),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.supervised_user_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 28),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Paciente',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    '${data[index].address}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
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
