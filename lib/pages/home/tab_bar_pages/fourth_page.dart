import 'package:flutter/material.dart';
import '../../../models/diagnosis.dart';
import '../../../models/medic.dart';
import '../../../models/nurse.dart';
import '../../../models/users.dart';
import '../../../services/diagnosis_service.dart';
import '../../../services/medic_service.dart';
import '../../../services/nurse_services.dart';
import '../../../services/users_service.dart';
import '../../../utils/helpers/Searchable/searchable_medic.dart';
import '../../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../../utils/helpers/constant_variables.dart';
import '../../../utils/helpers/future_builder_cards/future_builders_filter.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final userService = UsersAuthService();
  final nurseService = NurseAuthService();
  List<Diagnosis> diagnosis = [];
  Medic medic = Medic();
  Users user = Users();
  Nurse nurse = Nurse();
  Future init() async {
    user = (await userService.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCMPByStage(medic.cmp, "4");
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCEPByStage(nurse.cep, "4");
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            diagnosis.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Realice la búsqueda de un paciente",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: IconButton(
                              onPressed: () async {
                                await showSearch(
                                    context: context,
                                    delegate: user.role == "ROLE_MEDIC"
                                        ? SearchUser(
                                            isHome: false,
                                            cmp: medic.cmp,
                                            isEtapa: true,
                                            stagePredicted: "4")
                                        : SearchNurse(
                                            isHome: false,
                                            cep: nurse.cep,
                                            isEtapa: true,
                                            stagePredicted: "4"));
                              },
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 17.49,
                              )),
                        )
                      ],
                    ),
                  ),
            const SizedBox(height: 16),
            diagnosis.isEmpty
                ? FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.transparent,
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.18,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                'assets/images/Group.png',
                                color: Colors.grey,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                                "No se encontraron registros de diagnósticos disponibles",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(213, 213, 213, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      );
                    })
                : user.role == "ROLE_MEDIC"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCMPByStage(
                              medic.cmp, "4"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCEPByStage(
                              nurse.cep, "4"),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
