// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/services/users_service.dart';
import '../../models/nurse.dart';
import '../../models/users.dart';
import '../../pages/diagnosis/diagnosis_nurse_selection_patient.dart';
import '../../services/nurse_services.dart';
import '../widgets/alert_dialog.dart';
import 'constant_variables.dart';


// ignore: must_be_immutable
class AppBarDrawer extends StatefulWidget {
  final Widget child;
  bool? isHome;
  bool? isDiagnosis;
  bool? isDiagnosisNurse;
  bool? isManagement;
  bool? isProfile;
  String? title;
  Color? color;
  AppBarDrawer({
    Key? key,
    required this.child,
    this.isHome = false,
    this.isDiagnosis = false,
    this.isDiagnosisNurse = false,
    this.isManagement = false,
    this.isProfile = false,
    this.title = "",
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  State<AppBarDrawer> createState() => _AppBarDrawerState();
}

class _AppBarDrawerState extends State<AppBarDrawer> {
  Users users = Users();
  Nurse nurse = Nurse();
  Uint8List avatar = Uint8List(0);
  Uint8List avatar2 = Uint8List(0);
  final _advancedDrawerController = AdvancedDrawerController();
  Future init() async {
    final usersService = Provider.of<UsersAuthService>(context, listen: false);
    final nurseService = Provider.of<NurseAuthService>(context, listen: false);
    users = (await usersService.getUsersById())!;

    if (prefs.idMedic != 0) {
      avatar = (await usersService.getMedicImageFromBackend());
    }
    if (prefs.idNurse != 0) {
      avatar2 = (await usersService.getNurseImageFromBackend());
      nurse = (await nurseService.getNurseById(context))!;
    }

    print(prefs.login);
    setState(() {
      print("El usuario con info es el siguiente :${users.fullName}");
      print("El usuario con id es el siguiente :" + prefs.idUsers.toString());
    });
  }

  @override
  void initState() {
    init();
    print("id del enfermero en el SP: " + prefs.idNurse.toString());
    print("id del médico en el SP: " + prefs.idMedic.toString());
    super.initState();
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  void _handleMenuButtonPressed() {
    if (_advancedDrawerController.value.visible == false) {
      _advancedDrawerController.showDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: AdvancedDrawer(
          backdropColor: Theme.of(context).colorScheme.surface,
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          openScale: 1,
          rtlOpening: false,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: SafeArea(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 34),
                      avatar.isEmpty && avatar2.isEmpty
                          ? Container(
                              height: size.width * 0.28,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(prefs.idMedic == 0
                                        ? "assets/images/enfermero_logo1.png"
                                        : "assets/images/medico_logo1.png"),
                                    fit: BoxFit.fitHeight),
                                color: Color(0xF1F1F1),
                                shape: BoxShape.circle,
                              ),
                            )
                          : ClipOval(
                              child: Image.memory(
                                  prefs.idMedic != 0 ? avatar : avatar2,
                                  height: size.width * 0.28,
                                  width: size.width * 0.28,
                                  fit: BoxFit.cover),
                            ),
                      const SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 29),
                        child: Text(
                          users.fullName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: widget.isHome == false
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (widget.isHome == false) {
                          //token.updateToken(context);
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'home', (route) => false);
                        }
                        return;
                      },
                      leading: SvgPicture.asset(
                        "assets/svgImages/home.svg",
                        height: 20,
                        color: widget.isHome == false
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                      title: Text('Menú principal',
                          style: widget.isHome == false
                              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  )
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  )),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: widget.isDiagnosis == false &&
                              widget.isDiagnosisNurse == false
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (widget.isDiagnosis == false &&
                            users.role == "ROLE_MEDIC") {
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'diagnosis', (route) => false);
                        } else if (widget.isDiagnosisNurse == false &&
                            users.role == "ROLE_NURSE") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DiagnosisNurseSelectionScreen()),
                              (route) => false);
                        }
                        return;
                      },
                      leading: SvgPicture.asset(
                        "assets/svgImages/diagnostico.svg",
                        height: 24,
                        color: widget.isDiagnosis == false &&
                                widget.isDiagnosisNurse == false
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                      title: Text('Diagnóstico',
                          style: widget.isDiagnosis == false &&
                                  widget.isDiagnosisNurse == false
                              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  )
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  )),
                    ),
                  ),
                  users.role == "ROLE_MEDIC"
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: widget.isManagement == false
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.inverseSurface,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                              bottom: Radius.circular(8),
                            ),
                          ),
                          child: ListTile(
                              onTap: () {
                                if (widget.isManagement == false) {
                                  //token.updateToken(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, 'manage', (route) => false);
                                }
                                return;
                              },
                              leading: SvgPicture.asset(
                                "assets/svgImages/gestion.svg",
                                height: 24,
                                color: widget.isManagement == false
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                              ),
                              title: Text('Gestión',
                                  style: widget.isManagement == false
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 16,
                                          )
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ))),
                        )
                      : const SizedBox(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: widget.isProfile == false
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: ListTile(
                        onTap: () {
                          if (widget.isProfile == false) {
                            //token.updateToken(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'profile', (route) => false);
                          }
                          return;
                        },
                        leading: SvgPicture.asset(
                          "assets/svgImages/perfil.svg",
                          height: 20,
                          color: widget.isProfile == false
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.inversePrimary,
                        ),
                        title: Text('Perfil',
                            style: widget.isProfile == false
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )
                                : Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ))),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        final exit = await showDialog(
                            context: context,
                            builder: ((context) => const CustomDialogWidget()));
                        return exit;
                      },
                      leading: SvgPicture.asset(
                          "assets/svgImages/cerrarSesion.svg",
                          height: 24,
                          color: Theme.of(context).colorScheme.tertiary),
                      title: Text('Cerrar Sesión',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.tertiary,
                              )),
                    ),
                  ),
                  const Spacer(),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(255, 217, 221, 1),
                    ),
                    child: Container(
                      child: const Text("$appTitle"),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 16, bottom: 16),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer), // <-- Button color
                    elevation: MaterialStateProperty.all(0), // <-- Splash color
                  ),
                  onPressed: _handleMenuButtonPressed,
                  child: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(value.visible ? Icons.clear : Icons.menu,
                            //key: ValueKey<bool>(value.visible),
                            color: Theme.of(context).colorScheme.onTertiary,
                            size: 18),
                      );
                    },
                  ),
                ),
              ),
              //titleSpacing: 25,
              leadingWidth: 96,
              centerTitle: true,
              toolbarHeight: 98,
              backgroundColor: widget.color,
              automaticallyImplyLeading: false,
              title: Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            body: widget.child,
          )),
    );
  }
}
