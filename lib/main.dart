import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppHive.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightTextOnPrimary,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightTextOnPrimary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightDivider,
      textTheme: _textThemeBuilder(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightTextOnPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightTextOnPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkTextOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkTextOnPrimary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      textTheme: _textThemeBuilder(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkTextOnPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkTextOnPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  TextTheme _textThemeBuilder(Brightness brightness) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextSecondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextOnPrimary,
      ),
    );
  }
}
