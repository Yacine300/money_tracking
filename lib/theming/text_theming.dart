import 'package:flutter/material.dart';

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
