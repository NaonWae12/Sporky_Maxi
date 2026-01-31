// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class BiodataCmp extends StatelessWidget {
  final String childName;
  final String calendar;
  final String historyOfIllness;
  final String allergies;
  final String favoriteFood;
  final String foodsToAvoid;
  // final String age;
  final String weight;
  final String height;
  // final String complaint;

  const BiodataCmp({
    super.key,
    required this.childName,
    required this.calendar,
    required this.historyOfIllness,
    required this.allergies,
    required this.favoriteFood,
    required this.foodsToAvoid,
    // required this.age,
    required this.weight,
    required this.height,
    // required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardComponents1(title: 'Nama Anak', desc: childName),
          CardComponents1(
            title: 'Tanggal',
            desc: calendar,
            showIcon: true,
          ),
          Row(
            children: [
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                      left: 16, top: 8, right: 8, bottom: 8),
                  title: 'Berat Badan (kg)',
                  desc: weight,
                ),
              ),
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                      left: 8, top: 8, right: 16, bottom: 8),
                  title: 'Tinggi Badan (cm)',
                  desc: height,
                ),
              ),
            ],
          ),
          CardComponents1(title: 'Riwayat Penyakit', desc: historyOfIllness),
          CardComponents1(title: 'Alergi', desc: allergies),
          CardComponents1(title: 'Makanan Favorit', desc: favoriteFood),
          CardComponents1(title: 'Makanan yang Dihindari', desc: foodsToAvoid),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CardComponents1 extends StatelessWidget {
  final String title;
  final String desc;
  final bool showIcon;
  final EdgeInsetsGeometry margin;
  final double? widthBox;
  const CardComponents1({
    super.key,
    required this.title,
    required this.desc,
    this.showIcon = false,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.widthBox,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      margin: margin,
      width: MediaQuery.of(context).size.width,
      backgroundColor: AppColors.base4,
      hasShadow: false,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.list3SemiBold(AppColors.base2),
              ),
              SizedBox(
                width: widthBox,
                child: Text(
                  desc,
                  style: AppTextStyles.headList1Regular(AppColors.base1),
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          ),
          if (showIcon)
            SvgPicture.asset(
              'assets/svg/ic_ calendar - schedule.svg',
              width: 20,
              height: 20,
              colorFilter:
                  ColorFilter.mode(AppColors.primary1, BlendMode.srcIn),
            ),
        ],
      ),
    );
  }
}
