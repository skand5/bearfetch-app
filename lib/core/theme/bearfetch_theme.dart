import 'package:flutter/material.dart';

abstract final class BearfetchColors {
  static const cream = Color(0xFFFDF6EC);
  static const surface = Color(0xFFFFF8F0);
  static const cocoa = Color(0xFF3D2314);
  static const brown = Color(0xFF5C3317);
  static const bodyBrown = Color(0xFF7A4F2E);
  static const orange = Color(0xFFE8762B);
  static const orangeDark = Color(0xFFC05E1A);
  static const honey = Color(0xFFF9C46B);
  static const outline = Color(0xFFC07040);
}

abstract final class BearfetchTheme {
  static const bodyTextStyle = TextStyle(
    color: BearfetchColors.bodyBrown,
    fontFamily: 'Nunito',
    fontSize: 15,
    height: 1.55,
  );

  static ThemeData materialTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: BearfetchColors.cream,
    colorScheme: const ColorScheme.light(
      primary: BearfetchColors.orange,
      onPrimary: Colors.white,
      surface: BearfetchColors.surface,
      onSurface: BearfetchColors.cocoa,
      secondary: BearfetchColors.honey,
      onSecondary: BearfetchColors.cocoa,
      error: Color(0xFFB3261E),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 30,
        height: 1.1,
        color: BearfetchColors.cocoa,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 26,
        height: 1.25,
        color: BearfetchColors.cocoa,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.2,
        color: BearfetchColors.cocoa,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 1.25,
        color: BearfetchColors.cocoa,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 1.3,
        color: BearfetchColors.cocoa,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 16,
        height: 1.5,
        color: BearfetchColors.bodyBrown,
      ),
      bodyMedium: bodyTextStyle,
      bodySmall: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 13,
        height: 1.4,
        color: BearfetchColors.bodyBrown,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
  );
}
