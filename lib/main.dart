import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracking/routing/routes.dart';
import 'package:money_tracking/screens/intro/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: IntroScreen.routeName,
        routes: routes,
      ),
    );
  }

  ThemeData _buildLightTheme() {
    const ColorScheme colorScheme = ColorScheme.light(
        primary: Colors.white,
        secondary: Colors.black,
        outline: Colors.grey,
        tertiary: Color.fromARGB(255, 15, 10, 222)
        // Customize other colors here...
        );

    return ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        fontFamily: 'IBM',
        textTheme: _buildTextTheme(colorScheme),
        scaffoldBackgroundColor: colorScheme.primary,
        iconTheme: _buildIconTheme(colorScheme),
        appBarTheme: _appBarTheme(colorScheme));
  }

  AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      color: colorScheme.primary, // Set background color for AppBar
      centerTitle: true, // Center the title
      iconTheme: IconThemeData(color: colorScheme.secondary), // Set icon color
    );
  }

  IconThemeData _buildIconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.secondary, size: 25);
  }

  ThemeData _buildDarkTheme() {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.white,
      outline: Colors.white38,
      tertiary: Color.fromARGB(255, 15, 10, 222),
      // Customize other colors here...
    );

    return ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        fontFamily: 'IBM',
        textTheme: _buildTextTheme(colorScheme),
        scaffoldBackgroundColor: colorScheme.primary,
        iconTheme: _buildIconTheme(colorScheme),
        appBarTheme: _appBarTheme(colorScheme));
  }

  TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      bodyLarge: TextStyle(
        color: colorScheme.secondary,
        fontSize: 32,
        height: 1,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: colorScheme.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.secondary,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),

      headlineSmall: TextStyle(
        color: colorScheme.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      headlineLarge: TextStyle(
        color: colorScheme.secondary,
        fontSize: 42,
        fontWeight: FontWeight.normal,
      ),
      // Customize other text styles here...
    );
  }
}
