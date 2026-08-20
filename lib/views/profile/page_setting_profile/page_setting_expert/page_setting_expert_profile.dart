import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/expert_components/profile/edit_profile/edit_profile_cmp.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../../core/utils/secure_storage_service.dart';
import '../../../initial_display/login_page.dart';
import 'page_personal_info_expert.dart';

class PageSettingExpertProfile extends StatelessWidget {
  const PageSettingExpertProfile({super.key});
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SecureStorageService.clearAll();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Text('Pengaturan Akun', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: EditProfileCmp(
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            ),
          ),
          Card(
            text: 'Keamanan Akun',
            onTap: () {},
          ),
          Card(
            text: 'Informasi Pribadi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PagePersonalInfoExpert(),
                ),
              );
            },
          ),
          Card(
            text: 'Pengalaman Profesional',
            onTap: () {},
          ),
          Card(
            text: 'Informasi Rekening Bank',
            onTap: () {},
          ),
          Card(
            onTap: () => _confirmLogout(context),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/logout.svg'),
                Text(
                  'Keluar',
                  style: AppTextStyles.list1Regular(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;
  final Widget? child;

  const Card({
    super.key,
    this.text,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base4,
      hasShadow: false,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child: child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text ?? '', style: AppTextStyles.headList1Regular()),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
    );
  }
}
