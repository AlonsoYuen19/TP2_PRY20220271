import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static final SaveData _instance = SaveData._internal();
  factory SaveData() => _instance;
  SaveData._internal();

  SharedPreferences? _prefs;
  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs?.getString('token') ?? '';
  }

  set token(String value) {
    _prefs?.setString('token', value);
  }

  String get email {
    return _prefs!.getString('email') ?? '';
  }

  set email(String value) {
    _prefs!.setString('email', value);
  }

  String get password {
    return _prefs!.getString('password') ?? '';
  }

  set password(String value) {
    _prefs!.setString('password', value);
  }

  bool get login {
    return _prefs!.getBool('login') ?? false;
  }

  set login(bool value) {
    _prefs!.setBool('login', true);
  }

  int get idUsers {
    return _prefs!.getInt('idUsers') ?? 0;
  }

  set idUsers(int value) {
    _prefs!.setInt('idUsers', value);
  }

  int get idMedic {
    return _prefs!.getInt('idMedic') ?? 0;
  }

  set idMedic(int value) {
    _prefs!.setInt('idMedic', value);
  }

  int get idNurse {
    return _prefs!.getInt('idNurse') ?? 0;
  }

  set idNurse(int value) {
    _prefs!.setInt('idNurse', value);
  }

  int get idPatient {
    return _prefs!.getInt('idPatient') ?? 0;
  }

  set idPatient(int value) {
    _prefs!.setInt('idPatient', value);
  }

  //image
  String get image {
    return _prefs!.getString('image') ?? '';
  }

  set image(String value) {
    _prefs!.setString('image', value);
  }

  //delete token
  void deleteToken() {
    _prefs?.remove('token');
  }

  void deleteEmail() {
    _prefs?.remove('email');
  }

  void deletePassword() {
    _prefs?.remove('password');
  }

  void deleteLogin() {
    _prefs?.remove('login');
  }

  void deleteIdUsers() {
    _prefs?.remove('idUsers');
  }
  void deleteIdMedic() {
    _prefs?.remove('idMedic');
  }
  void deleteIdNurse() {
    _prefs?.remove('idNurse');
  }
}
