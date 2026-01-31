import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import 'chip_selector_display_with_focus.dart';

class ChipSelectorFormField extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedItems;
  final void Function(List<String>) onChanged;
  final double? height;
  final String hint;

  const ChipSelectorFormField({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
    this.height,
    this.hint = "Pilih atau tambahkan manual",
  });

  @override
  State<ChipSelectorFormField> createState() => _ChipSelectorFormFieldState();
}

class _ChipSelectorFormFieldState extends State<ChipSelectorFormField> {
  late List<String> _allOptions;

  @override
  void initState() {
    super.initState();
    // Inisialisasi local state dari props awal
    _allOptions = [...widget.options];
  }

  void _openSelectionDialog() {
    final TextEditingController manualInputController = TextEditingController();
    List<String> tempSelected = [...widget.selectedItems];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: AppColors.base5,
              title: Text(
                "Pilih ${widget.label}",
                style: AppTextStyles.heading1SemiBold(),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allOptions.map((option) {
                        final isSelected = tempSelected.contains(option);
                        return FilterChip(
                          label: Text(
                            option,
                            style: AppTextStyles.lable3Medium(),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                tempSelected.add(option);
                              } else {
                                tempSelected.remove(option);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: manualInputController,
                      style: AppTextStyles.heading3Medium(),
                      decoration: InputDecoration(
                        labelText: "Tambahkan manual",
                        labelStyle:
                            AppTextStyles.heading3Medium(AppColors.base2),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      ),
                      onSubmitted: (value) {
                        final input = value.trim();
                        if (input.isNotEmpty && !_allOptions.contains(input)) {
                          setModalState(() {
                            _allOptions.add(input);
                            tempSelected.add(input);
                            manualInputController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Batal",
                    style: AppTextStyles.heading3Medium(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // simpan ke parent
                      widget.onChanged(tempSelected);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Simpan",
                    style: AppTextStyles.heading3Medium(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _openSelectionDialog,
        child: ChipSelectorDisplayWithFocus(
          hint: widget.hint,
          selectedItems: widget.selectedItems,
          onTap: _openSelectionDialog,
        ));
  }
}
