import 'package:flutter/material.dart';
import 'package:ulcernosis/pages/sign_in/login.dart';
import '../pages/diagnosis/diagnosis.dart';
import '../pages/home/home.dart';
import '../pages/home/tab_bar_filter.dart';
import '../pages/management/add_nurse.dart';
import '../pages/management/manage.dart';
import '../pages/profile/edit_profile.dart';
import '../pages/profile/profile.dart';
import '../pages/profile/register_patient.dart';
import '../pages/sign_in/pre_register.dart';
import '../pages/sign_in/register_medic.dart';
import '../pages/sign_in/register_nurse.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (BuildContext context) => const LoginScreen(),
  'preRegister': (BuildContext context) => const PreRegisterScreen(),
  'register': (BuildContext context) => const RegisterScreen(),
  'registerNurse': (BuildContext context) => const RegisterNurseScreen(),

  'home': (BuildContext context) => const HomeScreen(),
  'tabBarFilter': (BuildContext context) => const TabBarFilter(),
  'profile': (BuildContext context) => const ProfileScreen(),
  'manage': (BuildContext context) => const ManageScreen(),
  'diagnosis': (BuildContext context) => const DiagnosisScreen(),
  'editProfile': (BuildContext context) => const EditProfileScreen(),
  'registerPatient': (BuildContext context) => const RegisterPatientScreen(),
  'addNurse': (BuildContext context) => const AddNursePage(),
};
