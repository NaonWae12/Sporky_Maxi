import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class BottomSheetFoodHistory extends StatelessWidget {
  final String title;
  final List<FoodItemData> items;

  const BottomSheetFoodHistory({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.headList1Bold(AppColors.base1)),
              const SizedBox(height: 12),
              ...items.map((item) => _FoodItemTile(data: item)),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItemData {
  final String title;
  final String? image;
  final int served;
  final int eaten;
  final int remaining;
  final int calories;

  FoodItemData({
    required this.title,
    this.image,
    required this.served,
    required this.eaten,
    required this.remaining,
    required this.calories,
  });
}

class _FoodItemTile extends StatelessWidget {
  final FoodItemData data;

  const _FoodItemTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.base4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: data.image != null && data.image!.isNotEmpty
                ? Image.network(
                    data.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imageFallback();
                    },
                  )
                : _imageFallback(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTextStyles.list1Bold(AppColors.base1),
                ),
                const SizedBox(height: 4),
                Text(
                  'Disajikan: ${data.served} kcal',
                  style: AppTextStyles.list3Regular(AppColors.base2),
                ),
                Text(
                  'Dimakan: ${data.eaten} kcal',
                  style: AppTextStyles.list3Regular(AppColors.base2),
                ),
                Text(
                  'Sisa: ${data.remaining} kcal',
                  style: AppTextStyles.list3Regular(AppColors.base2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.base5,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.warn1,
                  size: 16,
                ),
                Text(
                  '${data.calories} kcal',
                  style: AppTextStyles.list3SemiBold(AppColors.base1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.base3,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.fastfood, size: 20, color: AppColors.base2),
    );
  }
}
