import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/initial_display/register_cmp/optional_choice.dart';
import 'package:sporky_maxi/components/initial_display/register_cmp/registration_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              Text(
                "Buat akun orangtua",
                style: AppTextStyles.heading2SemiBold(),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegistrationForm(),
              const SizedBox(height: 5),
              const OptionalChoice(),
            ],
          ),
        ),
      ),
    );
  }
}
