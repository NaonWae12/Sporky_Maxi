import 'package:flutter/material.dart';
import '../../components/globals/text/text_style.dart';
import '../../components/meal_form_cmp/cmp_add_fix_meal_form.dart';
// import '../../components/meal_form_cmp/cmp_normal_meal_form.dart';

class AddMealCategoryPage extends StatelessWidget {
  const AddMealCategoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                'Tambah Form Makanan',
                style: AppTextStyles.heading1SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: const Column(
        children: [CmpAddFixMealForm()],
      ),
    );
  }
}
