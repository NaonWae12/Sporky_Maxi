import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../globals/form/globals_text_area.dart';

class DataMedicalRecordCmp extends StatefulWidget {
  final String parentName;
  final String childName;
  final String calendar;
  final String age;
  final String weight;
  final String height;
  final String complaint;
  final String diagnosisResult;
  final String recommendation;

  const DataMedicalRecordCmp({
    super.key,
    required this.parentName,
    required this.childName,
    required this.calendar,
    required this.age,
    required this.weight,
    required this.height,
    required this.complaint,
    required this.diagnosisResult,
    required this.recommendation,
  });

  @override
  State<DataMedicalRecordCmp> createState() => DataMedicalRecordCmpState();
}

class DataMedicalRecordCmpState extends State<DataMedicalRecordCmp> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    diagnosisController.text = widget.diagnosisResult;
    adviceController.text = widget.recommendation;
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    adviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardComponents1(title: 'Nama Orangtua', desc: widget.parentName),
          CardComponents1(title: 'Nama Anak', desc: widget.childName),
          Row(
            children: [
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                    left: 16,
                    top: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  title: 'Tanggal',
                  desc: widget.calendar,
                  showIcon: true,
                ),
              ),
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 16,
                    bottom: 8,
                  ),
                  title: 'Usia',
                  desc: widget.age,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                    left: 16,
                    top: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  title: 'Berat Badan (kg)',
                  desc: widget.weight,
                ),
              ),
              Expanded(
                child: CardComponents1(
                  margin: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 16,
                    bottom: 8,
                  ),
                  title: 'Tinggi Badan (cm)',
                  desc: widget.height,
                ),
              ),
            ],
          ),
          CardComponents1(
            widthBox: MediaQuery.of(context).size.width / 1.2,
            title: 'Keluhan',
            desc: widget.complaint,
          ),
          const SizedBox(height: 16),
          Center(
            child: GlobalsTextArea(
              width: MediaQuery.of(context).size.width / 1.1,
              label: "Hasil Diagnosis",
              hintText:
                  "Tuliskan ringkasan kondisi anak berdasarkan hasil konsultasi",
              controller: diagnosisController,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: GlobalsTextArea(
              width: MediaQuery.of(context).size.width / 1.1,
              label: "Saran / Tindakan",
              hintText: "Tuliskan langkah yang perlu dilakukan orang tua",
              controller: adviceController,
              onChanged: (_) => setState(() {}),
            ),
          ),
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
              Text(title, style: AppTextStyles.list3SemiBold(AppColors.base2)),
              SizedBox(
                width: widthBox,
                child: Text(
                  desc,
                  style: AppTextStyles.headList1Regular(AppColors.base1),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          if (showIcon)
            SvgPicture.asset(
              'assets/svg/ic_ calendar - schedule.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColors.primary1,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
