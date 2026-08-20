import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
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
  final bool enableAutoComplete;
  final List<String> autoCompleteOptions;
  final ValueChanged<String>? onAutoCompleteSelected;
  const CmpAddMealForm({
    super.key,
    this.normalFill = true,
    this.forms,
    this.onChanged,
    this.onItemAdded,
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
    debugPrint(
      '[CmpAddMealForm] build - enableAutoComplete=${widget.enableAutoComplete} options=${widget.autoCompleteOptions.length}',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          for (int i = 0; i < _forms.length; i++) ...[
            _buildMealRow(_forms[i], context),
            if (i != _forms.length - 1) const SizedBox(height: 12),
          ],
          if (widget.normalFill)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GlobalsButton(
                height: 44,
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
                      color: AppColors.base5,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Menu Lain',
                      style: AppTextStyles.headList1Bold(AppColors.base5),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  /// =======================
  /// ROW FORM MAKANAN
  /// =======================
  Widget _buildMealRow(MealFormItem item, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: widget.enableAutoComplete
              ? _buildAutoCompleteNameField(item, context)
              : GlobalsForm(
                  hasShadow: false,
                  controller: item.mealNameController,
                  label: 'Nama Makanan',
                  keyboardType: TextInputType.text,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GlobalsForm(
                  enableFloatingLabel: false,
                  hasShadow: false,
                  controller: item.portionsController,
                  label: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
              Positioned(
                right: 0,
                child: GlobalsCard(
                  backgroundColor: AppColors.primary1,
                  width: 95,
                  hasShadow: false,
                  height: 55,
                  margin: const EdgeInsets.all(0),
                  child: Center(
                    child: Text(
                      'Porsi',
                      style: AppTextStyles.heading3SemiBold(AppColors.base5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoCompleteNameField(
      MealFormItem item, BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        debugPrint(
          '[CmpAddMealForm] optionsBuilder query="$query" options=${widget.autoCompleteOptions.length}',
        );
        if (query.isEmpty) {
          return const Iterable<String>.empty();
        }
        final matched = widget.autoCompleteOptions
            .where((option) => option.toLowerCase().contains(query))
            .toList();
        debugPrint('[CmpAddMealForm] matched options: $matched');
        return matched;
      },
      onSelected: (String selection) {
        debugPrint('[CmpAddMealForm] onSelected: $selection');
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
            debugPrint('[CmpAddMealForm] onChanged field value="$value"');
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
            floatingLabelStyle:
                AppTextStyles.heading3Medium(AppColors.primary1),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19.5),
              borderSide:
                  const BorderSide(color: AppColors.primary1, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19.5),
              borderSide:
                  const BorderSide(color: AppColors.base3, width: 1.2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final optionsList = options.toList();
        debugPrint(
          '[CmpAddMealForm] optionsViewBuilder count=${optionsList.length}',
        );
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
                          horizontal: 12, vertical: 10),
                      child: Text(
                        option,
                        style: AppTextStyles.list1Regular(),
                      ),
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
}
