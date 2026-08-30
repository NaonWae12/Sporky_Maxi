// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';
import 'package:sporky_maxi/views/initial_display/reset_password_page.dart';

import '../../../core/utils/login_redirect_handler.dart';

class TopContent extends StatefulWidget {
  const TopContent({super.key});

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkToken(); // ✅ cek token saat pertama kali dibuka
  }

  // ✅ Fungsi tambahan: cek token di secure storage
  Future<void> _checkToken() async {
    final hasSession = await AuthService.hasValidCachedSession();
    if (!hasSession) return;

    if (!mounted) return;
    await LoginRedirectHandler.handle(context);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      final response = await AuthService.loginEmailPassword(
        email: email,
        password: password,
      );
      await AuthService.persistSession(response);

      if (!mounted) return;
      await LoginRedirectHandler.handle(context);
    } on ApiException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    forgotEmailController.text = emailController.text.trim();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        var isSendingOtp = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => SporkyDialog(
            title: 'Lupa Kata Sandi',
            message:
                'Masukkan email akunmu. Kami akan mengirim kode OTP untuk reset password.',
            actions: [
              SporkyDialogAction(
                label: 'Batal',
                onPressed: isSendingOtp
                    ? null
                    : () => Navigator.pop(dialogContext),
              ),
              SporkyDialogAction(
                label: isSendingOtp ? 'Mengirim...' : 'Kirim OTP',
                onPressed: isSendingOtp
                    ? null
                    : () async {
                        final email = forgotEmailController.text.trim();
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email wajib diisi')),
                          );
                          return;
                        }

                        try {
                          setDialogState(() => isSendingOtp = true);
                          final response = await AuthService.forgotPassword(
                            email: email,
                          );
                          if (!dialogContext.mounted) return;
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                response['message']?.toString() ??
                                    'Kode OTP telah dikirim ke email Anda.',
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordPage(email: email),
                            ),
                          );
                        } on ApiException catch (e) {
                          if (!dialogContext.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        } finally {
                          if (dialogContext.mounted) {
                            setDialogState(() => isSendingOtp = false);
                          }
                        }
                      },
                isPrimary: true,
                isLoading: isSendingOtp,
              ),
            ],
            child: TextField(
              controller: forgotEmailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: SporkyDialog.inputDecoration(labelText: 'Email'),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsForm(
          label: 'Email*',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        GlobalsForm(
          fillColor: AppColors.base5,
          label: 'Password*',
          controller: passwordController,
          keyboardType: TextInputType.emailAddress,
          isObscure: _isObscure,
          suffixIcon: IconButton(
            onPressed: _togglePasswordVisibility,
            icon: SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                _isObscure
                    ? 'assets/svg/ic_eye_off.svg'
                    : 'assets/svg/ic_eye.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GlobalsButton(
          text: _isLoading ? "memproses..." : "masuk",
          onPressed: _isLoading ? null : _login,
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: _showForgotPasswordDialog,
            child: const Text(
              "Lupa Kata Sandi?",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
      ],
    );
  }
}
