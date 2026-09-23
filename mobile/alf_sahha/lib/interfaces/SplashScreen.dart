import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../token/token_storage.dart';
import 'login/loginScreen.dart';
import 'mainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final token = await TokenStorage.getToken();

    if (!mounted) return;

    // ما في توكن أصلاً
    if (token == null || token.trim().isEmpty) {
      _goToLogin();
      return;
    }

    // في توكن محلي، بس لازم نتأكد إنه صالح وصح عند السيرفر
    try {
      final response = await Dio().get(
        'https://alf-sahha.onrender.com/api/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // التوكن صالح واليوزر موجود فعلاً
        _goToMain();
      } else {
        _clearTokenAndGoToLogin();
      }
    } catch (e) {
      if (!mounted) return;
      // أي خطأ (401, 500, اليوزر مش موجود...) → امسح التوكن ورجعه عالـ Login
      _clearTokenAndGoToLogin();
    }
  }

  Future<void> _clearTokenAndGoToLogin() async {
    await TokenStorage.removeToken(); // تأكد الاسم مطابق للميثود عندك
    _goToLogin();
  }

  void _goToMain() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange),
            SizedBox(height: 16),
            Text(
              'اسم التطبيق',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
