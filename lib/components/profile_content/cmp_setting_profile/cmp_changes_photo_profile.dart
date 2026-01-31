import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../globals/colors/colors.dart';

class CmpChangesPhotoProfile extends StatelessWidget {
  final EdgeInsets padding;

  const CmpChangesPhotoProfile(
      {super.key, this.padding = const EdgeInsets.symmetric(vertical: 10)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Stack(
          children: [
            const CircleAvatar(
              radius: 78,
              backgroundColor: AppColors.primary2,
              backgroundImage: AssetImage('assets/temp_img/kids.png'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary1,
                child: SvgPicture.asset(
                  colorFilter:
                      const ColorFilter.mode(AppColors.base5, BlendMode.srcIn),
                  'assets/svg/ic_edit.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
