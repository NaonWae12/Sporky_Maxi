import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DateDropdownDismissController {
  static _DateDropdownFieldState? _activePicker;

  static void handlePointerDown(PointerDownEvent event) {
    _activePicker?._dismissIfTapOutside(event.position);
  }
}

class DateDropdownField extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;
  final double height;
  final TextEditingController? controller;
  final Widget? hint;

  const DateDropdownField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.label,
    this.height = 48,
    this.controller,
    this.hint,
  });

  @override
  State<DateDropdownField> createState() => _DateDropdownFieldState();
}

class _DateDropdownFieldState extends State<DateDropdownField> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final GlobalKey _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  late final TextEditingController controller;
  bool _shouldDisposeController = false;

  // 🔑 STATE TANGGAL AKTIF
  late DateTime _activeDate;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      controller = TextEditingController();
      _shouldDisposeController = true;
    } else {
      controller = widget.controller!;
    }

    _activeDate = widget.selectedDate ?? DateTime.now();
    controller.text = DateFormat('dd/MM/yyyy').format(_activeDate);
  }

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      DateDropdownDismissController._activePicker?._hideOverlay();
      _overlayEntry = _createOverlayEntry();
      DateDropdownDismissController._activePicker = this;
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _hideOverlay();
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (DateDropdownDismissController._activePicker == this) {
      DateDropdownDismissController._activePicker = null;
    }
  }

  void _dismissIfTapOutside(Offset position) {
    if (_containsGlobalPosition(_fieldKey, position) ||
        _containsGlobalPosition(_overlayKey, position)) {
      return;
    }

    _hideOverlay();
  }

  bool _containsGlobalPosition(GlobalKey key, Offset position) {
    final context = key.currentContext;
    final renderObject = context?.findRenderObject();

    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return false;
    }

    final offset = renderObject.localToGlobal(Offset.zero);
    return (offset & renderObject.size).contains(position);
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5),
          child: Material(
            key: _overlayKey,
            elevation: 4.0,
            color: AppColors.base5,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                  todayBackgroundColor: const WidgetStatePropertyAll(
                    AppColors.warn1,
                  ),
                  todayBorder: const BorderSide(color: AppColors.warn1),
                  dayStyle: AppTextStyles.calendar1Medium(),
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _activeDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(DateTime.now().year + 5),
                onDateChanged: (date) {
                  final bool isDaySelected = date.day != _activeDate.day;

                  setState(() {
                    _activeDate = date;
                    controller.text = DateFormat('dd/MM/yyyy').format(date);
                  });

                  widget.onDateSelected(date);

                  // ✅ dropdown nutup HANYA kalau user klik tanggal
                  if (isDaySelected) {
                    _hideOverlay();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();

    if (_shouldDisposeController) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      key: _fieldKey,
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: GlobalsForm(
          hint: widget.hint,
          onTap: _toggleOverlay,
          readOnly: true,
          controller: controller,
          label: widget.label,
          suffixSvgAsset: 'assets/svg/ic_ calendar - schedule.svg',
          suffixIconColor: AppColors.base2,
          suffixIconFocusedColor: AppColors.primary1,
          borderRadius: BorderRadius.circular(16),
          hasShadow: false,
          height: widget.height,
          contentPadding: const EdgeInsets.only(left: 10),
        ),
      ),
    );
  }
}
