import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/initial_display/login_cmp/bottom_content.dart';
import 'package:sporky_maxi/components/initial_display/login_cmp/top_content.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text("Masuk", style: AppTextStyles.heading2SemiBold()),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage("assets/logo_dummy.png")),
              SizedBox(height: 8),
              TopContent(),
              SizedBox(height: 8),
              BottomContent(),
            ],
          ),
        ),
      ),
    );
  }
}
