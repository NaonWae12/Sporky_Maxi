import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

Future<List<String>?> showFilterBottomSheet(
  BuildContext context, {
  required String title,
  Widget? child,
  required List<String> categories,
  String? buttonText,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.base5,
    builder: (_) => ModalBottomSheet(
      title: title,
      categories: categories,
      buttonText: buttonText ?? 'Terapkan',
      child: child,
    ),
  );
}

class ModalBottomSheet extends StatefulWidget {
  final String title;
  final Widget? child;
  final String buttonText;
  final List<String> categories;

  const ModalBottomSheet({
    super.key,
    required this.title,
    this.child,
    required this.categories,
    this.buttonText = 'Terapkan',
  });

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: AppColors.base3,
                height: 2,
                width: MediaQuery.of(context).size.width / 5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: AppTextStyles.headList1Bold(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.categories.map(
                (cat) {
                  final isSelected = selectedCategories.contains(cat);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategories.remove(cat);
                        } else {
                          selectedCategories.add(cat);
                        }
                      });
                    },
                    child: GlobalsCardOutlined(
                      backgroundColor:
                          isSelected ? AppColors.secondary1 : AppColors.base5,
                      borderColor: AppColors.secondary1,
                      height: 23,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cat,
                            style: AppTextStyles.list1Regular(
                              isSelected
                                  ? AppColors.base5
                                  : AppColors.secondary1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isSelected ? Icons.close : Icons.add,
                            size: 12,
                            color: isSelected
                                ? AppColors.base5
                                : AppColors.secondary1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            if (widget.child != null) widget.child!,
            const SizedBox(height: 24),
            GlobalsButton(
                height: 44,
                color: AppColors.primary1,
                onPressed: () => Navigator.of(context).pop(selectedCategories),
                child: Text(widget.buttonText,
                    style: AppTextStyles.headList1Bold())),
          ],
        ),
      ),
    ));
  }
}

Future<List<String>?> showIngredientFilterBottomSheet(
  BuildContext context, {
  required String title,
  required List<Map<String, dynamic>> structuredCategories,
  List<String> initialSelected = const [],
  String? buttonText,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.base5,
    builder: (_) => IngredientFilterBottomSheet(
      title: title,
      structuredCategories: structuredCategories,
      initialSelected: initialSelected,
      buttonText: buttonText ?? 'Terapkan',
    ),
  );
}

class IngredientFilterBottomSheet extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> structuredCategories;
  final List<String> initialSelected;
  final String buttonText;

  const IngredientFilterBottomSheet({
    super.key,
    required this.title,
    required this.structuredCategories,
    required this.initialSelected,
    required this.buttonText,
  });

  @override
  State<IngredientFilterBottomSheet> createState() =>
      _IngredientFilterBottomSheetState();
}

class _IngredientFilterBottomSheetState
    extends State<IngredientFilterBottomSheet> {
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                color: AppColors.base3,
                height: 2,
                width: MediaQuery.of(context).size.width / 5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.headList1Bold(),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategories.clear();
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.structuredCategories.map((sec) {
              final sectionTitle = sec['title']?.toString() ?? '';
              final List<dynamic> items = sec['items'] ?? [];
              if (items.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionTitle,
                    style: AppTextStyles.headList1Bold(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: items.map(
                      (catObj) {
                        final cat = catObj.toString();
                        final isSelected = selectedCategories.contains(cat);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedCategories.remove(cat);
                              } else {
                                selectedCategories.add(cat);
                              }
                            });
                          },
                          child: GlobalsCardOutlined(
                            backgroundColor: isSelected
                                ? AppColors.secondary1
                                : AppColors.base5,
                            borderColor: AppColors.secondary1,
                            height: 23,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  cat,
                                  style: AppTextStyles.list1Regular(
                                    isSelected
                                        ? AppColors.base5
                                        : AppColors.secondary1,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  isSelected ? Icons.close : Icons.add,
                                  size: 12,
                                  color: isSelected
                                      ? AppColors.base5
                                      : AppColors.secondary1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const SizedBox(height: 8),
            GlobalsButton(
              height: 44,
              color: AppColors.primary1,
              onPressed: () => Navigator.of(context).pop(selectedCategories),
              child: Text(
                widget.buttonText,
                style: AppTextStyles.headList1Bold(),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
