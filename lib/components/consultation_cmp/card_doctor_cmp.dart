import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';

import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';

import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class CardDoctorCmp extends StatelessWidget {
  final String categoryType;
  final String imagePath;
  final String doctorName;
  final String starCount;
  final String skill;
  final VoidCallback? buyTicket;
  final VoidCallback? onTap;
  final bool hasBadge;
  final bool isFullSchedule;

  const CardDoctorCmp({
    super.key,
    required this.categoryType,
    required this.imagePath,
    required this.doctorName,
    required this.starCount,
    required this.skill,
    this.buyTicket,
    this.onTap,
    this.hasBadge = false,
    this.isFullSchedule = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: GestureDetector(
        onTap: isFullSchedule ? null : onTap,
        child: Stack(
          children: [
            Opacity(
              opacity: isFullSchedule ? 0.5 : 1.0,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.base2),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.base5,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.base1.withAlpha(120),
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Gambar
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: _buildImage(),
                            ),
                          ),
                          // Label atas
                          Positioned(
                            top: 10,
                            left: 5,
                            child: Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 76,
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .base5, // background putih flat
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getBorderColor(categoryType),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categoryType,
                                      style: AppTextStyles.list3SemiBold(
                                          _getBorderColor(categoryType)),
                                    ),
                                  ),
                                ),
                                if (hasBadge)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Container(
                                      height: 16,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.base5,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primary1,
                                        ),
                                      ),
                                      child: SizedBox(
                                          height: 10,
                                          width: 12,
                                          child: SvgPicture.asset(
                                              'assets/svg/Crown-1.svg')),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: Text(doctorName,
                                style: AppTextStyles.lable3SemiBold(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          GlobalsCardOutlined(
                            height: 14,
                            borderColor: AppColors.warn1,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.warn1,
                                  size: 10,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  starCount,
                                  style: AppTextStyles.list3SemiBold(
                                      AppColors.warn1),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(skill,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.list3Regular(AppColors.base2)),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
                        child: GlobalsButton(
                          color: AppColors.secondary1,
                          height: 22,
                          width: MediaQuery.of(context).size.width / 2,
                          onPressed: isFullSchedule ? null : buyTicket,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/svg/ic_coupon - ticket.svg'),
                              const SizedBox(width: 5),
                              Text(
                                'Beli Tiket',
                                style: AppTextStyles.list1Bold(AppColors.base5),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (isFullSchedule)
              Positioned(
                top: 90,
                left: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.base5,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.base1.withAlpha(120),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 12,
                          width: 12,
                          child: SvgPicture.asset(
                              'assets/svg/ic_ calendar - schedule.svg')),
                      const SizedBox(width: 5),
                      Text(
                        "Jadwal Penuh",
                        style: AppTextStyles.list3SemiBold(Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    const double width = 138;
    const double height = 170;

    Widget errorWidget = Container(
      width: width,
      height: height,
      color: AppColors.base3,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image,
        color: AppColors.base2,
        size: 28,
      ),
    );

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.base3,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) => errorWidget,
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => errorWidget,
      );
    }
  }
}

Color _getBorderColor(String category) {
  switch (category.toLowerCase()) {
    case "ahli gizi":
      return AppColors.primary1;
    case "dokter":
      return AppColors.secondary2;
    default:
      return AppColors.base1; // fallback: abu2 kalau gak dikenal
  }
}
