import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

class CmpFloatingActionButton extends StatelessWidget {
  final double size;
  final String imagePath;
  final BoxFit fit;
  final VoidCallback? onTap;
  final Color? imageColor;

  const CmpFloatingActionButton({
    super.key,
    this.size = 60,
    required this.imagePath,
    this.fit = BoxFit.contain,
    this.onTap,
    this.imageColor,
  });
  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: _ChatBubbleClipper(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: AppColors.base5,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              border: Border.all(color: AppColors.primary1)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _isSvg
                ? SvgPicture.asset(
                    imagePath,
                    fit: fit,
                    colorFilter: imageColor != null
                        ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                        : null,
                  )
                : Image.asset(
                    imagePath,
                    fit: fit,
                    color: imageColor,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double radius = size.width * 0.3;

    // Mulai dari sudut kiri atas (dengan rounded)
    path.moveTo(radius, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
