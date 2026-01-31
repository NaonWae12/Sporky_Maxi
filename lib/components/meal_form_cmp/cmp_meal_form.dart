import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CmpMealForm extends StatefulWidget {
  const CmpMealForm({super.key});

  @override
  State<CmpMealForm> createState() => _CmpMealFormState();
}

class _CmpMealFormState extends State<CmpMealForm> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded1 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded1 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/bento-box-rounded.svg'),
                  const SizedBox(width: 8),
                  Text('Pilih Jenis Makanan',
                      style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded1 = !isExpanded1;
                  });
                },
                icon: Icon(
                  isExpanded1
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),

        // tampilkan CmpTagAttention jika isExpanded1 true
        if (isExpanded1) ...[
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            text: 'Makan Pagi',
            lineColor: AppColors.base4,
            imageColor: AppColors.primary1,
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            text: 'Snack Pagi',
            lineColor: AppColors.base4,
            imageColor: AppColors.info1,
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            text: 'Makan Siang',
            lineColor: AppColors.base4,
            imageColor: AppColors.warn1,
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            text: 'Snack Sore',
            lineColor: AppColors.base4,
            imageColor: AppColors.info1,
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            text: 'Makan Malam',
            lineColor: AppColors.base4,
            imageColor: AppColors.secondary1,
          ),
        ],
        // pilihan kedua
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded2 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded2 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/ic_form.svg'),
                  const SizedBox(width: 8),
                  Text('Pilih Cara Menghitung Kalori',
                      style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded2 = !isExpanded2;
                  });
                },
                icon: Icon(
                  isExpanded2
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),

        // tampilkan CmpTagAttention jika isExpanded1 true
        if (isExpanded2) ...[
          CmpTagAttention(
            space: 8,
            textStyle: AppTextStyles.headList1Regular(),
            imageAsset: 'assets/svg/ic_edit.svg',
            text: 'Isi Manual',
            lineColor: AppColors.base4,
            textAndImageColor: AppColors.base1,
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            lineColor: AppColors.base4,
            textAndImageColor: AppColors.base1,
            child: Row(
              children: [
                Text('Meal Plan (Auto Filled)',
                    style: AppTextStyles.headList1Regular()),
                SvgPicture.asset(height: 11, width: 11, 'assets/svg/sun.svg')
              ],
            ),
          ),
          const SizedBox(height: 8),
          CmpTagAttention(
            space: 8,
            imageAsset: 'assets/svg/ic_ qr.svg',
            lineColor: AppColors.base4,
            textAndImageColor: AppColors.base1,
            child: Row(
              children: [
                Text('QR Code', style: AppTextStyles.headList1Regular()),
                SvgPicture.asset(height: 11, width: 11, 'assets/svg/sun.svg')
              ],
            ),
          ),
        ],
      ],
    );
  }
}
