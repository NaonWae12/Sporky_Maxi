import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../globals/colors/colors.dart';

class EditProfileCmp extends StatelessWidget {
  final String? photoUrl;
  final String? localPhotoPath;
  final bool isAsset;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const EditProfileCmp({
    super.key,
    this.photoUrl,
    this.localPhotoPath,
    this.isAsset = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.onTap,
  });

  ImageProvider? get _imageProvider {
    final localPath = localPhotoPath?.trim() ?? '';
    if (localPath.isNotEmpty) return FileImage(File(localPath));

    final photo = photoUrl?.trim() ?? '';
    if (photo.isEmpty) return null;
    if (isAsset || photo.startsWith('assets/')) return AssetImage(photo);
    return NetworkImage(photo);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            ClipOval(
              child: SizedBox(
                width: 100,
                height: 100,
                child: _imageProvider != null
                    ? Image(
                        image: _imageProvider!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
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
                  colorFilter: const ColorFilter.mode(
                    AppColors.base5,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
