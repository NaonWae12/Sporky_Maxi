import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/profile_content/cmp_setting_profile/cmp_form_setting_profile.dart';

class FormSettingParentProfile extends StatefulWidget {
  const FormSettingParentProfile({super.key});

  @override
  State<FormSettingParentProfile> createState() =>
      _FormSettingParentProfileState();
}

class _FormSettingParentProfileState extends State<FormSettingParentProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          CmpFormSettingProfile(
              controller: emailController,
              lable: 'Email*',
              keyboardType: TextInputType.emailAddress),
          CmpFormSettingProfile(
              controller: passwordController,
              lable: 'Password*',
              isObscure: true,
              keyboardType: TextInputType.none),
          CmpFormSettingProfile(
              controller: noHpController,
              lable: 'No. Hp/Whatsap*',
              keyboardType: TextInputType.phone),
          GlobalsCard(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 4),
              hasShadow: false,
              backgroundColor: AppColors.base3,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ganti Kata Sandi',
                      style: AppTextStyles.headList1Regular()),
                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              )),
          GlobalsCard(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 4),
              hasShadow: false,
              backgroundColor: AppColors.base3,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Keluar', style: AppTextStyles.headList1Regular()),
                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              )),
          GlobalsCard(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 4),
              hasShadow: false,
              backgroundColor: AppColors.base3,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hapus Akun', style: AppTextStyles.headList1Regular()),
                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              )),
          const SizedBox(height: 8),
          GlobalsButton(
            radius: 16,
            elevation: 0,
            onPressed: () {},
            text: 'Simpan',
            color: AppColors.secondary1,
          )
        ],
      ),
    );
  }
}
