import 'package:flutter/material.dart';
import 'package:parking_cars/Screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFF07111F),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            details.exceptionAsString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF07111F);
    const card = Color(0xFF101B33);
    const accent = Color(0xFF7C8CF8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Parking System',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,

        // 🔥 تحسين الألوان العامة
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ).copyWith(
          primary: accent,
          secondary: accent,
          surface: card,
        ),

        // 🔥 تحسين شكل الـ AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // 🔥 تحسين TextFields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0D1628),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF24304A)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF24304A)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),

          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),

          prefixIconColor: Colors.white70,
        ),

        // 🔥 تحسين الأزرار
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 🔥 تحسين TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accent,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 🔥 تحسين Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),

      // 🔥 بداية التطبيق
      home: const LoginScreen(),
    );
  }
}