import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class SporkyDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isLoading;

  const SporkyDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.isLoading = false,
  });
}

class SporkyDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? child;
  final Widget? icon;
  final List<SporkyDialogAction> actions;
  final bool showCloseButton;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const SporkyDialog({
    super.key,
    this.title,
    this.message,
    this.child,
    this.icon,
    this.actions = const [],
    this.showCloseButton = false,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 420,
  });

  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.base5,
      labelStyle: AppTextStyles.lable2Regular(AppColors.base2),
      hintStyle: AppTextStyles.lable2Regular(AppColors.base2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.base3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary1, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.warn4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.warn4, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.base5,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary1.withValues(alpha: 0.14),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showCloseButton)
                    Align(
                      alignment: Alignment.centerRight,
                      child: _CloseButton(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  if (icon != null) ...[
                    Center(child: icon!),
                    const SizedBox(height: 16),
                  ],
                  if (title != null) ...[
                    Text(
                      title!,
                      style: AppTextStyles.heading2SemiBold(AppColors.base1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (message != null) ...[
                    Text(
                      message!,
                      style: AppTextStyles.list1Regular(AppColors.base1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                  ],
                  if (child != null) child!,
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _DialogActions(actions: actions),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.base4,
          borderRadius: BorderRadius.circular(17),
        ),
        child: const Icon(Icons.close, size: 18, color: AppColors.base1),
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final List<SporkyDialogAction> actions;

  const _DialogActions({required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.length == 1) {
      return _ActionButton(action: actions.first);
    }

    if (actions.length == 2) {
      return Row(
        children: [
          Expanded(child: _ActionButton(action: actions.first)),
          const SizedBox(width: 12),
          Expanded(child: _ActionButton(action: actions.last)),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.end,
      children: actions.map((action) => _ActionButton(action: action)).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final SporkyDialogAction action;

  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final content = action.isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.base5),
            ),
          )
        : Text(
            action.label,
            style: AppTextStyles.heading3SemiBold(
              action.isPrimary ? AppColors.base5 : _outlineColor,
            ),
          );

    if (action.isPrimary) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: action.isLoading ? null : action.onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: action.isDestructive
                ? AppColors.warn4
                : AppColors.primary1,
            foregroundColor: AppColors.base5,
            disabledBackgroundColor: AppColors.base3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: content,
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: action.isLoading ? null : action.onPressed,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.base5,
          foregroundColor: _outlineColor,
          side: BorderSide(color: _outlineColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: content,
      ),
    );
  }

  Color get _outlineColor =>
      action.isDestructive ? AppColors.warn4 : AppColors.primary1;
}
