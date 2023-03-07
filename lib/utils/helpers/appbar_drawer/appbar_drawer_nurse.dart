import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:ulcernosis/models/nurse.dart';

import '../../../models/medic.dart';
import '../../../services/nurse_services.dart';
import '../../../services/medic_service.dart';
import '../../widgets/alert_dialog.dart';
import '../constant_variables.dart';

// ignore: must_be_immutable
class AppBarDrawerNurse extends StatefulWidget {
  final Widget child;
  bool? isHome;
  bool? isDiagnosis;
  bool? isManagement;
  bool? isProfile;
  bool? isNurse;

  AppBarDrawerNurse(
      {Key? key,
      required this.child,
      this.isHome = false,
      this.isDiagnosis = false,
      this.isManagement = false,
      this.isProfile = false})
      : super(key: key);

  @override
  State<AppBarDrawerNurse> createState() => _AppBarDrawerNurseState();
}

class _AppBarDrawerNurseState extends State<AppBarDrawerNurse> {
  Medic doctorUser = Medic();
  Nurse nurseUser = Nurse();
  final userAuth = MedicAuthServic();
  final nurseService = NurseAuthService();
  final _advancedDrawerController = AdvancedDrawerController();
  Future initNurse() async {
    var userId = await userAuth.getAuthenticateId(prefs.email, prefs.password);
    nurseUser = (await nurseService.getNurseById(userId.toString()))!;
    setState(() {
      print("El usuario con info es el siguiente :${nurseUser.fullName}");
      print("El usuario con id es el siguiente :" + userId!.toString());
    });
  }

  @override
  void initState() {
    initNurse();
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
                    Container(
                      height: size.width * 0.3,
                      margin: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 16.0,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/doctor-logo.png'),
                            fit: BoxFit.fitHeight),
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      nurseUser.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 28),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                const Divider(
                  color: Colors.white54,
                ),
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(8),
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
                      size: 40,
                    ),
                    title: Text('Home',
                        style: widget.isHome == false
                            ? Theme.of(context).textTheme.bodyLarge
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                  ),
                ),
                const Divider(
                  color: Colors.white54,
                ),
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(8),
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
                      size: 40,
                    ),
                    title: Text('Diagnóstico',
                        style: widget.isDiagnosis == false
                            ? Theme.of(context).textTheme.bodyLarge
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(8),
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
                        size: 40,
                      ),
                      title: Text('Gestión',
                          style: widget.isManagement == false
                              ? Theme.of(context).textTheme.bodyLarge
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ))),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(8),
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
                        size: 40,
                      ),
                      title: Text('Perfil',
                          style: widget.isProfile == false
                              ? Theme.of(context).textTheme.bodyLarge
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ))),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.white54,
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () async {
                    final exit = await showDialog(
                        context: context,
                        builder: ((context) => const CustomDialogWidget()));
                    return exit;
                  },
                  leading: const Icon(
                    Icons.account_circle_rounded,
                    size: 40,
                  ),
                  title: Text('Cerrar Sesión',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
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
              child: Shimmer(
                duration: const Duration(seconds: 1),
                interval: const Duration(seconds: 1),
                color: Colors.white,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.symmetric(
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
