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
    ),
  );
}

class ModalBottomSheet extends StatefulWidget {
  final String title;
  final Widget? child;
  final List<String> categories;

  const ModalBottomSheet({
    super.key,
    required this.title,
    this.child,
    required this.categories,
  });

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      text: cat,
                      textStyle: AppTextStyles.list1Regular(
                          isSelected ? AppColors.base5 : AppColors.secondary1),
                      backgroundColor:
                          isSelected ? AppColors.secondary1 : AppColors.base5,
                      borderColor: AppColors.secondary1,
                      textColor:
                          isSelected ? AppColors.base5 : AppColors.primary1,
                      height: 23,
                    ),
                  );
                },
              ).toList(),
            ),
            if (widget.child != null) widget.child!,
            const SizedBox(height: 24),
            GlobalsButton(
                height: 44,
                color: AppColors.secondary1,
                onPressed: () => Navigator.of(context).pop(selectedCategories),
                child: Text('Terapkan', style: AppTextStyles.headList1Bold())),
          ],
        ),
      ),
    );
  }
}
