import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/medical_record_cmp/data_medical_record_cmp.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PageMedicalRecord extends StatelessWidget {
  const PageMedicalRecord({super.key});

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
            Text(
              'Rekam Medis Konsultasi',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            imageColor: AppColors.info1,
            lineColor: AppColors.info1,
            imageAsset: 'assets/svg/ic_warn.svg',
            text:
                'Rekam medis ini akan membantu orangtua memahami kondisi dan arahan lanjutan dari sesi konsultasi. Tuliskan dengan jelas dan ringkas.',
          ),
          Expanded(
            child: DataMedicalRecordCmp(
              parentName: 'parentName',
              childName: 'childName',
              calendar: '16/10/2023',
              age: '50',
              weight: '50',
              height: '50',
              complaint:
                  'Kurang napsu makan Rekam medis ini akan membantu orangtua memahami kondisi dan arahan lanjutan dari sesi konsultasi.',
            ),
          ),
          GlobalsButton(
            width: MediaQuery.of(context).size.width / 1.1,
            color: AppColors.secondary1,
            customTextStyle: AppTextStyles.headList1Bold(AppColors.base5),
            onPressed: () {},
            text: 'Simpan Perubahan',
          ),
          const SizedBox(height: 25)
        ],
      ),
    );
  }
}
