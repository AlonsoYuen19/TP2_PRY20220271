import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/diagnosis_service.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/helpers/Searchable/searchable_medic.dart';
import '../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../utils/helpers/Searchable/searchable_widget.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builder_cards/future_builders.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final diagnosisService = DiagnosisService();
  final userAuth = UsersAuthService();
  final nurseService = NurseAuthService();
  final medicService = MedicAuthServic();
  Diagnosis diagnosis = Diagnosis();
  Users user = Users();
  Nurse nurse = Nurse();
  Medic medic = Medic();
  List<Diagnosis> listDiagnosis = [];
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future init() async {
    user = (await userAuth.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      listDiagnosis =
          (await diagnosisService.getDiagnosisByMedicCMP(medic.cmp));
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      listDiagnosis =
          (await diagnosisService.getDiagnosisByNurseCEP(nurse.cep));
    }
    setState(() {
      print("El usuario es: ${user.fullName}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: ((context) => const CustomDialogWidget()));
          return false;
        },
        child: FutureBuilder(
          future: delayPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderScreen();
            }
            return AppBarDrawer(
                isHome: true, title: "Últimos Diagnósticos", child: homePage());
          },
        ));
  }

  Widget homePage() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Últimos Diagnósticos",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                listDiagnosis.isNotEmpty
                    ? Flexible(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'tabBarFilter');
                            },
                            child: Text("Filtrar por etapas",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ))),
                      )
                    : Container()
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          listDiagnosis.isEmpty
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.25,
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
                            height: 20,
                          ),
                          const Text(
                              "No se encontraron registros de diagnósticos disponibles",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(213, 213, 213, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400))
                        ],
                      ),
                    );
                  })
              : Column(
                  children: [
                    SearchableTitle(
                      onChanged: () async {
                        await showSearch(
                            context: context,
                            delegate: user.role == "ROLE_MEDIC"
                                ? SearchUser(
                                    isHome: true,
                                    cmp: medic.cmp,
                                    isEtapa: false)
                                : SearchNurse(
                                    isHome: true,
                                    cep: nurse.cep,
                                    isEtapa: false));
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    user.role == "ROLE_MEDIC"
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: MyFutureBuilder(
                              myFuture: diagnosisService
                                  .getDiagnosisByMedicCMP(medic.cmp),
                              isHome: true,
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: MyFutureBuilder(
                              myFuture: diagnosisService
                                  .getDiagnosisByNurseCEP(nurse.cep),
                              isHome: true,
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
        ]));
  }
}
