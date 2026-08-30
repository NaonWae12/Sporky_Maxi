import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../globals/colors/colors.dart';

class CmpChangesPhotoProfile extends StatelessWidget {
  final EdgeInsets padding;
  final String? photoUrl;
  final String? localPhotoPath;
  final VoidCallback? onTap;

  const CmpChangesPhotoProfile({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.photoUrl,
    this.localPhotoPath,
    this.onTap,
  });

  ImageProvider? get _imageProvider {
    final localPath = localPhotoPath?.trim() ?? '';
    if (localPath.isNotEmpty) return FileImage(File(localPath));

    final photo = photoUrl?.trim() ?? '';
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return NetworkImage(photo);
    }
    if (photo.startsWith('assets/')) return AssetImage(photo);

    return const AssetImage('assets/temp_img/kids.png');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 78,
                backgroundColor: AppColors.primary2,
                backgroundImage: _imageProvider,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary1,
                  child: SvgPicture.asset(
                    colorFilter: const ColorFilter.mode(
                      AppColors.base5,
                      BlendMode.srcIn,
                    ),
                    'assets/svg/ic_edit.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
