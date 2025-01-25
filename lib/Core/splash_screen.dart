import 'package:chinese_bazaar/Core/Services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  SplashScreen({super.key});

  void checkLogin(BuildContext context) async {
    final token = await authService.getToken();
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLogin(context));

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
