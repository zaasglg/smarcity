import 'package:shared_preferences/shared_preferences.dart';
import 'db_service.dart';

class AuthService {
  static User? currentUser;

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', user.email); // We're storing phone in the email field
    await prefs.setString('user_password', user.password);
    await prefs.setString('user_name', user.name);
    currentUser = user;
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('user_phone'); // Get phone number
    final password = prefs.getString('user_password');
    final name = prefs.getString('user_name') ?? 'Пользователь';
    if (phone != null && password != null) {
      currentUser = User(email: phone, password: password, name: name);
      return currentUser;
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_phone');
    await prefs.remove('user_password');
    await prefs.remove('user_name');
    currentUser = null;
  }
}
