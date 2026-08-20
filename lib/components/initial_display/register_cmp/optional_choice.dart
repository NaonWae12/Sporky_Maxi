import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/initial_display/login_page.dart';

class OptionalChoice extends StatelessWidget {
  const OptionalChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'sudah punya akun? ',
              style: TextStyle(color: Colors.grey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              child: const Text(
                'Masuk',
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
}
