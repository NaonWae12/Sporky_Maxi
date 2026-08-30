// ignore_for_file: prefer_const_declarations, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';
import 'package:sporky_maxi/core/utils/login_redirect_handler.dart';

import '../../globals/button/globals_button.dart';
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
        GlobalsForm(label: 'Username*', controller: usernameController),
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

            try {
              final response = await AuthService.register(
                name: name,
                email: email,
                phoneNumber: phone,
                password: password,
                passwordConfirmation: confirmPassword,
              );
              await AuthService.persistSession(response);

              emailController.clear();
              usernameController.clear();
              phoneController.clear();
              passwordController.clear();
              confirmPasswordController.clear();
              if (!mounted) return;
              await _showRegistrationSuccessDialog();
            } on ApiException catch (e) {
              final errors = e.body['errors'];

              String errorMessage = e.message;

              if (errors is Map && errors['email'] is List) {
                errorMessage = errors['email'][0].toString();
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
            } catch (e) {
              // Error lain (misal 500, 403, dll)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _showRegistrationSuccessDialog() async {
    const initialCountdown = 5;
    var remainingSeconds = initialCountdown;
    Timer? timer;
    var hasRedirected = false;

    Future<void> redirect() async {
      if (hasRedirected || !mounted) return;
      hasRedirected = true;
      timer?.cancel();

      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }

      await LoginRedirectHandler.handle(context);
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setDialogState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              if (remainingSeconds <= 1) {
                redirect();
                return;
              }

              setDialogState(() {
                remainingSeconds--;
              });
            });

            return SporkyDialog(
              title: 'Akun Berhasil Dibuat',
              actions: [
                SporkyDialogAction(
                  label: 'Masuk Sekarang',
                  onPressed: redirect,
                  isPrimary: true,
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/giff/gif1.gif', height: 180),
                  Text(
                    'Kamu akan masuk otomatis dalam $remainingSeconds detik.',
                    style: AppTextStyles.list1Regular(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() => timer?.cancel());
  }
}
