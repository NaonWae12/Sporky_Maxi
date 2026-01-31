import 'package:flutter/material.dart';

import '../../../components/globals/text/text_style.dart';
import '../../../components/profile_content/cmp_setting_profile/cmp_changes_photo_profile.dart';
import '../../../components/profile_content/cmp_setting_profile/cmp_setting_child_profile/form_setting_child_profile.dart';

class PageSettingChildProfile extends StatelessWidget {
  const PageSettingChildProfile({super.key});

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
              'Setting Profil Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [CmpChangesPhotoProfile(), FormSettingChildProfile()],
        ),
      ),
    );
  }
}
