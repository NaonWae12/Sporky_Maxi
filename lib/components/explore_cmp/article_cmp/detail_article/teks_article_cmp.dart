import 'package:flutter/material.dart';

import '../../../globals/text/cms_html_cmp.dart';
import '../../../globals/text/html_data.dart';

class TeksArticleCmp extends StatelessWidget {
  const TeksArticleCmp({super.key});

  @override
  Widget build(BuildContext context) {
    final htmlData = HtmlData(); // instance dummy data lu

    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CmsHtmlContent(htmlData: htmlData.example1HtmlData),
        ),
      ],
    );
  }
}
