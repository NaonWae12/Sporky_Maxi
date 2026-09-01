import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';
import 'package:sporky_maxi/core/utils/login_redirect_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), _openNextPage);
  }

  Future<void> _openNextPage() async {
    if (!mounted) return;

    try {
      final hasSession = await AuthService.hasValidCachedSession();
      if (hasSession && mounted) {
        await LoginRedirectHandler.handle(context);
        return;
      }
    } catch (_) {
      await AuthService.logout();
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo_dummy.png',
          height: 200,
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
