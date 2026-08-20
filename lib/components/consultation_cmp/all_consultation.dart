import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/cmp_list_doctor.dart';
import 'package:sporky_maxi/components/consultation_cmp/profile_expert.dart';

import '../globals/card/globals_card_outlined.dart';
import '../globals/colors/colors.dart';
import '../globals/filter/filter_content_button.dart';
import '../globals/text/text_style.dart';

class AllConsultation extends StatefulWidget {
  const AllConsultation({super.key});

  @override
  State<AllConsultation> createState() => _AllConsultationState();
}

class _AllConsultationState extends State<AllConsultation> {
  List<String> _selectedFiltersFromBottomSheet = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _selectedFiltersFromBottomSheet.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedFiltersFromBottomSheet
                              .map(
                                (filter) => GlobalsCardOutlined(
                                  height: 24,
                                  borderColor: Colors.transparent,
                                  backgroundColor: AppColors.secondary2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(filter,
                                          style: AppTextStyles.list1Regular(
                                              AppColors.base5)),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 15, color: AppColors.base5),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _selectedFiltersFromBottomSheet
                                                .remove(filter);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox(), // biar gak ganggu kalau kosong
                ),
                const SizedBox(width: 8),
                FilterContentButton(
                  categories: const ['sdfg', 'adfads'],
                  title: 'Urutkan Berdasarkan',
                  onFilterApplied: (selected) {
                    setState(() {
                      _selectedFiltersFromBottomSheet = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          CmpListDoctor(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileExpert(
                      expertUuid: '',
                    ),
                  ));
            },
            imageAsset: 'assets/temp_img/dr.palomina1.jpg',
            isAvailable: false,
            showChat: false,
            showVideoCall: true,
            role: 'Ahli Gizi',
            expertGroup: true,
            namesOfExpert: 'asdhjkf',
            doctorName: 'dr.palomina',
          ),
          CmpListDoctor(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileExpert(
                      expertUuid: '',
                    ),
                  ));
            },
            imageAsset: 'assets/temp_img/dr.palomina1.jpg',
            isAvailable: true,
            role: 'Ahli Gizi',
            doctorName: 'dr.palomina',
            experience: '5',
            workingDays: 'Senin - Jumat',
            workingHours: '09.30 - 22.00',
            specialization: 'nutrisi anak',
          ),
          const CmpListDoctor(
            imageAsset: 'assets/temp_img/dr.nutritionist.jpg',
            isAvailable: true,
            role: 'Ahli Gizi',
            doctorName: 'dr.palomina',
            experience: '5',
            workingDays: 'Senin - Jumat',
            workingHours: '09.30 - 22.00',
            specialization: 'nutrisi anak',
          ),
          const CmpListDoctor(
            imageAsset: 'assets/temp_img/dr.kevin.jpg',
            isAvailable: true,
            role: 'Ahli Gizi',
            doctorName: 'dr.palomina',
            experience: '5',
            workingDays: 'Senin - Jumat',
            workingHours: '09.30 - 22.00',
            specialization: 'nutrisi anak',
          ),
          const CmpListDoctor(
            imageAsset: 'assets/temp_img/dr.kevin.jpg',
            isAvailable: true,
            role: 'Ahli Gizi',
            doctorName: 'dr.palomina',
            experience: '5',
            workingDays: 'Senin - Jumat',
            workingHours: '09.30 - 22.00',
            specialization: 'nutrisi anak',
          ),
        ],
      ),
    );
  }
}
