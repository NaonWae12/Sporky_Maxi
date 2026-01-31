import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class TopBarParentInExpertCmp extends StatelessWidget {
  final String parentName;
  final String childName;
  final String? photoUrl;
  final bool isAsset;
  final bool isActive;
  const TopBarParentInExpertCmp({
    super.key,
    required this.parentName,
    required this.childName,
    this.photoUrl,
    this.isAsset = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(parentName, style: AppTextStyles.heading2SemiBold()),
                GlobalsCard(
                    hasShadow: false,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    backgroundColor: AppColors.base4,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/ic_bear_child.svg',
                          height: 15,
                          width: 15,
                          colorFilter: ColorFilter.mode(
                              AppColors.base1, BlendMode.srcIn),
                        ),
                        Text(
                          'Anak : $childName',
                          style: AppTextStyles.lable3Medium(),
                        )
                      ],
                    ))
              ],
            ),
            Stack(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: photoUrl != null
                        ? Image(
                            image: isAsset
                                ? AssetImage(photoUrl!) as ImageProvider
                                : NetworkImage(photoUrl!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.base2,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.base2,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.success1 : AppColors.base2,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.base5, width: 2),
                    ),
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
