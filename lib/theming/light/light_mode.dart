import 'package:flutter/material.dart';

ThemeData _buildLightTheme() {
  const ColorScheme colorScheme = ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,
    // Customize other colors here...
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    textTheme: _buildTextTheme(colorScheme),
    scaffoldBackgroundColor: colorScheme.primary,
    iconTheme: _buildIconTheme(colorScheme),
  );
}

IconThemeData _buildIconTheme(ColorScheme colorScheme) {
  return IconThemeData(color: colorScheme.secondary, size: 30);
}

TextTheme _buildTextTheme(ColorScheme colorScheme) {
  return TextTheme(
    headlineMedium: TextStyle(
      color: colorScheme.secondary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),

    headlineSmall: TextStyle(
      color: colorScheme.secondary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: colorScheme.secondary,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    // Customize other text styles here...
  );
}
