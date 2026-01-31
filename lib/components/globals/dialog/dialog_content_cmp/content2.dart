import 'package:flutter/material.dart';

import '../../button/globals_button.dart';
import '../../colors/colors.dart';
import '../../text/text_style.dart';

class Content2 extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String image;
  final VoidCallback onPressedRight;
  final VoidCallback onPressedLeft;
  final String textNavRight;
  final String textNavLeft;
  final TextStyle? textNavStyle;
  final String message;
  final TextStyle? messageStyle;
  final TextAlign textAlign;
  final EdgeInsets textPadding;
  final Color buttonCollorRight;
  final Color buttonCollorLeft;
  const Content2({
    super.key,
    required this.title,
    this.titleStyle,
    this.image = 'assets/giff/gif2.gif',
    required this.onPressedRight,
    required this.onPressedLeft,
    required this.textNavRight,
    required this.textNavLeft,
    this.textNavStyle,
    required this.message,
    this.messageStyle,
    this.textAlign = TextAlign.justify,
    this.textPadding = const EdgeInsets.symmetric(vertical: 8),
    this.buttonCollorRight = AppColors.warn1,
    this.buttonCollorLeft = AppColors.secondary1,
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
              icon: Icon(Icons.close)),
        ),
        Text(
          title,
          style: titleStyle ?? AppTextStyles.headList1Bold(),
        ),
        Image.asset(height: 200, image),
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
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    textNavLeft,
                    style: textNavStyle ??
                        AppTextStyles.headList1Bold(AppColors.base5),
                  )),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: GlobalsButton(
                  color: buttonCollorRight,
                  onPressed: onPressedRight,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    textNavRight,
                    style: textNavStyle ??
                        AppTextStyles.headList1Bold(AppColors.base5),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
