import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

const colorAccentTextFormField = Color.fromRGBO(121, 116, 126, 1);
const chartColorBackground = Color.fromRGBO(224, 224, 224, 1);
const backgroundColor2 = Color.fromRGBO(109, 153, 237, 1);

const primaryColorApp = Color.fromRGBO(14, 26, 48, 1);
const headerColorApp = Color.fromRGBO(40, 39, 53, 1);
const labelTextFormColor = Color.fromRGBO(73, 69, 79, 1);
const primaryColorTextColor = Color.fromRGBO(133, 133, 133, 1);
const primaryBackGroundColor = Color.fromRGBO(14, 26, 48, 0.65);

const secondaryColorApp = Color.fromRGBO(255, 161, 158, 1);
const secondaryAppbarBackground = Color.fromRGBO(255, 225, 224, 1);
const secondaryAppbarText = Color.fromRGBO(242, 144, 141, 1);
const secondaryBackgroundColorApp = Color.fromRGBO(255, 242, 241, 1);

const buttonForegroundColor = Color.fromRGBO(255, 255, 255, 1);

const registerBackgroundColor = Color.fromRGBO(99, 128, 226, 10);
const textColor = Color.fromRGBO(0, 0, 0, 1);
ThemeData textThemes = ThemeData(
  colorScheme: const ColorScheme.light(
    //primaryColorApp
    tertiary: primaryColorApp,
    onSurface: labelTextFormColor,
    //primaryColorTextColor
    onSecondary: primaryColorTextColor,
    //primaryBackGroundColor
    outline: primaryBackGroundColor,
    onBackground: headerColorApp,
    //secondaryColorApp
    onSecondaryContainer: secondaryColorApp,
    inversePrimary: secondaryAppbarText,
    inverseSurface: secondaryAppbarBackground,
    //secondaryBackgroundColorApp
    surface: secondaryBackgroundColorApp,
    //chartBackgroundColor
    background: chartColorBackground,

    primary: textColor,
    secondary: colorAccentTextFormField,

    error: Colors.red,

    onPrimary: Color.fromRGBO(29, 27, 32, 1),

    onTertiary: buttonForegroundColor,
  ),
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
      backgroundColor: primaryColorApp,
      foregroundColor: buttonForegroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: chartColorBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black, weight: 800),
    toolbarHeight: 80,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.transparent,
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
    iconColor: MaterialStatePropertyAll(colorAccentTextFormField),
  )),
  textTheme: GoogleFonts.robotoTextTheme(
    ThemeData(
        textTheme: const TextTheme(
      //buttonText
      labelLarge: TextStyle(
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
      ),
      //login.dart TexTButton
      displaySmall: TextStyle(
          color: primaryColorApp,
          fontSize: 16,
          decoration: TextDecoration.underline),
      //text parragraph
      bodyMedium: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      //title text
      titleSmall: TextStyle(color: Colors.white, fontSize: 40),
      //drawer text
      bodyLarge: TextStyle(color: Colors.white, fontSize: 30),
      bodySmall: TextStyle(color: Colors.white, fontSize: 16),
    )).textTheme,
  ),
);
