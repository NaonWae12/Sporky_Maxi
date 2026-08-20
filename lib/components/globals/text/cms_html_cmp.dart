import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'text_style.dart';

class CmsHtmlContent extends StatelessWidget {
  final String htmlData;

  const CmsHtmlContent({super.key, required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        // Heading 1 dan 2 pakai heading3Regular, biar konsisten typography lu
        "h1": Style.fromTextStyle(AppTextStyles.heading3Regular()),
        "h2": Style.fromTextStyle(AppTextStyles.lable2Regular()),

        // Paragraf dan list pakai list1Regular
        "p": Style.fromTextStyle(AppTextStyles.list1Regular()),
        "li": Style.fromTextStyle(AppTextStyles.list1Regular()),

        // Bullet list indent (ul) biar njorok ke dalam
        "ul": Style(
          margin: Margins.only(left: 16),
          padding: HtmlPaddings.all(0),
        ),

        // Bold text (strong/b) pakai Bold
        "strong": Style(fontWeight: FontWeight.bold),
        "b": Style(fontWeight: FontWeight.bold),
      },
    );
  }
}
