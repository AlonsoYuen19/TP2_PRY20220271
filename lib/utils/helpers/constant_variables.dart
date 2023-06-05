import 'package:flutter/material.dart';
import 'package:ulcernosis/utils/helpers/validator.dart';
import 'package:ulcernosis/utils/helpers/validator_update.dart';
import '../../shared/user_prefs.dart';
import 'gallery_options.dart';

const String appTitle = "UlcerNosis";
const String appDescription = "Brindar, ayudar y diagnosticar en ese orden";
//paddding
const double paddingHori = 30.0;
const double paddingVert = 20.0;
const double paddingListViewHori = 15.0;
const double paddingListViewVerti = 10.0;

const validName = Validator.nameValid;
const validEmail = Validator.emailValid;
const validPassword = Validator.passwordValid;
const validPasswordLogin = Validator.passwordValidLogin;
const validStateCivil = Validator.civilStateValid;
const validDni = Validator.dniValid;
const validAge = Validator.ageValid;
const validAgePatient = Validator.ageValidPatient;
const validAddress = Validator.addressValid;
const validPhone = Validator.phoneValid;
const validCmp = Validator.cmpValid;
const validCep = Validator.cepValid;

const validNameEditDoctor = ValidatorEditDoctor.nameValidEdit;
const validDniEditDoctor = ValidatorEditDoctor.dniValidEdit;
const validAgeEditDoctor = ValidatorEditDoctor.ageValidEdit;
const validAddressEditDoctor = ValidatorEditDoctor.addressValidEdit;
const validPhoneEditDoctor = ValidatorEditDoctor.phoneValidEdit;
final prefs = SaveData();
const authURL = "http://10.0.2.2:8080/api/v1/";
//const authURL = "http://192.168.1.26:8080/api/v1/";
//const authURL = "http://192.168.189.137:8080/api/v1/";
//const authURL = "http://192.168.18.46:8080/api/v1/";
const camaraFunction = GaleryOptions.selectImageFromCamera;
const galleryFunction = GaleryOptions.selectImageFromGallery;
const colorCard = Color.fromRGBO(207, 234, 254, 1);





Map meses = {
  "01": "Enero",
  "02": "Febrero",
  "03": "Marzo",
  "04": "Abril",
  "05": "Mayo",
  "06": "Junio",
  "07": "Julio",
  "08": "Agosto",
  "09": "Septiembre",
  "10": "Octubre",
  "11": "Noviembre",
  "12": "Diciembre"
};
