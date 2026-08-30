import 'package:flutter/material.dart';

import '../colors/colors.dart';

class GlobalsBottomSheet {
  static const Radius topRadius = Radius.circular(20);
  static const double handleHeight = 2;
  static const double handleWidthFactor = 0.2;
  static const EdgeInsets defaultPadding = EdgeInsets.fromLTRB(16, 12, 16, 16);

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    bool showHandle = true,
    EdgeInsets padding = defaultPadding,
  }) {
    return showAppBottomSheet<T>(
      context: context,
      child: child,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      height: height,
      showHandle: showHandle,
      padding: padding,
    );
  }
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  double? height,
  bool showHandle = true,
  EdgeInsets padding = GlobalsBottomSheet.defaultPadding,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: GlobalsBottomSheet.topRadius),
    ),
    builder: (context) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: AppColors.base5,
            borderRadius: BorderRadius.vertical(
              top: GlobalsBottomSheet.topRadius,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showHandle) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        color: AppColors.base3,
                        height: GlobalsBottomSheet.handleHeight,
                        width:
                            MediaQuery.of(context).size.width *
                            GlobalsBottomSheet.handleWidthFactor,
                      ),
                    ),
                  ],
                  Flexible(
                    child: Padding(padding: padding, child: child),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
