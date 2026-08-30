import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';

import '../text/text_style.dart';

class DialogAlert {
  static Future<void> show({
    required BuildContext context,
    final String? title,
    final TextStyle? titleStyle,
    final TextStyle? messageStyle,
    final String? message,
    final Widget? child,
    final Widget? customChild,
    final String? confirmText,
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return SporkyDialog(
          actions: confirmText != null
              ? [
                  SporkyDialogAction(
                    label: confirmText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    isPrimary: true,
                  ),
                ]
              : const [],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style:
                      titleStyle ??
                      AppTextStyles.heading2SemiBold(AppColors.base1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
              ],
              child ??
                  customChild ??
                  (message != null
                      ? Text(
                          message,
                          style:
                              messageStyle ??
                              AppTextStyles.list1Regular(Colors.black87),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox()),
            ],
          ),
        );
      },
    );
  }
}

class Content1 extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String image;
  final VoidCallback onPressed;
  final String iconAsset;
  final String textNav;
  final TextStyle? textNavStyle;
  final String message;
  final TextStyle? messageStyle;
  final TextAlign textAlign;
  final EdgeInsets textPadding;
  final Color colorButton;
  const Content1({
    super.key,
    required this.title,
    this.titleStyle,
    this.image = 'assets/giff/gif1.gif',
    required this.onPressed,
    this.iconAsset = 'assets/svg/home-rounded.svg',
    required this.textNav,
    this.textNavStyle,
    required this.message,
    this.messageStyle,
    this.textAlign = TextAlign.justify,
    this.textPadding = const EdgeInsets.symmetric(vertical: 8),
    this.colorButton = AppColors.primary1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ),
        Text(title, style: titleStyle ?? AppTextStyles.headList1Bold()),
        Image.asset(height: 200, image),
        Padding(
          padding: textPadding,
          child: Text(
            message,
            style: messageStyle ?? AppTextStyles.list1Regular(),
            textAlign: textAlign,
          ),
        ),
        GlobalsButton(
          color: colorButton,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                height: 20,
                width: 20,
                iconAsset,
                colorFilter: ColorFilter.mode(AppColors.base5, BlendMode.srcIn),
              ),
              const SizedBox(width: 5),
              Text(
                textNav,
                style:
                    textNavStyle ??
                    AppTextStyles.headList1Bold(AppColors.base5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
