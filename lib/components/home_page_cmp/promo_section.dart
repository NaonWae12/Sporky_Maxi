import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../globals/card/flexible_ad_container.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            FlexibleAdContainer(
              child: Text('Ads', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Ads', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Ads', style: AppTextStyles.heading3SemiBold()),
            ),
            FlexibleAdContainer(
              child: Text('Ads', style: AppTextStyles.heading3SemiBold()),
            ),
          ],
        ),
      ),
    );
  }
}
