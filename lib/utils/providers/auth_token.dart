
import 'package:flutter/material.dart';
import '../../services/user_auth_service.dart';
import '../helpers/constant_variables.dart';

class AuthProvider extends ChangeNotifier {
  //static const String _kTokenKey = 'token';
  String? _token;

  String get token => _token!;
  AuthProvider() {
    _token = "token";
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    UserServiceAuth loginService = UserServiceAuth();
    var token = await loginService.getBearerToken(prefs.email, prefs.password);
    token = prefs.token;
    _token = token;
    if (prefs.token.isEmpty) {
      print("No existe token");
    } else {
      print("Token obtenido con exito");
      print(_token);
    }
    notifyListeners();
  }

  Future<void> updateToken(BuildContext context) async {
    UserServiceAuth loginService = UserServiceAuth();
    var token = await loginService.getBearerToken(prefs.email, prefs.password);
    prefs.token = token!;
    print("Token actualizado con exito");
    print(token);
    notifyListeners();
  }

  //delete token
  Future<void> deleteToken(BuildContext context) async {
    prefs.deleteToken();
    print("Token eliminado con exito");
    notifyListeners();
  }
}
