import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/initial_display/register_page.dart';

class BottomContent extends StatelessWidget {
  const BottomContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        const Text(
          'atau masuk dengan',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
                icon: Icons.phone,
                onTap: () {
                  // Handle login via phone
                }),
            const SizedBox(width: 16),
            _buildSocialButton(
              iconAsset: 'assets/icon_google.png',
              onTap: () {
                // Handle login via Google
              },
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              iconAsset: 'assets/icon_apple.png',
              onTap: () {
                // Handle login via Apple
              },
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ));
              },
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ));
                },
                child: const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      {IconData? icon, String? iconAsset, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        child: icon != null
            ? Icon(icon, color: Colors.black)
            : Image.asset(iconAsset!, fit: BoxFit.contain),
      ),
    );
  }
}
