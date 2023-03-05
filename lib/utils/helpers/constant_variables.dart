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
const validAddress = Validator.addressValid;
const validPhone = Validator.phoneValid;

const validNameEditDoctor = ValidatorEditDoctor.nameValidEdit;
const validDniEditDoctor = ValidatorEditDoctor.dniValidEdit;
const validAgeEditDoctor = ValidatorEditDoctor.ageValidEdit;
const validAddressEditDoctor = ValidatorEditDoctor.addressValidEdit;
const validPhoneEditDoctor = ValidatorEditDoctor.phoneValidEdit;
final prefs = SaveData();
const baseURLNurse = "http://10.0.2.2:8080/api/v2/nurses/";
const baseURLDoctor = "http://10.0.2.2:8080/api/v1/doctors/";
const authURL = "http://10.0.2.2:8080/api/v1/auth/";


const camaraFunction = GaleryOptions.selectImageFromCamera;
const galleryFunction = GaleryOptions.selectImageFromGallery;

