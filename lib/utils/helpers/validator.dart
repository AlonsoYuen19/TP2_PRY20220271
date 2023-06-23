import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart'
    show FormFieldValidator, TextEditingController;

//import 'package:shared_preferences/shared_preferences.dart';

class Validator {
  static FormFieldValidator<String> nameValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[a-z A-ZáéíóúÁÉÍÓÚüÜ]+$').hasMatch(value)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> lastNameValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> ageValid(
      String errorMessage, TextEditingController min) {
    return (value) {
      if (value!.isEmpty || !RegExp(r'^[1-9][0-9]?$').hasMatch(value)) {
        return errorMessage;
      } else if (int.parse(min.text) < 25) {
        return "El encargado debe tener al menos 25 años";
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> ageValidPatient(
      String errorMessage, TextEditingController min) {
    return (value) {
      if (value!.isEmpty || !RegExp(r'^[1-9][0-9]?$').hasMatch(value)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> phoneValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[0-9]+$').hasMatch(value) ||
          value.length != 9) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> cmpValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[0-9]{6}$').hasMatch(value) ||
          value.length != 6 ||
          !value.startsWith("0")) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> cepValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[0-9]{6}$').hasMatch(value) ||
          value.length != 6) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> emailValid(String errorMessage) {
    return (value) =>
        value != null && EmailValidator.validate(value) ? null : errorMessage;
  }

  static FormFieldValidator<String> dniValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[0-9]+$').hasMatch(value) ||
          value.length != 8) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }
  //no contener espacios regexp

  static FormFieldValidator<String> passwordValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty) {
        return errorMessage;
      } else if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,20}$')
          .hasMatch(value)) {
        return errorMessage;
      } else if (RegExp(r"\s\b|\b\s").hasMatch(value)) {
        return "La contraseña no puede contener espacios en blanco";
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> passwordValidLogin(String errorMessage) {
    return (value) {
      if (value!.isEmpty) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> addressValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[a-zA-Z0-9., ñáéíóúÁÉÍÓÚüÜ-]+$').hasMatch(value)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> civilStateValid(String errorMessage) {
    return (value) {
      if (value!.isEmpty) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }
}
