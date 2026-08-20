// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';
// import 'package:sporky_maxi/views/initial_display/profil_si_kecil_flow.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/login_redirect_handler.dart';
import '../../../core/utils/secure_storage_service.dart';
// import '../../../views/bottom_navbar/navbar.dart';
// import '../../../views/initial_display/profil_si_kecil_flow_test.dart';

class TopContent extends StatefulWidget {
  const TopContent({super.key});

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _checkToken(); // ✅ cek token saat pertama kali dibuka
  }

  // ✅ Fungsi tambahan: cek token di secure storage
  Future<void> _checkToken() async {
    final token = await SecureStorageService.getToken();
    final cachedRole = await SecureStorageService.getUserRole();
    debugPrint(
        '[Login] cached token exists: ${token != null && token.isNotEmpty}');
    debugPrint('[Login] cached role before auto-redirect: $cachedRole');
    debugPrint("🔑 token: $token");

    if (token == null || token.isEmpty) return;
    if (cachedRole == null || cachedRole.trim().isEmpty) {
      debugPrint(
          '[Login] token exists but role missing, clearing stale session');
      await SecureStorageService.clearAll();
      return;
    }

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

    final url = Uri.parse(ApiEndpoints.login);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
      'remember_me': false, // sesuai spec API
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final token = body['data']?['token'] as String?;
        final tokenType = body['data']?['token_type'] as String? ?? "Bearer";
        final userUuid = body['data']?['user']?['uuid'] as String?;
        final userName = body['data']?['user']?['name'] as String?;
        final userRole = body['data']?['user']?['role'] as String?;
        final normalizedRole = userRole?.trim().toLowerCase();
        debugPrint(
            '[Login] API role raw: $userRole | normalized: $normalizedRole');

        if (token == null ||
            userUuid == null ||
            normalizedRole == null ||
            normalizedRole.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Login berhasil tapi data tidak lengkap")),
          );
          return;
        }

        await SecureStorageService.saveToken("$tokenType $token");
        await SecureStorageService.saveUserUuid(userUuid);
        await SecureStorageService.saveUserRole(normalizedRole);
        final savedRole = await SecureStorageService.getUserRole();
        debugPrint('[Login] role saved in storage: $savedRole');
        if (userName != null && userName.isNotEmpty) {
          await SecureStorageService.saveUserName(userName);
        }

        await LoginRedirectHandler.handle(context);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login gagal';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
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
        GlobalsButton(text: "masuk", onPressed: _login),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {},
            child: const Text(
              "Lupa Kata Sandi?",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        )
      ],
    );
  }
}
