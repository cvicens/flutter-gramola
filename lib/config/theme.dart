import 'package:flutter/material.dart';

final ThemeData gramolaTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.purple[700],
  accentColor:  Colors.purple[300],
  buttonColor: Colors.purple[300],
);

class GramolaColors {

  const GramolaColors();

  static const Color appBarTitle = const Color(0xFFFFFFFF);
  static const Color appBarIconColor = const Color(0xFFFFFFFF);
  static const Color appBarDetailBackground = const Color(0x00FFFFFF);
  static const Color appBarGradientStart = const Color(0xFF3383FC);
  static const Color appBarGradientEnd = const Color(0xFF00C6FF);

  static const Color eventCard = const Color(0xFF8685E5);
  static const Color eventPageBackground = const Color(0xFF736AB7);
  static const Color eventTitle = const Color(0xFFFFFFFF);
  static const Color eventArtist = const Color(0xFFFFFFFF);
  static const Color eventLocation = const Color(0xFFFFFFFF);
  static const Color eventDate = const Color(0xFFFFFFFF);

}

class Dimens {
  const Dimens();

  static const eventWidth = 100.0;
  static const eventHeight = 100.0;
}

class TextStyles {

  const TextStyles();

  static const TextStyle eventTitle = const TextStyle(
    color: GramolaColors.eventTitle,
    fontFamily: 'Cataclysme',
    fontWeight: FontWeight.w600,
    fontSize: 32.0
  );

  static const TextStyle eventArtist = const TextStyle(
    color: GramolaColors.eventArtist,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.bold,
    fontSize: 28.0
  );

  static const TextStyle eventLocation = const TextStyle(
    color: GramolaColors.eventLocation,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.normal,
    fontSize: 18.0
  );

  static const TextStyle eventDate = const TextStyle(
    color: GramolaColors.eventDate,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.normal,
    fontSize: 18.0
  );

}

