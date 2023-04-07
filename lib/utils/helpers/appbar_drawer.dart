// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/helpers/responsive/responsive.dart';
import '../../models/nurse.dart';
import '../../models/users.dart';
import '../../services/nurse_services.dart';
import '../widgets/alert_dialog.dart';
import 'constant_variables.dart';

// ignore: must_be_immutable
class AppBarDrawer extends StatefulWidget {
  final Widget child;
  bool? isHome;
  bool? isDiagnosis;
  bool? isManagement;
  bool? isProfile;

  AppBarDrawer({
    Key? key,
    required this.child,
    this.isHome = false,
    this.isDiagnosis = false,
    this.isManagement = false,
    this.isProfile = false,
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
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
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
    final isResp = Responsive.of(context).isShortSide(context);
    //final token = Provider.of<AuthProvider>(context, listen: false);
    return AdvancedDrawer(
        backdropColor: Theme.of(context).colorScheme.tertiary,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
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
                    const SizedBox(height: 10),
                    avatar.isEmpty && avatar2.isEmpty
                        ? Container(
                            height:
                                isResp ? size.width * 0.25 : size.width * 0.3,
                            margin: const EdgeInsets.only(
                              top: 24.0,
                              bottom: 16.0,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(prefs.idMedic == 0
                                      ? "assets/images/enfermero-logo.png"
                                      : "assets/images/doctor-logo.png"),
                                  fit: BoxFit.fitHeight),
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                                prefs.idMedic != 0 ? avatar : avatar2,
                                height: isResp
                                    ? size.width * 0.25
                                    : size.width * 0.3,
                                width: isResp
                                    ? size.width * 0.25
                                    : size.width * 0.3,
                                fit: BoxFit.cover),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      users.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: isResp ? 22 : 28),
                    )
                  ],
                ),
                SizedBox(
                  height: isResp
                      ? 20
                      : users.role == "ROLE_NURSE"
                          ? 60
                          : 60,
                ),
                const Divider(
                  color: Colors.white30,
                  height: 5,
                ),
                Container(
                  width: 280,
                  padding: isResp
                      ? const EdgeInsets.all(2)
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isHome == false
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onTertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.circular(16),
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
                    leading: Icon(
                      Icons.home,
                      color: widget.isHome == false
                          ? Theme.of(context).colorScheme.onTertiary
                          : Theme.of(context).colorScheme.tertiary,
                      size: isResp ? 30 : 40,
                    ),
                    title: Text('Home',
                        style: widget.isHome == false
                            ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: isResp ? 22 : 30,
                                )
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: isResp ? 22 : 30,
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                  ),
                ),
                isResp
                    ? const SizedBox()
                    : const Divider(
                        color: Colors.white30,
                        height: 5,
                      ),
                Container(
                  width: 280,
                  padding: isResp
                      ? const EdgeInsets.all(2)
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isDiagnosis == false
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onTertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (widget.isDiagnosis == false) {
                        //token.updateToken(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'diagnosis', (route) => false);
                      }
                      return;
                    },
                    leading: Icon(
                      Icons.document_scanner,
                      color: widget.isDiagnosis == false
                          ? Theme.of(context).colorScheme.onTertiary
                          : Theme.of(context).colorScheme.tertiary,
                      size: isResp ? 30 : 40,
                    ),
                    title: Text('Diagnóstico',
                        style: widget.isDiagnosis == false
                            ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: isResp ? 22 : 30,
                                )
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: isResp ? 22 : 30,
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                  ),
                ),
                isResp
                    ? const SizedBox()
                    : const Divider(
                        color: Colors.white30,
                        height: 5,
                      ),
                users.role == "ROLE_MEDIC"
                    ? Container(
                        width: 280,
                        padding: isResp
                            ? const EdgeInsets.all(2)
                            : const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.isManagement == false
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.onTertiary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                            bottom: Radius.circular(16),
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
                            leading: Icon(
                              Icons.manage_accounts,
                              color: widget.isManagement == false
                                  ? Theme.of(context).colorScheme.onTertiary
                                  : Theme.of(context).colorScheme.tertiary,
                              size: isResp ? 30 : 40,
                            ),
                            title: Text('Gestión',
                                style: widget.isManagement == false
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: isResp ? 22 : 30,
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: isResp ? 22 : 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ))),
                      )
                    : const SizedBox(),
                isResp
                    ? const SizedBox()
                    : const Divider(
                        color: Colors.white30,
                        height: 5,
                      ),
                Container(
                  width: 280,
                  padding: isResp
                      ? const EdgeInsets.all(2)
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isProfile == false
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onTertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.circular(16),
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
                      leading: Icon(
                        Icons.person_2,
                        color: widget.isProfile == false
                            ? Theme.of(context).colorScheme.onTertiary
                            : Theme.of(context).colorScheme.tertiary,
                        size: isResp ? 30 : 40,
                      ),
                      title: Text('Perfil',
                          style: widget.isProfile == false
                              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: isResp ? 22 : 30,
                                  )
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: isResp ? 22 : 30,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ))),
                ),
                const Divider(
                  color: Colors.white30,
                  height: 5,
                ),
                isResp
                    ? const SizedBox()
                    : users.role == "ROLE_NURSE"
                        ? const Spacer()
                        : const SizedBox(height: 20),
                ListTile(
                  onTap: () async {
                    final exit = await showDialog(
                        context: context,
                        builder: ((context) => const CustomDialogWidget()));
                    return exit;
                  },
                  leading: Icon(
                    Icons.account_circle_rounded,
                    size: isResp ? 30 : 40,
                  ),
                  title: Text('Cerrar Sesión',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: isResp ? 22 : 30,
                          )),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: isResp ? 8 : 16.0,
                    ),
                    child: const Text("@$appTitle"),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  )),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context)
                      .colorScheme
                      .tertiary), // <-- Button color
                ),
                onPressed: _handleMenuButtonPressed,
                child: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        //key: ValueKey<bool>(value.visible),
                        color: Theme.of(context).colorScheme.onTertiary,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            titleSpacing: 45,
            leadingWidth: 75,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(
              appTitle,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          body: widget.child,
        ));
  }
}
