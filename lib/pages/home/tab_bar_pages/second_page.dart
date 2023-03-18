import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/medic.dart';

import '../../../services/medic_service.dart';
import '../../../utils/helpers/future_builders.dart';
import '../../../utils/helpers/Searchable/searchable.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final userAuth = MedicAuthServic();
  /*Future<List<Medic>> getStrings() async {
    await Future.delayed(const Duration(seconds: 1));
    return userAuth.getDoctorsByStateCivil("Casado");
  }*/

  int? count;
  /*Future init() async {
    final list = await getStrings();
    final count = list.length;
    print("La cantidad de diagnósticos de categoría 2 es: $count");
  }

  @override
  void initState() {
    init();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<MedicAuthServic>(context, listen: false);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Text(
                    "Seleccione el icono de búsqueda\npara filtrar por nombres del\npaciente",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        )),
                      ),
                      onPressed: () async {
                        await showSearch(
                          context: context,
                          delegate: SearchUser(isHome: false, state: "Casado"),
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: 30,
                      )),
                )
              ],
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 580,
              child: MyFutureBuilder(
                myFuture: doctorProvider.getDoctorsByStateCivil("Casado"),
                isHome: false,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
