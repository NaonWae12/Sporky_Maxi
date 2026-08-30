import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  const ResetPasswordPage({super.key, this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static const int _resendCooldownSeconds = 60;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Timer? _resendTimer;

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;
  bool _isResendingOtp = false;
  int _remainingResendSeconds = 0;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email?.trim() ?? '';

    if (emailController.text.isNotEmpty) {
      _startResendCountdown();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
    });
  }

  Future<void> _resetPassword() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        otp.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar('Email, OTP, dan password baru wajib diisi');
      return;
    }

    if (otp.length != 6) {
      _showSnackBar('Kode OTP harus 6 digit');
      return;
    }

    if (password.length < 8) {
      _showSnackBar('Password minimal 8 karakter');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Konfirmasi password tidak sama');
      return;
    }

    try {
      setState(() => _isLoading = true);
      final response = await AuthService.resetPassword(
        otp: otp,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      if (!mounted) return;
      _showSnackBar(
        response['message']?.toString() ?? 'Password berhasil diperbarui',
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(_errorMessageFrom(e));
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_remainingResendSeconds > 0) return;

    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar('Email wajib diisi');
      return;
    }

    try {
      setState(() => _isResendingOtp = true);
      final response = await AuthService.forgotPassword(email: email);
      if (!mounted) return;
      _showSnackBar(
        response['message']?.toString() ?? 'Kode OTP telah dikirim ulang.',
      );
      _startResendCountdown();
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(_errorMessageFrom(e));
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal mengirim OTP: $e');
    } finally {
      if (mounted) {
        setState(() => _isResendingOtp = false);
      }
    }
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _remainingResendSeconds = _resendCooldownSeconds);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingResendSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingResendSeconds = 0);
        return;
      }

      setState(() => _remainingResendSeconds--);
    });
  }

  String _formatResendCountdown() {
    final minutes = (_remainingResendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingResendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _resendOtpText() {
    if (_isResendingOtp) return 'Mengirim...';
    if (_remainingResendSeconds > 0) {
      return 'Kirim ulang OTP (${_formatResendCountdown()})';
    }
    return 'Kirim ulang OTP';
  }

  String _errorMessageFrom(ApiException exception) {
    final errors = exception.body['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
        if (value != null) {
          return value.toString();
        }
      }
    }

    return exception.message;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _backToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  Widget _buildPasswordSuffix({
    required VoidCallback onPressed,
    required bool isObscure,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: SizedBox(
        height: 25,
        width: 25,
        child: SvgPicture.asset(
          isObscure ? 'assets/svg/ic_eye_off.svg' : 'assets/svg/ic_eye.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leading: IconButton(
          onPressed: _backToLogin,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Reset Kata Sandi',
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo_dummy.png', height: 150),
                const SizedBox(height: 16),
                Text(
                  'Masukkan kode OTP dari email dan buat password baru untuk akun Sporky Maxi kamu.',
                  style: AppTextStyles.desc1Regular(AppColors.base1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GlobalsForm(
                  label: 'Email*',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.display1Bold(
                    AppColors.secondary1,
                  ).copyWith(letterSpacing: 10),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Kode OTP*',
                    labelStyle: AppTextStyles.lable2Regular(AppColors.base2),
                    filled: true,
                    fillColor: AppColors.base5,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.primary1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: AppColors.primary1,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isResendingOtp || _remainingResendSeconds > 0
                        ? null
                        : _resendOtp,
                    child: Text(
                      _resendOtpText(),
                      style: TextStyle(
                        color: _remainingResendSeconds > 0
                            ? AppColors.base2
                            : AppColors.primary1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GlobalsForm(
                  label: 'Password Baru*',
                  controller: passwordController,
                  isObscure: _isPasswordObscure,
                  suffixIcon: _buildPasswordSuffix(
                    onPressed: _togglePasswordVisibility,
                    isObscure: _isPasswordObscure,
                  ),
                ),
                const SizedBox(height: 16),
                GlobalsForm(
                  label: 'Konfirmasi Password Baru*',
                  controller: confirmPasswordController,
                  isObscure: _isConfirmPasswordObscure,
                  suffixIcon: _buildPasswordSuffix(
                    onPressed: _toggleConfirmPasswordVisibility,
                    isObscure: _isConfirmPasswordObscure,
                  ),
                ),
                const SizedBox(height: 24),
                GlobalsButton(
                  text: _isLoading ? 'memproses...' : 'Reset Password',
                  onPressed: _isLoading ? null : _resetPassword,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isLoading ? null : _backToLogin,
                  child: const Text(
                    'Kembali ke Masuk',
                    style: TextStyle(color: AppColors.primary1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
