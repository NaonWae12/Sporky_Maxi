import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';
import 'package:sporky_maxi/core/utils/login_redirect_handler.dart';
import 'package:sporky_maxi/views/initial_display/register_page.dart';

class BottomContent extends StatefulWidget {
  const BottomContent({super.key});

  @override
  State<BottomContent> createState() => _BottomContentState();
}

class _BottomContentState extends State<BottomContent> {
  bool _isLoading = false;

  Future<void> _handleGoogleLogin() async {
    await _handleSocialLogin(AuthService.signInWithGoogle);
  }

  Future<void> _handleAppleLogin() async {
    await _handleSocialLogin(AuthService.signInWithApple);
  }

  Future<void> _handleSocialLogin(
    Future<Map<String, dynamic>> Function() login,
  ) async {
    if (_isLoading) return;

    try {
      setState(() => _isLoading = true);
      final response = await login();
      await AuthService.persistSession(response);

      if (!mounted) return;
      await LoginRedirectHandler.handle(context);
    } on AuthCancelledException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login dibatalkan')));
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        const Text(
          'atau masuk dengan',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              iconAsset: 'assets/icon_google.png',
              onTap: _handleGoogleLogin,
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              iconAsset: 'assets/icon_apple.png',
              onTap: _handleAppleLogin,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'belum punya akun? ',
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
              child: const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    String? iconAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : icon != null
            ? Icon(icon, color: Colors.black)
            : Image.asset(iconAsset!, fit: BoxFit.contain),
      ),
    );
  }
}
