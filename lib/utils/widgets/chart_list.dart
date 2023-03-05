import 'package:flutter/material.dart';

import '../../models/doctor.dart';
import '../helpers/constant_variables.dart';

class CharListS extends StatefulWidget {
  final List<Doctor> listDoctors;
  const CharListS({Key? key, required this.listDoctors}) : super(key: key);

  @override
  State<CharListS> createState() => _CharListSState();
}

class _CharListSState extends State<CharListS> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //card view
    return Column(
      children: [
        if (widget.listDoctors.isNotEmpty) ...[
          for (int i = 0; i < widget.listDoctors.length; i++)
            Container(
              width: size.width * 0.9,
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Card(
                semanticContainer: true,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 20,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: paddingHori),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.listDoctors[i].fullNameDoctor,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ImageIcon(
                              const AssetImage("assets/images/search-icon.png"),
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 28,
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
                          ImageIcon(
                            const AssetImage("assets/images/category-icon.png"),
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 36,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Categoria 1",
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
                          ImageIcon(
                            const AssetImage("assets/images/address-icon.png"),
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.listDoctors[i].address,
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
        ] else ...[
          FutureBuilder(
              future: _getData(doctorList: widget.listDoctors),
              builder: (buildContext, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                      strokeWidth: 10,
                    ),
                  );
                }
                return Center(
                    child: Text(
                  "No hay datos para mostrar",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.red),
                ));
              }),
        ]
      ],
    );
  }

  Future<List<Doctor>?> _getData(
      {bool hasError = false,
      bool hasData = true,
      List<Doctor>? doctorList}) async {
    await Future.delayed(const Duration(seconds: 5));
    if (hasError) {
      return Future.error("An error occurred");
    }
    if (!hasData) {
      return Future.error("No existe información");
    }
    return doctorList;
  }
}
