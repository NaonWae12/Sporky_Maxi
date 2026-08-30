import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/medical_record_cmp/medical_record_content.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PageMedicalRecord extends StatefulWidget {
  final String roomUuid;

  const PageMedicalRecord({super.key, required this.roomUuid});

  @override
  State<PageMedicalRecord> createState() => _PageMedicalRecordState();
}

class _PageMedicalRecordState extends State<PageMedicalRecord> {
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
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            Text(
              'Rekam Medis Konsultasi',
              style: AppTextStyles.heading2SemiBold(),
            ),
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
          MedicalRecordContent(roomUuid: widget.roomUuid),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
