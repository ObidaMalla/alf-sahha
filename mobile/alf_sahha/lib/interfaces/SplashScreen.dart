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
    // حتى تظهر شاشة الـ Splash شوي
    await Future.delayed(const Duration(milliseconds: 1500));

    final token = await TokenStorage.getToken();

    if (!mounted) return;

    // ============================================================
    // يوجد Token
    // ============================================================

    if (token != null && token.trim().isNotEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );

      return;
    }

    // ============================================================
    // لا يوجد Token
    // ============================================================

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
