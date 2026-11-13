import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

/// Very simple local sign-up / login using SharedPreferences.
/// One account is stored on the device. (Firebase Auth replaces this in week 14.)
class AuthService {
  AuthService._();

  static const String _kName = 'user_name';
  static const String _kEmail = 'user_email';
  static const String _kPassword = 'user_password';
  static const String _kLoggedIn = 'logged_in';

  /// Returns null on success, or an error message.
  static Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existingEmail = prefs.getString(_kEmail);
    if (existingEmail != null &&
        existingEmail.toLowerCase() == email.toLowerCase()) {
      return 'An account with this email already exists. Please log in.';
    }
    await prefs.setString(_kName, name.trim());
    await prefs.setString(_kEmail, email.trim());
    await prefs.setString(_kPassword, password);
    await prefs.setBool(_kLoggedIn, true);
    return null;
  }

  /// Returns null on success, or an error message.
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_kEmail);
    final savedPassword = prefs.getString(_kPassword);

    if (savedEmail == null) {
      return 'No account found on this device. Sign up first.';
    }
    if (savedEmail.toLowerCase() != email.trim().toLowerCase() ||
        savedPassword != password) {
      return 'Wrong email or password.';
    }
    await prefs.setBool(_kLoggedIn, true);
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  static Future<AppUser?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmail);
    if (email == null) return null;
    return AppUser(name: prefs.getString(_kName) ?? 'Guest', email: email);
  }

  /// Logs out but keeps the account so the user can log back in.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
  }
}
