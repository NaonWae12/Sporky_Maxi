import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'text_style.dart';

class CmsHtmlContent extends StatelessWidget {
  final String htmlData;

  const CmsHtmlContent({super.key, required this.htmlData});

  /// Heading: Baloo2 bold, ukuran menurun mengikuti skala CKEditor di Laravel
  /// (heading 1 = 20px, heading 2 = 17px, heading 3 = 14px).
  TextStyle _heading(double size) {
    return AppTextStyles.heading2SemiBold().copyWith(
      fontSize: size,
      fontWeight: FontWeight.w700,
    );
  }

  /// Body: Roboto 16px (fs-6 di Laravel) dengan line-height longgar mendekati
  /// lh-lg agar nyaman dibaca.
  TextStyle _body() {
    return AppTextStyles.headList1Regular().copyWith(height: 1.6);
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        'h1': Style.fromTextStyle(_heading(22)),
        'h2': Style.fromTextStyle(_heading(20)),
        'h3': Style.fromTextStyle(_heading(17)),
        'h4': Style.fromTextStyle(_heading(14)),
        'h5': Style.fromTextStyle(_heading(14)),
        'h6': Style.fromTextStyle(_heading(13)),

        'p': Style.fromTextStyle(_body()),
        'li': Style.fromTextStyle(_body()),

        // Indentasi list bullet & angka.
        'ul': Style(
          margin: Margins.only(left: 16),
          padding: HtmlPaddings.all(0),
        ),
        'ol': Style(
          margin: Margins.only(left: 16),
          padding: HtmlPaddings.all(0),
        ),

        // Bold.
        'strong': Style(fontWeight: FontWeight.w700),
        'b': Style(fontWeight: FontWeight.w700),

        // Italic.
        'em': Style(fontStyle: FontStyle.italic),
        'i': Style(fontStyle: FontStyle.italic),

        // Underline.
        'u': Style(textDecoration: TextDecoration.underline),
        'ins': Style(textDecoration: TextDecoration.underline),

        // Strikethrough.
        's': Style(textDecoration: TextDecoration.lineThrough),
        'strike': Style(textDecoration: TextDecoration.lineThrough),
        'del': Style(textDecoration: TextDecoration.lineThrough),

        // Blockquote: border kiri + italic, meniru tampilan CKEditor.
        'blockquote': Style(
          border: const Border(
            left: BorderSide(color: Color(0xFFCCCCCC), width: 5),
          ),
          padding: HtmlPaddings.only(left: 24, top: 8, bottom: 8),
          margin: Margins.only(top: 8, bottom: 8),
          fontStyle: FontStyle.italic,
        ),
      },
    );
  }
}
