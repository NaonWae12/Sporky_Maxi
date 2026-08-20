import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../button/globals_button.dart';
import '../../colors/colors.dart';
import '../../text/text_style.dart';

class Content2 extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String image;
  final VoidCallback onPressedRight;
  final VoidCallback onPressedLeft;
  final void Function(BuildContext context)? onClose;

  final String textNavRight;
  final String textNavLeft;
  final TextStyle? textNavStyle;
  final String message;
  final TextStyle? messageStyle;
  final TextAlign textAlign;
  final EdgeInsets textPadding;
  final Color buttonCollorRight;
  final Color buttonCollorLeft;
  final String? iconAssetRight;
  final String? iconAssetLeft;
  final double texRightWidth;
  final double texLeftWidth;

  const Content2({
    super.key,
    required this.title,
    this.titleStyle,
    this.image = 'assets/giff/gif2.gif',
    required this.onPressedRight,
    required this.onPressedLeft,
    this.onClose,
    required this.textNavRight,
    required this.textNavLeft,
    this.textNavStyle,
    required this.message,
    this.messageStyle,
    this.textAlign = TextAlign.justify,
    this.textPadding = const EdgeInsets.symmetric(vertical: 8),
    this.buttonCollorRight = AppColors.warn1,
    this.buttonCollorLeft = AppColors.secondary1,
    this.iconAssetRight,
    this.iconAssetLeft,
    this.texRightWidth = 4.8,
    this.texLeftWidth = 4.8,
  });

  /// 🔥 Helper icon builder (SVG / PNG / JPG)
  Widget _buildIcon(String asset) {
    final isSvg = asset.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.asset(
        asset,
        height: 20,
        width: 20,
        colorFilter: const ColorFilter.mode(
          AppColors.base5,
          BlendMode.srcIn,
        ),
      );
    }

    return Image.asset(
      asset,
      height: 20,
      width: 20,
      color: AppColors.base5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              if (onClose != null) {
                onClose!(context);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.close),
          ),
        ),
        Text(
          title,
          style: titleStyle ?? AppTextStyles.headList1Bold(),
        ),
        Image.asset(
          image,
          height: 200,
        ),
        Padding(
          padding: textPadding,
          child: Text(
            message,
            style: messageStyle ?? AppTextStyles.list1Regular(),
            textAlign: textAlign,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GlobalsButton(
                color: buttonCollorLeft,
                onPressed: onPressedLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconAssetLeft != null) ...[
                      _buildIcon(iconAssetLeft!),
                      const SizedBox(width: 5),
                    ],
                    SizedBox(
                      width: MediaQuery.of(context).size.width / texLeftWidth,
                      child: Text(
                        textNavLeft,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textNavStyle ??
                            AppTextStyles.headList1Bold(AppColors.base5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: GlobalsButton(
                color: buttonCollorRight,
                onPressed: onPressedRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconAssetRight != null) ...[
                      _buildIcon(iconAssetRight!),
                      const SizedBox(width: 5),
                    ],
                    SizedBox(
                      width: MediaQuery.of(context).size.width / texRightWidth,
                      child: Text(
                        textNavRight,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: textNavStyle ??
                            AppTextStyles.headList1Bold(AppColors.base5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
