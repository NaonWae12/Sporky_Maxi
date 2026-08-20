import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../../../views/profile/child_profile/medical_history_details_page.dart';

class MedicalHistoryCmp extends StatelessWidget {
  final String childUuid;
  final String? roomUuid;
  final String parentName;

  const MedicalHistoryCmp({
    super.key,
    required this.childUuid,
    this.roomUuid,
    required this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    // Data dummy sesuai gambar
    final List<Map<String, String>> medicalData = [
      {
        'title': 'Nafsu Makan Turun',
        'desc':
            'Lorem ipsum dolor sit amet consectetur. Arcu arcu lacus justo tellus facilisis eges...',
        'time': '10.08',
      },
      {
        'title': 'Sesak Nafas, Batuk Kering',
        'desc':
            'Lorem ipsum dolor sit amet consectetur. Arcu arcu lacus justo tellus facilisis eges...',
        'time': '30/07/25',
      },
      {
        'title': 'Panas Tidak Turun dalam 5 Hari',
        'desc':
            'Lorem ipsum dolor sit amet consectetur. Arcu arcu lacus justo tellus facilisis eges...',
        'time': '30/07/25',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: medicalData.map((data) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicalHistoryDetailsPage(
                          childUuid: childUuid,
                          roomUuid: roomUuid,
                          parentName: parentName,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circle Placeholder
                      Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.base3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['title']!,
                                    style: AppTextStyles.headList1Bold(
                                        AppColors.base1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  data['time']!,
                                  style: AppTextStyles.list1Regular(
                                      AppColors.base2),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    data['desc']!,
                                    style: AppTextStyles.list1Regular(
                                        AppColors.base2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/medical_record.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.base3, thickness: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}
