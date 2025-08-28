import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartcity/navigation/main_navigation.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import 'profile_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorText = null;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    if (_isLogin) {
      // Авторизация
      final db = DBService();
      // Clean the phone number for lookup
      String cleanPhone = _phoneController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (cleanPhone.startsWith('+7')) {
        cleanPhone = cleanPhone.substring(2);
      } else if (cleanPhone.startsWith('7') && cleanPhone.length > 10) {
        cleanPhone = cleanPhone.substring(1);
      }
      final user = await db.getUserByEmail(cleanPhone);
      if (user == null || user.password != _passwordController.text) {
        setState(() {
          _errorText = 'Неверный номер телефона или пароль';
          _isLoading = false;
        });
        return;
      }
      await AuthService.saveUser(user);
      setState(() {
        _isLoading = false;
      });
      // Переход на профиль
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainNavigationPage()),
      );
    } else {
      // Регистрация
      final db = DBService();
      // Clean the phone number for lookup
      String phoneForLookup = _phoneController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (phoneForLookup.startsWith('+7')) {
        phoneForLookup = phoneForLookup.substring(2);
      } else if (phoneForLookup.startsWith('7') && phoneForLookup.length > 10) {
        phoneForLookup = phoneForLookup.substring(1);
      }
      final existing = await db.getUserByEmail(phoneForLookup);
      if (existing != null) {
        setState(() {
          _errorText = 'Пользователь с таким номером телефона уже существует';
          _isLoading = false;
        });
        return;
      }
      // Remove any spaces, dashes, or parentheses from phone number
      String cleanPhone = _phoneController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
      
      // Remove +7 prefix if present
      if (cleanPhone.startsWith('+7')) {
        cleanPhone = cleanPhone.substring(2);
      } else if (cleanPhone.startsWith('7') && cleanPhone.length > 10) {
        cleanPhone = cleanPhone.substring(1);
      }
      
      final user = User(
          name: "Пользователь",
          email: cleanPhone, // Store clean phone number in the email field
          password: _passwordController.text);
      try {
        await db.insertUser(user);
        setState(() {
          _isLogin = true;
          _isLoading = false;
          _errorText = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация успешна! Теперь войдите.')),
        );
        _phoneController.clear();
        _passwordController.clear();
        _confirmController.clear();
      } catch (e) {
        setState(() {
          _errorText = 'Ошибка при регистрации';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFFDB5B2B);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Логотип
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/icons/turkistan.jpg",
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Заголовок
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isLogin ? 'Вход в аккаунт' : 'Создать аккаунт',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_errorText != null) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        _errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                  // Телефон
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Номер телефона',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Text(
                          '+7',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: mainColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите номер телефона';
                      }
                      // Remove any spaces, dashes, or parentheses for validation
                      String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                      // Remove +7 prefix if present
                      if (cleanPhone.startsWith('+7')) {
                        cleanPhone = cleanPhone.substring(2);
                      } else if (cleanPhone.startsWith('7') && cleanPhone.length > 10) {
                        cleanPhone = cleanPhone.substring(1);
                      }
                      
                      // Check if it's a valid Kazakhstan phone number (10 digits)
                      if (cleanPhone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
                        return 'Введите корректный номер телефона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: mainColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    // Confirm Password
                    TextFormField(
                      controller: _confirmController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Повторите пароль',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: mainColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Повторите пароль';
                        }
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 28),
                  // Кнопка входа/регистрации
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // --- Соц. сети ---
                  Row(
                    children: [
                      const Expanded(
                          child:
                              Divider(thickness: 1, color: Color(0xFFE5E7EB))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          _isLogin
                              ? 'Или войдите с помощью'
                              : 'Или зарегистрируйтесь с помощью',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                      ),
                      const Expanded(
                          child:
                              Divider(thickness: 1, color: Color(0xFFE5E7EB))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.g_mobiledata, Colors.red),
                      const SizedBox(width: 18),
                      _buildSocialButton(Icons.facebook, Colors.blue[800]!),
                      const SizedBox(width: 18),
                      _buildSocialButton(
                          Icons.phone_android, Colors.lightBlue),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // --- Переключение между входом и регистрацией ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Нет аккаунта? ' : 'Уже есть аккаунт? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _toggleAuthMode,
                        child: Text(
                          _isLogin ? 'Зарегистрироваться' : 'Войти',
                          style: const TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
