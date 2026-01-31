import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';

import '../colors/colors.dart';
import '../dialog/dialog_alert.dart';
import '../text/text_style.dart';
import 'card_lable_meal_plan.dart';

class MealCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String title;
  final String description;
  final double calories;
  final String categoryType;
  final VoidCallback onTap;
  final bool isSporkyPlus;

  const MealCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.description,
    required this.calories,
    required this.categoryType,
    required this.onTap,
    this.isSporkyPlus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (isSporkyPlus) {
            DialogAlert.show(
              barrierDismissible: true,
              context: context,
              title: "Buka Akses Tanpa Batas ",
              message:
                  "Beberapa fitur hanya tersedia untuk paket lengkap. Yuk, upgrade paket agar si Kecil bisa tumbuh lebih optimal! 🌱",
            );
          } else {
            onTap();
          }
        },
        child: Stack(
          children: [
            Opacity(
              opacity: isSporkyPlus ? 0.5 : 1.0,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary1),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.base5,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.base1.withAlpha(120),
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: _buildImage(imagePath),
                          ),

                          // Label atas
                          Positioned(
                            top: 10,
                            left: 5,
                            child:
                                CardLableMealPlan(categoryType: categoryType),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Judul
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.lable3SemiBold(
                                      AppColors.base1),
                                ),
                              ),

                              // Deskripsi
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.list3Regular(
                                      AppColors.base1),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              width: 45,
                              height: 27,
                              decoration: BoxDecoration(
                                color: AppColors.secondary1,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${calories.toStringAsFixed(0)} ',
                                      style: AppTextStyles.list1Bold(
                                          AppColors.base5)),
                                  Text("kal",
                                      style: AppTextStyles.list3Regular(
                                          AppColors.base5))
                                ],
                              ))
                        ],
                      ),

                      // tombol Meal plan
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GlobalsButton(
                          onPressed: () {},
                          height: 22,
                          child: Row(
                            children: [
                              const Icon(Icons.favorite_border,
                                  size: 14, color: AppColors.base5),
                              const SizedBox(width: 5),
                              Text(
                                'Meal Plan',
                                style: AppTextStyles.list1Bold(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (isSporkyPlus)
              Positioned(
                top: 90,
                left: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary1,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.base1.withAlpha(120),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: AppColors.base5),
                      const SizedBox(width: 5),
                      Text(
                        "Buka dengan Sporky +",
                        style: AppTextStyles.list3SemiBold(AppColors.base5),
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
}

Widget _buildImage(String imagePath) {
  final bool isNetworkImage = imagePath.startsWith('http');

  return isNetworkImage
      ? Image.network(
          imagePath,
          width: 138,
          height: 170,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 138,
              height: 170,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Gambar gagal dimuat → tampilkan ikon broken image
            return Container(
              width: 138,
              height: 170,
              color: Colors.grey[200],
              child: const Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
            );
          },
        )
      : Image.asset(
          imagePath,
          width: 138,
          height: 170,
          fit: BoxFit.cover,
        );
}
