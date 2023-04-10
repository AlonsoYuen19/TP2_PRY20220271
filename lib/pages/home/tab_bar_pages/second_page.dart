import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/services/diagnosis_service.dart';

import '../../../models/nurse.dart';
import '../../../models/users.dart';
import '../../../services/medic_service.dart';
import '../../../services/nurse_services.dart';
import '../../../services/users_service.dart';
import '../../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../../utils/helpers/constant_variables.dart';
import '../../../utils/helpers/future_builder_cards/future_builders.dart';
import '../../../utils/helpers/Searchable/searchable_medic.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final userService = UsersAuthService();
  final nurseService = NurseAuthService();
  Medic medic = Medic();
  Users user = Users();
  Nurse nurse = Nurse();
/*  Future<List<Diagnosis>> getStrings() async {
    await Future.delayed(const Duration(seconds: 1));
    medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
    return diagnosisService.getDiagnosisByMedicCMP(medic.cmp, state: "2");
  }

  Future<List<Diagnosis>> getStrings2() async {
    await Future.delayed(const Duration(seconds: 1));
    nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
    return diagnosisService.getDiagnosisByNurseCEP(nurse.cep, state: "2");
  }*/

  int? count;
  Future init() async {
    if (user.role == "ROLE_MEDIC") {
      user = (await userService.getUsersById())!;
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      /*final list = await getStrings();
      final count = list.length;
      print("La cantidad de diagnósticos de categoría 2 es: $count");*/
    } else {
      user = (await userService.getUsersById())!;
      /*final list2 = await getStrings2();
      final count2 = list2.length;
      print("La cantidad de diagnósticos de categoría 2 es: $count2");*/
    }

    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            delegate: user.role == "ROLE_MEDIC"
                                ? SearchUser(
                                    isHome: false,
                                    cmp: medic.cmp,
                                    isEtapa: true)
                                : SearchNurse(
                                    isHome: false,
                                    cep: nurse.cep,
                                    isEtapa: true));
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
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: user.role == "ROLE_MEDIC"
                ? MyFutureBuilder(
                    myFuture: diagnosisService.getDiagnosisByMedicCMP(medic.cmp,
                        query2: "2"),
                    isHome: false,
                  )
                : MyFutureBuilder(
                    myFuture: diagnosisService.getDiagnosisByNurseCEP(nurse.cep,
                        query2: "2"),
                    isHome: false,
                  ),
          ),
        ],
      ),
    );
  }
}
