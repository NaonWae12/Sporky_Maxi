import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/core/utils/profile_photo_resolver.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final Color backgroundColor;
  final String fallbackAsset;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.size = 50,
    this.backgroundColor = AppColors.primary2,
    this.fallbackAsset = 'assets/temp_img/kids.png',
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPhoto = ProfilePhotoResolver.resolve(photoUrl);
    final imageSize = size;

    return CircleAvatar(
      radius: imageSize / 2,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: SizedBox(
          height: imageSize,
          width: imageSize,
          child: _buildImage(resolvedPhoto),
        ),
      ),
    );
  }

  Widget _buildImage(String? resolvedPhoto) {
    if (resolvedPhoto == null || resolvedPhoto.isEmpty) {
      return Image.asset(fallbackAsset, fit: BoxFit.cover);
    }

    if (resolvedPhoto.startsWith('assets/')) {
      return Image.asset(
        resolvedPhoto,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, fit: BoxFit.cover),
      );
    }

    return Image.network(
      resolvedPhoto,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Image.asset(fallbackAsset, fit: BoxFit.cover),
    );
  }
}
