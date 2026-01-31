import 'package:flutter/material.dart';

import '../globals/card/flexible_ad_container.dart';
import '../globals/text/text_style.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            FlexibleAdContainer(
              child: Text('Video', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Video', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Video', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Video', style: AppTextStyles.heading3SemiBold()),
            ),
          ],
        ),
      ),
    );
  }
}
