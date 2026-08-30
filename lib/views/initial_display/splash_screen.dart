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

    _timer = Timer(const Duration(milliseconds: 5200), _openNextPage);
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
    Navigator.pushReplacementNamed(context, '/home');
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
          'assets/giff/logo_animate.gif',
          height: 250,
          width: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
