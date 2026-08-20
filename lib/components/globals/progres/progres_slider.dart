import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ProgressSlider extends StatefulWidget {
  final String label;
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Color textColor;
  final bool isInteractive;
  final ValueChanged<double>? onChanged;
  final int? divisions;
  final bool showPercentageLabel;

  const ProgressSlider({
    super.key,
    required this.label,
    required this.percentage,
    this.activeColor = AppColors.secondary1,
    this.inactiveColor = AppColors.base3,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.textStyle,
    this.textColor = AppColors.secondary1,
    this.isInteractive = true,
    this.onChanged,
    this.divisions = 100,
    this.showPercentageLabel = true,
  });

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  late double _currentPercentage;

  @override
  void initState() {
    super.initState();
    _currentPercentage = widget.percentage.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant ProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percentage != oldWidget.percentage) {
      _currentPercentage = widget.percentage.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedValue = widget.onChanged != null
        ? widget.percentage.clamp(0.0, 1.0)
        : _currentPercentage;
    final percentText = '${(displayedValue * 100).round()}%';

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '*${widget.label}',
                style: widget.textStyle ??
                    AppTextStyles.list3Regular(widget.textColor),
              ),
              if (widget.showPercentageLabel)
                Text(
                  percentText,
                  style:
                      widget.textStyle ?? AppTextStyles.list3Regular(widget.textColor),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              activeTrackColor: widget.activeColor,
              inactiveTrackColor: widget.inactiveColor,
              thumbColor: widget.activeColor,
              overlayColor: widget.activeColor.withAlpha(40),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              trackShape: const RoundedRectSliderTrackShape(),
              showValueIndicator: ShowValueIndicator.onlyForDiscrete,
              valueIndicatorColor: widget.activeColor,
              valueIndicatorTextStyle:
                  AppTextStyles.list3Regular(AppColors.base5),
            ),
            child: Slider(
              min: 0,
              max: 1,
              divisions: widget.divisions,
              label: percentText,
              value: displayedValue,
              onChanged: widget.isInteractive
                  ? (value) {
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      } else {
                        setState(() {
                          _currentPercentage = value;
                        });
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: AppTextStyles.list1Regular(AppColors.base2)),
              Text('50%', style: AppTextStyles.list1Regular(AppColors.base2)),
              Text('100%', style: AppTextStyles.list1Regular(AppColors.base2)),
            ],
          ),
        ],
      ),
    );
  }
}
