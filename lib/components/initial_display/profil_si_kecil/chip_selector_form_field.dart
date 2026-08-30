import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
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

    void addManualInput(StateSetter setModalState) {
      final input = manualInputController.text.trim();
      if (input.isEmpty) return;

      setModalState(() {
        if (!_allOptions.contains(input)) {
          _allOptions.add(input);
        }
        if (!tempSelected.contains(input)) {
          tempSelected.add(input);
        }
        manualInputController.clear();
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SporkyDialog(
              title: "Pilih ${widget.label}",
              actions: [
                SporkyDialogAction(
                  label: "Batal",
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SporkyDialogAction(
                  label: "Simpan",
                  onPressed: () {
                    setState(() {
                      // simpan ke parent
                      widget.onChanged(tempSelected);
                    });
                    Navigator.of(context).pop();
                  },
                  isPrimary: true,
                ),
              ],
              child: SingleChildScrollView(
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
                      decoration: SporkyDialog.inputDecoration(
                        labelText: "Tambahkan manual",
                        suffixIcon: IconButton(
                          tooltip: "Tambah manual",
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.primary1,
                          onPressed: () => addManualInput(setModalState),
                        ),
                      ),
                      onSubmitted: (_) => addManualInput(setModalState),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
