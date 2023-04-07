import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

const colorAccent = Color.fromRGBO(244, 179, 9, 1);
const backgroundColor = Color.fromRGBO(5, 88, 75, 1);
const backgroundColor2 = Color.fromRGBO(109, 153, 237, 1);
const backgroundColor3 = Colors.blue;
const buttonForegroundColor = Color.fromRGBO(240, 240, 240, 1);
const placeholderTextColor = Color.fromRGBO(166, 166, 166, 1);
const registerBackgroundColor = Color.fromRGBO(99, 128, 226, 10);
const textColor = Color.fromRGBO(0, 0, 0, 1);
ThemeData textThemes = ThemeData(
  colorScheme: const ColorScheme.light(
      background: backgroundColor,
      onBackground: registerBackgroundColor,
      primary: textColor,
      secondary: colorAccent,
      tertiary: backgroundColor3,
      error: Colors.red,
      outline: backgroundColor2,
      onPrimary: Colors.black,
      onSecondary: placeholderTextColor,
      onTertiary: buttonForegroundColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      splashFactory: InkSplash.splashFactory,
      elevation: 10,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 5, vertical: paddingVert - 8),
      backgroundColor: backgroundColor3,
      foregroundColor: buttonForegroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black, weight: 800),
    toolbarHeight: 80,
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.lightBlue, width: 4),
    ),
    dayPeriodBorderSide: const BorderSide(color: Colors.lightBlue, width: 4),
    dayPeriodColor: Colors.blueGrey.shade600,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.lightBlue
            : Colors.white),
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.lightBlue, width: 4),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.lightBlue
            : Colors.blueGrey.shade600),
    hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.white),
    dialHandColor: Colors.white,
    dialBackgroundColor: Colors.blueGrey.shade600,
    hourMinuteTextStyle:
        const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    dayPeriodTextStyle:
        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    helpTextStyle: const TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.lightBlue),
    dialTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.lightBlue
            : Colors.white),
  ),
  iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
    animationDuration: Duration(seconds: 2),
    iconColor: MaterialStatePropertyAll(colorAccent),
  )),
  textTheme: GoogleFonts.aBeeZeeTextTheme(
    ThemeData(
        textTheme: const TextTheme(
      //buttonText
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
      //login.dart TexTButton
      displaySmall: TextStyle(
          color: backgroundColor3,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline),
      //text parragraph
      bodyMedium: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      //title text
      titleSmall: TextStyle(color: Colors.white, fontSize: 40),
      //drawer text
      bodyLarge: TextStyle(color: Colors.white, fontSize: 30),
      bodySmall: TextStyle(color: Colors.white, fontSize: 16),
    )).textTheme,
  ),
);
