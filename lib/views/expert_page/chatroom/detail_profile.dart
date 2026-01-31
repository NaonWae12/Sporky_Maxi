import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_in_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/profile_cmp/in_expert/child_profile_in_box.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/chatroom/chating_page.dart';

import '../../../components/globals/dialog/badge_tooltip.dart';
import '../../../components/globals/dialog/child_profile_in_expert.dart';
import '../../profile/child_profile/page_child_profile_in_expert.dart';

class DetailProfile extends StatelessWidget {
  final String childUuid;
  const DetailProfile({
    super.key,
    required this.childUuid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            TopBarParentInExpertCmp(
              parentName: 'Alicia Azzahra',
              childName: 'Thalia Amara',
              isActive: true,
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            )
          ],
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            lineColor: AppColors.base1,
            imageColor: AppColors.base1,
            imageAsset: 'assets/svg/ic_warn.svg',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sesi Konsultasi Chat belum dimulai',
                    style: AppTextStyles.list1Bold()),
                Text(
                    'Klik tombol “Mulai Konsultasi” sesuai jadwal. Cek profil anak untuk pahami kondisinya.',
                    style: AppTextStyles.list1Regular()),
              ],
            ),
          ),
          ChildProfileInBox(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ChildProfileInExpert(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageChildProfileInExpert(
                                      childUuid: childUuid,
                                    )));
                      },
                    ),
                  ),
                ),
              );
            },
            isAsset: true,
            photoUrl: 'assets/temp_img/kids.png',
            childName: 'Thalia Amara',
            ageMonth: 4,
            ageYear: 1,
            status: 'Normal',
            step: TooltipStep.awal,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GlobalsButton(
          color: AppColors.secondary1,
          text: 'Mulai Sesi',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatingPage(),
                ));
          },
        ),
      ),
    );
  }
}
