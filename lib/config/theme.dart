import 'package:flutter/material.dart';

final ThemeData gramolaTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor:  Colors.cyan[600],
  //backgroundColor: Colors.black
);

class GramolaColors {

  const GramolaColors();

  static const Color appBarTitle = const Color(0xFFFFFFFF);
  static const Color appBarIconColor = const Color(0xFFFFFFFF);
  static const Color appBarDetailBackground = const Color(0x00FFFFFF);
  static const Color appBarGradientStart = const Color(0xFF3383FC);
  static const Color appBarGradientEnd = const Color(0xFF00C6FF);

  //static const Color eventCard = const Color(0xFF434273);
  static const Color eventCard = const Color(0xFF8685E5);
  //static const Color eventListBackground = const Color(0xFF3E3963);
  static const Color eventPageBackground = const Color(0xFF736AB7);
  static const Color eventTitle = const Color(0xFFFFFFFF);
  static const Color eventLocation = const Color(0x66FFFFFF);
  static const Color eventDate = const Color(0x66FFFFFF);

}

class Dimens {
  const Dimens();

  static const eventWidth = 100.0;
  static const eventHeight = 100.0;
}

class TextStyles {

  const TextStyles();

  static const TextStyle appBarTitle = const TextStyle(
    color: GramolaColors.appBarTitle,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 36.0
  );

  static const TextStyle eventTitle = const TextStyle(
    color: GramolaColors.eventTitle,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24.0
  );

  static const TextStyle eventLocation = const TextStyle(
    color: GramolaColors.eventLocation,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: 14.0
  );

  static const TextStyle eventDate = const TextStyle(
    color: GramolaColors.eventDate,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: 12.0
  );
}