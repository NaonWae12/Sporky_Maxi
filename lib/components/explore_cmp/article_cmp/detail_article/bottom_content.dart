import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';

import '../../../globals/card/globals_card.dart';
import '../../../globals/colors/colors.dart';
import '../../../globals/text/text_style.dart';

class BottomContent extends StatelessWidget {
  final String title;
  final String description;

  const BottomContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base4,
      hasShadow: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul + gambar bulat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        'assets/svg/compass-rounded.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(title, style: AppTextStyles.heading3SemiBold()),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Text(description, style: AppTextStyles.list1Regular()),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: GlobalsButton(
                    elevation: 0,
                    height: 35,
                    color: AppColors.primary1,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/ic_ play.svg"),
                        Text(
                          "Lihat Video",
                          style: AppTextStyles.headList1Bold(),
                        ),
                      ],
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini belum tersedia"),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: GlobalsButton(
                    elevation: 0,
                    height: 35,
                    color: AppColors.secondary1,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/ic_ doctor.svg"),
                        const SizedBox(width: 5),
                        Text(
                          "Konsultasi",
                          style: AppTextStyles.headList1Bold(),
                        ),
                      ],
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini belum tersedia"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
