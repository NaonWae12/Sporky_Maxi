import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/profile/edit_profile/edit_profile_cmp.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PageSettingExpertProfile extends StatelessWidget {
  const PageSettingExpertProfile({super.key});

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
            onTap: () {},
          ),
          Card(
            text: 'Pengalaman Profesional',
            onTap: () {},
          ),
          Card(
            text: 'Informasi Rekening Bank',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const Card({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base4,
      hasShadow: false,
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppTextStyles.headList1Regular()),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
    );
  }
}
