import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/routes/routes.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/services/team_work_service.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/shared/user_prefs.dart';
import 'package:ulcernosis/theme/theme.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = SaveData();
  await prefs.initPrefs();
  prefs.deleteToken();
  prefs.deleteIdMedic();
  prefs.deleteIdNurse();
  prefs.deleteIdUsers();
  prefs.deleteIdPatient();
  prefs.deleteImage();
  prefs.deleteIdPatient();
  prefs.deleteLogin();
  prefs.deleteImageDiag();
  prefs.deleteImageQuickDiag();
  prefs.deleteImageQuickDiagFile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => MedicAuthServic()),
        ChangeNotifierProvider(create: (BuildContext contex) => AuthProvider()),
        ChangeNotifierProvider(
            create: (BuildContext contex) => NurseAuthService()),
        ChangeNotifierProvider(
            create: (BuildContext contex) => UsersAuthService()),
        ChangeNotifierProvider(
            create: (BuildContext contex) => TeamWorkService()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        /*supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],*/
        debugShowCheckedModeBanner: false,
        theme: textThemes,
        initialRoute: 'login',
        routes: appRoutes,
      ),
    );
  }
}
