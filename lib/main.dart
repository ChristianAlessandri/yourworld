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
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightTextOnPrimary,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightTextOnPrimary,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          error: AppColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightCard,
        dividerColor: AppColors.lightDivider,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
          bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkTextOnPrimary,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkTextOnPrimary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          error: AppColors.error,
          onError: Colors.black,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkCard,
        dividerColor: AppColors.darkDivider,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
          bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
