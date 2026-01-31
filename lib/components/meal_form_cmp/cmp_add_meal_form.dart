import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';

import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class CmpAddMealForm extends StatefulWidget {
  final bool normalFill;
  const CmpAddMealForm({
    super.key,
    this.normalFill = true,
  });

  @override
  State<CmpAddMealForm> createState() => _CmpAddMealFormState();
}

class _CmpAddMealFormState extends State<CmpAddMealForm> {
  TextEditingController mealNameController = TextEditingController();
  TextEditingController portionsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GlobalsForm(
                  hasShadow: false,
                  controller: mealNameController,
                  label: 'Nama Makanan',
                  keyboardType: TextInputType.number,
                  // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GlobalsForm(
                        width: 140,
                        hasShadow: false,
                        controller: portionsController,
                        label: '1',
                        keyboardType: TextInputType.number,
                        // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GlobalsCard(
                          backgroundColor: AppColors.primary1,
                          width: 95,
                          hasShadow: false,
                          height: MediaQuery.of(context).size.height / 17,
                          margin: const EdgeInsets.all(0),
                          child: Center(
                            child: Text(
                              'Porsi',
                              style: AppTextStyles.heading3SemiBold(
                                  AppColors.base5),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
          if (widget.normalFill)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GlobalsButton(
                height: 44,
                onPressed: () {},
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
}
