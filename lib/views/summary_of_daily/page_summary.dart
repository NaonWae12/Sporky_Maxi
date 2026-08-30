import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';
import 'package:sporky_maxi/views/consultation/main_page_consultation.dart';

import '../../components/globals/text/text_style.dart';
import '../../components/summary_cmp/summary_cmp.dart';

class PageSummary extends StatelessWidget {
  const PageSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                'Ringkasan Asupan  Harian',
                style: AppTextStyles.heading2SemiBold(),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            CmpTagAttention(
              imageAsset: 'assets/svg/ic_warn.svg',
              text:
                  'Catatan hari ini membantu kamu memahami pola makan dan pertumbuhan si kecil. ',
            ),
            SummaryCmp(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: GlobalsButton(
                    text: "Konsultasi",
                    color: AppColors.secondary1,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPageConsultation(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: GlobalsButton(
                    text: "Home",
                    color: AppColors.primary2,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Navbar()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
