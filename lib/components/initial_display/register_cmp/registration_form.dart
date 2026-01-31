// ignore_for_file: avoid_print, prefer_const_declarations, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/dialog/dialog_alert.dart';
import 'package:sporky_maxi/views/initial_display/login_page.dart';
import 'dart:convert';

import '../../globals/button/globals_button.dart';
import '../../globals/constants/api_endpoints.dart';
import '../../globals/form/globals_form.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  void _togglePassword1Visibility() {
    setState(() {
      _isObscure1 = !_isObscure1;
    });
  }

  void _togglePassword2Visibility() {
    setState(() {
      _isObscure2 = !_isObscure2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/logo_dummy.png"),
        GlobalsForm(
          label: 'Email*',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        GlobalsForm(
          label: 'Username*',
          controller: usernameController,
        ),
        const SizedBox(height: 16),
        GlobalsForm(
          label: 'No. Hp / WhatsApp*',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        GlobalsForm(
          label: 'Password*',
          controller: passwordController,
          isObscure: _isObscure1,
          suffixIcon: IconButton(
            onPressed: _togglePassword1Visibility,
            icon: SvgPicture.asset(
              _isObscure1
                  ? 'assets/svg/ic_eye_off.svg'
                  : 'assets/svg/ic_eye.svg',
            ),
            iconSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        GlobalsForm(
          label: 'Confirm Password*',
          controller: confirmPasswordController,
          isObscure: _isObscure2,
          suffixIcon: IconButton(
            onPressed: _togglePassword2Visibility,
            icon: SvgPicture.asset(
              _isObscure2
                  ? 'assets/svg/ic_eye_off.svg'
                  : 'assets/svg/ic_eye.svg',
            ),
            iconSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        GlobalsButton(
            text: 'Register',
            onPressed: () async {
              final String name = usernameController.text;
              final String email = emailController.text;
              final String phone = phoneController.text;
              final String password = passwordController.text;
              final String confirmPassword = confirmPasswordController.text;

              final url = Uri.parse(ApiEndpoints.register);

              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  "name": name,
                  "email": email,
                  "phone_number": phone,
                  "password": password,
                  "password_confirmation": confirmPassword,
                }),
              );

              print("Status code: ${response.statusCode}");
              print("Response body: ${response.body}");

              if (response.statusCode == 200 || response.statusCode == 201) {
                // Registrasi berhasil
                emailController.clear();
                usernameController.clear();
                phoneController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                DialogAlert.show(
                    context: context,
                    customChild: Content1(
                        title: "Akun Berhasil dibuat",
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        textNav: "Login",
                        message: 'Klik Tombol Login Untuk Memulai Kegiatan'));
              } else if (response.statusCode == 422) {
                // Validation error dari backend
                final Map<String, dynamic> body = jsonDecode(response.body);
                final errors = body['errors'];

                String errorMessage = "Gagal registrasi.";

                if (errors != null && errors.containsKey('email')) {
                  errorMessage = errors['email']
                      [0]; // contoh: "The email has already been taken."
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              } else {
                // Error lain (misal 500, 403, dll)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal: ${response.body}')),
                );
              }
            }),
      ],
    );
  }
}
