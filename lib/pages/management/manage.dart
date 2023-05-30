import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/helpers/loaders_screens/loader_manage_screen.dart';

import '../../services/team_work_service.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builder_cards/future_builder_nurses_by_medic_tw.dart';
import '../../utils/widgets/alert_dialog.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Users users = Users();
  List listNurses = [];
  Future init() async {
    final teamWorkService = TeamWorkService();
    final userServices = UsersAuthService();
    users = (await userServices.getUsersById())!;
    print("Rol del usuario: ${users.role}");
    if (users.role == "ROLE_MEDIC") {
      listNurses = await teamWorkService.getNursesByTeamWork();

      setState(() {
        print("El tamaño de la lista es: ${listNurses.length}");
      });
      if (listNurses.isEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          mostrarAlertaError(context,
              "Usted Actualmente, no\ntiene enfermeros. Por\nfavor, añada a enfermeros para que obtenga su equipo médico",
              () {
            Navigator.of(context).pop();
          });
        });
      } else {
        Future.delayed(const Duration(seconds: 2));
      }
    }
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
              return const LoaderManageScreen();
            }
            return AppBarDrawer(
                isManagement: true,
                title: "Gestión de Equipo Médico",
                child: users.role == "ROLE_MEDIC" ? managePage() : Container());
          },
        ));
  }

  Widget managePage() {
    final size = MediaQuery.of(context).size;
    final nurseAvailableService = TeamWorkService();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Lista de Enfermeros",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                listNurses.length < 3
                    ? Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        showDuration: Duration(seconds: 4),
                        message:
                            "Selecciona el icono para\nagregar enfermeros\na tu equipo médico",
                        child: Icon(Icons.info_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            size: 36))
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          listNurses.isEmpty
              ? Container()
              : MyFutureBuilderNursesByMedicsTW(
                  myFuture: nurseAvailableService.getNursesByTeamWork(),
                ),
          SizedBox(
            height: size.height * 0.02,
          ),
          if (listNurses.length < 3) ...[
            cardNurseSelectorEmpty(),
          ] else ...[
            Container()
          ],
        ],
      ),
    );
  }

  Widget cardNurseSelectorEmpty() {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 10,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: Container(
            height: size.height * 0.1,
            width: size.width * 0.15,
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              image: const DecorationImage(
                image: AssetImage('assets/images/add-friend.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: InkWell(
              radius: 10,
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.pushNamed(context, 'addNurse');
              },
            ),
          ),
        ),
      ),
    );
  }
}
