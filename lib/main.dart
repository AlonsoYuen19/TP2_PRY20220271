import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/routes/routes.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/user_auth_service.dart';
import 'package:ulcernosis/shared/user_prefs.dart';
import 'package:ulcernosis/theme/theme.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SaveData();
  await prefs.initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => UserServiceAuth()),
        ChangeNotifierProvider(create: (BuildContext contex) => AuthProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => NurseAuthService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: textThemes,
        initialRoute: 'login',
        routes: appRoutes,
      ),
    );
  }
}
