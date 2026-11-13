import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/menu_item.dart';
import 'pages/about_page.dart';
import 'pages/address_page.dart';
import 'pages/cart_page.dart';
import 'pages/food_detail_page.dart';
import 'pages/help_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/splash_page.dart';
import 'routes.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const FoodieApp());
}

/// Root widget. MaterialApp's three main properties: title, theme and
/// home (here: initialRoute + routes for named navigation).
class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Express',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: AppRoutes.splash,
      // Pages that don't need any arguments
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.signup: (_) => const SignupPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.cart: (_) => const CartPage(),
        AppRoutes.address: (_) => const AddressPage(),
        AppRoutes.about: (_) => const AboutPage(),
        AppRoutes.help: (_) => const HelpPage(),
      },
      // Pages that need arguments are built here
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.details) {
          final item = settings.arguments as FoodItem;
          return MaterialPageRoute(
            builder: (_) => FoodDetailPage(item: item),
            settings: settings,
          );
        }
        return null;
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
      // External package: Poppins from google_fonts applied app-wide
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.dark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDEDED)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDEDED)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
