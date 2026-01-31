// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../globals/card/cmp_tag_category.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/cms_html_cmp.dart';
import '../../globals/text/html_data.dart';

class MiddleContentMeal extends StatelessWidget {
  const MiddleContentMeal({super.key});

  @override
  Widget build(BuildContext context) {
    final htmlData = HtmlData();
    return Column(
      children: [
        const CmpTagCategory(
            textAndImageColor: AppColors.primary1,
            text: 'Bahan - Bahan',
            imageAsset: 'assets/svg/bento-box-rounded.svg'),
        _DetailText(textData: htmlData.ingredients),
        const CmpTagCategory(
            textAndImageColor: AppColors.primary1,
            text: 'Langkah - Langkah Memasak',
            imageAsset: 'assets/svg/bento-box-rounded.svg'),
        _DetailText(textData: htmlData.stepByStep),
      ],
    );
  }
}

class _DetailText extends StatelessWidget {
  final String textData;
  const _DetailText({
    required this.textData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 8),
      child: CmsHtmlContent(htmlData: textData),
    );
  }
}
