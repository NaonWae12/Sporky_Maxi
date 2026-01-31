import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/subscriptions/subs_plan_cmp.dart';
import 'package:sporky_maxi/components/globals/dialog/badge_tooltip.dart';

import '../../components/globals/button/globals_button.dart';

class SubsPlanPage extends StatefulWidget {
  const SubsPlanPage({super.key});

  @override
  State<SubsPlanPage> createState() => _SubsPlanPageState();
}

class _SubsPlanPageState extends State<SubsPlanPage> {
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text(
                  "Pilih Paket Anda",
                  style: AppTextStyles.heading1SemiBold(),
                ),
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                  "Langganan sesuai kebutuhan, demi tumbuh kembang anak yang optimal",
                  style: AppTextStyles.heading3SemiBold(AppColors.base2)),
            ),
            SubsPlanCmp(
                price: '0',
                month: '1',
                title: 'Langkah Awal (Gratis!)',
                desc: "Coba dulu, tanpa risiko!",
                image: TooltipStep.awal.asset,
                step: TooltipStep.awal,
                features: const [
                  FeatureTile(
                    iconAsset: 'assets/svg/check-box.svg',
                    text: 'Akses Gratis 1 Meal Plan',
                  ),
                  FeatureTile(
                    iconAsset: 'assets/svg/check-box.svg',
                    text: 'Pantau Kalori Harian',
                  ),
                ],
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0)),
            SubsPlanCmp(
                price: '0',
                month: '1',
                title: 'Langkah Awal (Gratis!)',
                desc: "Coba dulu, tanpa risiko!",
                image: TooltipStep.awal.asset,
                step: TooltipStep.awal,
                // descTooltip1: 'Paket gratis',
                // descTooltip2:
                //     'dengan fitur dasar, akses ke 1 meal plan, pantauan kalori, dan akses konten edukasi. Ideal untuk coba-coba dulu.',
                features: const [
                  FeatureTile(
                    iconAsset: 'assets/svg/check-box.svg',
                    text: 'Akses Gratis 1 Meal Plan',
                  ),
                  FeatureTile(
                    iconAsset: 'assets/svg/check-box.svg',
                    text: 'Pantau Kalori Harian',
                  ),
                ],
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1)),
            SubsPlanCmp(
              price: '0',
              month: '1',
              title: 'Langkah Untuk Masa Depan',
              desc: "Mulai pelan, dampingi dengan tenang.",
              image: TooltipStep.lengkap.asset,
              step: TooltipStep.lengkap,
              features: const [
                FeatureTile(
                  iconAsset: 'assets/svg/check-box.svg',
                  text: 'Akses Gratis 1 Meal Plan',
                ),
                FeatureTile(
                  iconAsset: 'assets/svg/check-box.svg',
                  text: 'Pantau Kalori Harian',
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  AppColors.secondary2.withValues(alpha: 0.6 * 255.round()),
                  const Color(0xCCF3F3F3).withValues(alpha: 0.8 * 255.round()),
                  const Color(0x80FFFAE1).withValues(alpha: 0.5 * 255.round()),
                ],
              ),
              isSelected: _selectedIndex == 2,
              selectedBorderColor: AppColors.primary1,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlobalsButton(
                color: _selectedIndex == -1
                    ? AppColors.secondary2
                    : AppColors.secondary1,
                text: "Berlangganan",
                onPressed: _selectedIndex == -1 ? null : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
