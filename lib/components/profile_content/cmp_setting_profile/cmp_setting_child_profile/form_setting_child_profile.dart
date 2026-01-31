import 'package:flutter/material.dart';

import '../../../globals/button/globals_button.dart';
import '../../../globals/card/globals_card.dart';
import '../../../globals/colors/colors.dart';
import '../../../globals/text/text_style.dart';
import '../cmp_form_setting_profile.dart';

class FormSettingChildProfile extends StatefulWidget {
  const FormSettingChildProfile({super.key});

  @override
  State<FormSettingChildProfile> createState() =>
      _FormSettingChildProfileState();
}

class _FormSettingChildProfileState extends State<FormSettingChildProfile> {
  TextEditingController namaAnakController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController beratBadanController = TextEditingController();
  TextEditingController tinggiBadanController = TextEditingController();
  TextEditingController riwayatPenyakitController = TextEditingController();
  TextEditingController alergiController = TextEditingController();
  TextEditingController makananFavController = TextEditingController();
  TextEditingController hindariMakanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          CmpFormSettingProfile(
              controller: namaAnakController,
              lable: 'Nama Anak*',
              keyboardType: TextInputType.text),
          CmpFormSettingProfile(
              controller: tanggalLahirController,
              lable: 'Tanggal Lahir*',
              keyboardType: TextInputType.datetime),
          Row(
            children: [
              Expanded(
                child: CmpFormSettingProfile(
                  controller: beratBadanController,
                  lable: 'Berat Badan (kg)*',
                  keyboardType: TextInputType.number,
                  labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CmpFormSettingProfile(
                  controller: tinggiBadanController,
                  lable: 'Tinggi Badan (cm)*',
                  keyboardType: TextInputType.number,
                  labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
                ),
              ),
            ],
          ),
          CmpFormSettingProfile(
              controller: riwayatPenyakitController,
              lable: 'Riwayat Penyakit',
              keyboardType: TextInputType.text),
          CmpFormSettingProfile(
              controller: alergiController,
              lable: 'Alergi',
              keyboardType: TextInputType.text),
          CmpFormSettingProfile(
              controller: makananFavController,
              lable: 'Makanan Favorit',
              keyboardType: TextInputType.text),
          CmpFormSettingProfile(
              controller: hindariMakanController,
              lable: 'Makanan yang Dihindari',
              keyboardType: TextInputType.text),
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
                  Text('kode Referal', style: AppTextStyles.headList1Regular()),
                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 9.0, bottom: 15),
            child: GlobalsButton(
              radius: 16,
              elevation: 0,
              onPressed: () {},
              text: 'Simpan',
              color: AppColors.secondary1,
            ),
          )
        ],
      ),
    );
  }
}
