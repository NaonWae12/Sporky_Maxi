import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';

import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class MealFormItem {
  final TextEditingController mealNameController;
  final TextEditingController portionsController;

  MealFormItem()
    : mealNameController = TextEditingController(),
      portionsController = TextEditingController();
}

class CmpAddMealForm extends StatefulWidget {
  final bool normalFill;
  final List<MealFormItem>? forms;
  final VoidCallback? onChanged;
  final ValueChanged<MealFormItem>? onItemAdded;
  final ValueChanged<int>? onItemRemoved;
  final bool enableAutoComplete;
  final List<String> autoCompleteOptions;
  final ValueChanged<String>? onAutoCompleteSelected;
  const CmpAddMealForm({
    super.key,
    this.normalFill = true,
    this.forms,
    this.onChanged,
    this.onItemAdded,
    this.onItemRemoved,
    this.enableAutoComplete = false,
    this.autoCompleteOptions = const [],
    this.onAutoCompleteSelected,
  });

  @override
  State<CmpAddMealForm> createState() => _CmpAddMealFormState();
}

class _CmpAddMealFormState extends State<CmpAddMealForm> {
  late final List<MealFormItem> _forms;
  late final bool _ownsForms;

  @override
  void initState() {
    super.initState();
    _ownsForms = widget.forms == null;
    _forms = widget.forms ?? <MealFormItem>[];
    if (_forms.isEmpty) {
      _forms.add(MealFormItem());
    }
    for (final item in _forms) {
      _attachListeners(item);
    }
  }

  @override
  void dispose() {
    if (_ownsForms) {
      for (final item in _forms) {
        item.mealNameController.dispose();
        item.portionsController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            for (int i = 0; i < _forms.length; i++) ...[
              _buildMealRow(_forms[i], context, i),
              if (i != _forms.length - 1) const SizedBox(height: 12),
            ],
            if (widget.normalFill)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GlobalsButton(
                  color: AppColors.primary3,
                  height: 44,
                  elevation: 0,
                  textColor: AppColors.secondary1,
                  onPressed: () {
                    setState(() {
                      final item = MealFormItem();
                      _forms.add(item);
                      _attachListeners(item);
                      widget.onItemAdded?.call(item);
                    });
                    widget.onChanged?.call();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: AppColors.secondary1,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: GlobalsButtonText(
                          text: 'Menu Lain',
                          style: AppTextStyles.headList1Bold(
                            AppColors.secondary1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// ROW FORM MAKANAN
  /// =======================
  Widget _buildMealRow(MealFormItem item, BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.base4),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: widget.enableAutoComplete
                      ? _buildAutoCompleteNameField(item, context)
                      : GlobalsForm(
                          hasShadow: false,
                          controller: item.mealNameController,
                          label: 'Nama Makanan',
                          keyboardType: TextInputType.text,
                        ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 112,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SizedBox(
                        height: 52,
                        child: GlobalsForm(
                          enableFloatingLabel: false,
                          hasShadow: false,
                          controller: item.portionsController,
                          label: '1',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          contentPadding: const EdgeInsets.only(
                            right: 48,
                            left: 12,
                            top: 16,
                            bottom: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        child: Container(
                          height: 44,
                          width: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary1,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Porsi',
                            style: AppTextStyles.list1Bold(AppColors.base5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_forms.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _removeForm(index),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.warn4,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(40, 32),
                ),
                child: const Text('Hapus'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAutoCompleteNameField(MealFormItem item, BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return const Iterable<String>.empty();
        }
        final matched = widget.autoCompleteOptions
            .where((option) => option.toLowerCase().contains(query))
            .toList();
        return matched;
      },
      onSelected: (String selection) {
        item.mealNameController.text = selection;
        widget.onAutoCompleteSelected?.call(selection);
        widget.onChanged?.call();
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        final currentText = item.mealNameController.text;
        if (controller.text != currentText) {
          controller.value = TextEditingValue(
            text: currentText,
            selection: TextSelection.collapsed(offset: currentText.length),
          );
        }

        return TextFormField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.text,
          style: AppTextStyles.heading3Medium(),
          onChanged: (value) {
            if (item.mealNameController.text != value) {
              item.mealNameController.value = TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(offset: value.length),
              );
            }
            widget.onChanged?.call();
          },
          decoration: InputDecoration(
            labelText: 'Nama Makanan',
            labelStyle: AppTextStyles.heading3Medium(Colors.grey),
            filled: true,
            fillColor: AppColors.base5,
            floatingLabelStyle: AppTextStyles.heading3Medium(
              AppColors.primary1,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19.5),
              borderSide: const BorderSide(color: AppColors.primary1, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19.5),
              borderSide: const BorderSide(color: AppColors.base3, width: 1.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final optionsList = options.toList();
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: AppColors.base5,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: optionsList.length,
                itemBuilder: (context, index) {
                  final option = optionsList[index];
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(option, style: AppTextStyles.list1Regular()),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _attachListeners(MealFormItem item) {
    if (widget.onChanged == null) return;
    item.mealNameController.addListener(widget.onChanged!);
    item.portionsController.addListener(widget.onChanged!);
  }

  void _removeForm(int index) {
    if (_forms.length <= 1) return;
    final item = _forms[index];
    item.mealNameController.removeListener(widget.onChanged!);
    item.portionsController.removeListener(widget.onChanged!);
    setState(() {
      _forms.removeAt(index);
    });
    if (_ownsForms) {
      item.mealNameController.dispose();
      item.portionsController.dispose();
    }
    widget.onItemRemoved?.call(index);
    widget.onChanged?.call();
  }
}
