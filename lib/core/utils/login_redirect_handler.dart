import 'package:flutter/material.dart';

import '../../core/services/child/child_service.dart';
import '../../views/bottom_navbar/navbar.dart';
import '../../views/initial_display/login_page.dart';
import '../../views/initial_display/profil_si_kecil_flow_test.dart';
import 'secure_storage_service.dart';

class LoginRedirectHandler {
  static Future<void> handle(BuildContext context) async {
    try {
      final childService = ChildService();
      final children = await childService.getChildUuids();

      if (!context.mounted) return;

      // ✅ AUTH VALID
      if (children.isNotEmpty) {
        // ✅ Sudah punya anak → Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navbar()),
        );
      } else {
        // ❌ Belum punya anak → Isi profil anak
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilSiKecilFlowTest(),
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint("🚨 LoginRedirectHandler auth error: $e");

      // 🔥 SESSION INVALID → CLEAN
      await SecureStorageService.clearAll();

      if (!context.mounted) return;

      // ❗ FALLBACK HARUS KE LOGIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
}
