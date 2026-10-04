import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'features/splash/splash_screen.dart';

const Color disstPurple = Color(0xFF6C3BFF);
const Color disstBlue = Color(0xFF2D9CFF);
const Color disstBlack = Color(0xFF121212);
const Color disstWhite = Color(0xFFFFFFFF);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DisstApp());
}

class DisstApp extends StatelessWidget {
  const DisstApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: disstPurple,
      brightness: Brightness.light,
    ).copyWith(
      primary: disstPurple,
      onPrimary: disstWhite,
      secondary: disstBlue,
      onSecondary: disstWhite,
      surface: disstWhite,
      onSurface: disstBlack,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DisstApp',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,

        scaffoldBackgroundColor: disstWhite,

        appBarTheme: const AppBarTheme(
          backgroundColor: disstWhite,
          foregroundColor: disstBlack,
          elevation: 0,
          centerTitle: false,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: disstBlack,
          ),
          bodyMedium: TextStyle(
            color: disstBlack,
          ),
          titleLarge: TextStyle(
            color: disstBlack,
            fontWeight: FontWeight.bold,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: disstWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
            borderSide: BorderSide(
              color: Color(0xFFE3E1F5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
            borderSide: BorderSide(
              color: Color(0xFFE3E1F5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
            borderSide: BorderSide(
              color: disstPurple,
              width: 1.5,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: disstPurple,
            foregroundColor: disstWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: disstPurple,
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: disstPurple,
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}