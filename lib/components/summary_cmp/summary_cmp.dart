import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/cms_html_cmp.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../globals/text/html_data.dart';

class SummaryCmp extends StatefulWidget {
  const SummaryCmp({super.key});

  @override
  State<SummaryCmp> createState() => _SummaryCmpFormState();
}

class _SummaryCmpFormState extends State<SummaryCmp> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;

  final htmlData = HtmlData();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GlobalsCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded1 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded1 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/ic_ growth.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.primary1, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text('Ringkasan', style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded1 = !isExpanded1;
                  });
                },
                icon: Icon(
                  isExpanded1
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),

        // tampilkan CmpTagAttention jika isExpanded1 true
        if (isExpanded1) ...[
          GlobalsCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: AppColors.base5,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              height: 94,
              child: CmsHtmlContent(htmlData: htmlData.summary))
        ],
        // pilihan kedua
        const SizedBox(height: 20),
        GlobalsCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded2 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded2 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/ic_list.svg'),
                  const SizedBox(width: 8),
                  Text('Saran Untuk Orangtua',
                      style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded2 = !isExpanded2;
                  });
                },
                icon: Icon(
                  isExpanded2
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),

        // tampilkan CmpTagAttention jika isExpanded1 true
        if (isExpanded2) ...[
          GlobalsCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: AppColors.base5,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              height: 130,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CmsHtmlContent(htmlData: htmlData.parrentAdivce),
              ))
        ],
      ],
    );
  }
}
