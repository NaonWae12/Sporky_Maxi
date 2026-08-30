import 'package:flutter/material.dart';

class GlobalsCard extends StatelessWidget {
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final bool hasShadow;
  final double radius;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;

  const GlobalsCard({
    super.key,
    this.backgroundColor,
    this.gradient,
    required this.child,
    this.onTap,
    this.padding,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.hasShadow = true,
    this.radius = 16,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: onTap == null
          ? HitTestBehavior.deferToChild
          : HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          border: border,
          boxShadow: hasShadow
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
