import 'package:flutter/material.dart';

import '../../../globals/text/cms_html_cmp.dart';
import '../../../globals/text/html_data.dart';

class TeksArticleCmp extends StatelessWidget {
  final String? content;

  const TeksArticleCmp({super.key, this.content});

  String _toHtmlContent() {
    final raw = content?.trim();
    if (raw == null || raw.isEmpty) {
      final htmlData = HtmlData();
      return htmlData.example1HtmlData;
    }

    final hasHtmlTag = RegExp(r'<[^>]+>').hasMatch(raw);
    if (hasHtmlTag) {
      return raw;
    }

    final escapedText = raw
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
    final formattedText = escapedText
        .replaceAll('\r\n', '<br><br>')
        .replaceAll('\n', '<br><br>');

    return '<p>$formattedText</p>';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CmsHtmlContent(htmlData: _toHtmlContent()),
        ),
      ],
    );
  }
}
