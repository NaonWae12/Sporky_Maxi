import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile.dart';

import '../../components/globals/text/text_style.dart';
import 'page_setting_profile/page_setting_parent_profile.dart';

class ParentProfile extends StatelessWidget {
  const ParentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Profil Orangtua',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CmpParentProfile(
              directToEditPage: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageSettingParentProfile(),
                    ));
              },
              name: 'Alicia Azzahra',
              countNotif: 5,
              badgeImg: 'assets/health_badge.png',
            )
          ],
        ),
      ),
    );
  }
}
