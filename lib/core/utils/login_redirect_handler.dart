import 'package:flutter/material.dart';

import '../../core/services/child/child_service.dart';
import '../../views/bottom_navbar/navbar.dart';
import '../../views/expert_page/navbar/navbar_expert.dart';
import '../../views/initial_display/login_page.dart';
import '../../views/initial_display/profil_si_kecil_flow_test.dart';
import 'secure_storage_service.dart';

class LoginRedirectHandler {
  static Future<void> handle(BuildContext context) async {
    try {
      final role =
          (await SecureStorageService.getUserRole())?.trim().toLowerCase();
      debugPrint('[Redirect] role from storage: $role');

      if (!context.mounted) return;

      if (role == 'expert') {
        debugPrint('[Redirect] route -> NavbarExpert');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavbarExpert()),
        );
        return;
      }

      if (role != 'user') {
        debugPrint(
            '[Redirect] invalid/empty role, clear session and back to login');
        await SecureStorageService.clearAll();

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }

      final childService = ChildService();
      final children = await childService.getChildUuids();
      debugPrint('[Redirect] children count for user flow: ${children.length}');

      if (!context.mounted) return;

      if (children.isNotEmpty) {
        debugPrint('[Redirect] route -> Navbar (user with child)');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navbar()),
        );
      } else {
        debugPrint(
            '[Redirect] route -> ProfilSiKecilFlowTest (user without child)');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilSiKecilFlowTest(),
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint('LoginRedirectHandler auth error: $e');

      await SecureStorageService.clearAll();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
}
