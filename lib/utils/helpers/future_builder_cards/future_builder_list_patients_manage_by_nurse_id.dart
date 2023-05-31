// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../constant_variables.dart';

class MyFutureBuilderListPatientsByNurseId extends StatefulWidget {
  final Future<List> myFuture;
  final int idNurse;
  const MyFutureBuilderListPatientsByNurseId(
      {super.key, required this.myFuture, required this.idNurse});

  @override
  State<MyFutureBuilderListPatientsByNurseId> createState() =>
      _MyFutureBuilderListPatientsByNurseIdState();
}

class _MyFutureBuilderListPatientsByNurseIdState
    extends State<MyFutureBuilderListPatientsByNurseId> {
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
              physics: const NeverScrollableScrollPhysics(),
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
                return Container(
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
                    color: Colors.white,
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 28),
                              const SizedBox(width: 10),
                              Text(
                                "Paciente",
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${data[index].address}',
                                style: Theme.of(context).textTheme.labelMedium,
                              )
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
