import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PackagesAndCouponsList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PackagesAndCouponsList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/svg/ic_list.svg',
                height: 24,
                width: 24,
                colorFilter:
                    const ColorFilter.mode(AppColors.base1, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(
                'Paket & Kupon Anda',
                style: AppTextStyles.heading3SemiBold(),
              ),
            ],
          ),
        ),

        // Tag attention
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CmpTagAttention(
            wrapText: 1.25,
            sizeImage: 24,
            imageColor: AppColors.base1,
            text:
                'Paket langganan Bunda masih aktif. Yuk, cek 2 kupon konsultasi yang bisa langsung digunakan hari ini!',
            imageAsset: 'assets/svg/sun.svg',
            lineColor: AppColors.secondary3,
          ),
        ),

        // Horizontal list of cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: List.generate(data.length, (index) {
              final item = data[index];
              return PackagesAndCoupons(
                title: item['title'],
                name: item['name'],
                badgeImg: item['badgeImg'],
                validUntil: item['validUntil'],
                expertGroup: item['expertGroup'] ?? false,
                imageColor: item['imageColor'],
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// main widget
class PackagesAndCoupons extends StatelessWidget {
  final String validUntil;
  final String name;
  final String badgeImg;
  final Color? imageColor;
  final String title;
  final bool expertGroup;

  const PackagesAndCoupons({
    super.key,
    this.validUntil = '-',
    required this.name,
    required this.badgeImg,
    required this.title,
    this.expertGroup = false,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      gradient: expertGroup
          ? LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                AppColors.secondary2.withValues(alpha: 0.6 * 255.round()),
                const Color(0xCCF3F3F3).withValues(alpha: 0.8 * 255.round()),
                const Color(0x80FFFAE1)..withValues(alpha: 0.5 * 255.round()),
              ],
            )
          : null,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 200,
      height: 115,
      backgroundColor: AppColors.base4,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  height: 18,
                  width: 18,
                  badgeImg,
                  colorFilter: imageColor != null
                      ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                      : null,
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 130,
                  child: Text(
                    title,
                    style: AppTextStyles.heading3SemiBold(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Nama
          GlobalsCard(
            height: 19,
            margin: const EdgeInsets.only(left: 8),
            hasShadow: false,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            backgroundColor: AppColors.primary1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/ic_bear_child.svg',
                  height: 10,
                  width: 10,
                  colorFilter:
                      const ColorFilter.mode(AppColors.base5, BlendMode.srcIn),
                ),
                const SizedBox(width: 3),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    name,
                    style: AppTextStyles.list3SemiBold(AppColors.base5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 5),

          // Valid until
          GlobalsCard(
            height: 22,
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            hasShadow: false,
            backgroundColor: AppColors.base5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/ic_ calendar - schedule.svg',
                  height: 12,
                  width: 12,
                ),
                const SizedBox(width: 5),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.list3Regular(),
                    children: [
                      const TextSpan(text: 'berlaku hingga '),
                      TextSpan(
                        text: validUntil,
                        style: AppTextStyles.list3Bold(),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
