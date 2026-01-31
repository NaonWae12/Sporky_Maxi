import 'package:flutter/material.dart';

import '../globals/card/flexible_ad_container.dart';
import '../globals/text/text_style.dart';

class InsightSection extends StatelessWidget {
  const InsightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            FlexibleAdContainer(
              child: Text('Artikel', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Artikel', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Artikel', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Artikel', style: AppTextStyles.heading3SemiBold()),
            ),
          ],
        ),
      ),
    );
  }
}
