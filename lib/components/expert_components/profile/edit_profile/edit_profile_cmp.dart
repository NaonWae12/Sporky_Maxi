import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../globals/colors/colors.dart';

class EditProfileCmp extends StatelessWidget {
  final String? photoUrl;
  final bool isAsset;
  final EdgeInsets padding;

  const EditProfileCmp({
    super.key,
    this.photoUrl,
    this.isAsset = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox(
              width: 100,
              height: 100,
              child: photoUrl != null
                  ? Image(
                      image: isAsset
                          ? AssetImage(photoUrl!) as ImageProvider
                          : NetworkImage(photoUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 100,
                        color: AppColors.base2,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 100,
                      color: AppColors.base2,
                    ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primary2,
                  child: SvgPicture.asset(
                    'assets/svg/ic_edit.svg',
                    colorFilter:
                        ColorFilter.mode(AppColors.base5, BlendMode.srcIn),
                  ))),
        ],
      ),
    );
  }
}
