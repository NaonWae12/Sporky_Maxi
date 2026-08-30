import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/dialog/globals_bottom_sheet.dart';

import 'bottom_sheet_food_history.dart';
import 'history_list_cmp.dart';

class PageHistoryList extends StatelessWidget {
  final List<dynamic> intakes;

  const PageHistoryList({super.key, required this.intakes});

  String _mapMealTime(String mealTimeRaw) {
    final clean = mealTimeRaw.trim();
    if (clean.startsWith('07') || clean.startsWith('08')) {
      return 'Makan Pagi';
    } else if (clean.startsWith('10')) {
      return 'Snack Pagi';
    } else if (clean.startsWith('12')) {
      return 'Makan Siang';
    } else if (clean.startsWith('15')) {
      return 'Snack Sore';
    } else if (clean.startsWith('18')) {
      return 'Makan Malam';
    }
    return 'Makan Pagi';
  }

  String _formatHour(String mealTimeRaw) {
    final clean = mealTimeRaw.trim();
    if (clean.length >= 5) {
      return clean.substring(0, 5).replaceAll(':', '.');
    }
    return clean;
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String? _resolveImage(Map<String, dynamic> item) {
    final photo = item['photo']?.toString().trim() ?? '';
    if (photo.isNotEmpty) return photo;

    final mealPlan = item['meal_plan'];
    if (mealPlan is Map<String, dynamic>) {
      final imageUrl = mealPlan['image_url']?.toString().trim() ?? '';
      if (imageUrl.isNotEmpty) return imageUrl;
    }
    // null → BottomSheetFoodHistory will show the built-in fallback icon
    return null;
  }

  void _showDetailBottomSheet(
    BuildContext context,
    String title,
    Map<String, dynamic> item,
    String resolvedName,
  ) {
    final imageUrl = _resolveImage(item);

    // Ambil data food_waste jika tersedia
    final wasteNode = item['food_waste'];
    final hasWaste = wasteNode is Map<String, dynamic> && wasteNode.isNotEmpty;

    // served = kalori yang disajikan (dari intake)
    final served = _asDouble(item['calories']).round();
    // eaten = kalori yang benar-benar dimakan (dari actual_calories jika ada waste)
    final eaten = hasWaste
        ? _asDouble(wasteNode['actual_calories']).round()
        : served;
    // remaining = sisa kalori (gap_calories dari waste, atau 0 jika tidak ada waste)
    final remaining = hasWaste
        ? _asDouble(wasteNode['gap_calories']).round()
        : 0;

    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      child: BottomSheetFoodHistory(
        title: title,
        items: [
          FoodItemData(
            title: resolvedName.isNotEmpty ? resolvedName : title,
            image: imageUrl,
            served: served,
            eaten: eaten,
            remaining: remaining,
            calories: eaten,
          ),
        ],
      ),
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (intakes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada riwayat makanan'),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: intakes.map((item) {
          final rawName = item['name'];
          String itemName = rawName?.toString().trim() ?? '';
          if (itemName.isEmpty) {
            final mealPlan = item['meal_plan'];
            if (mealPlan is Map<String, dynamic>) {
              itemName = mealPlan['name']?.toString().trim() ?? '';
            }
          }
          final rawMealTime = item['meal_time']?.toString() ?? '08:00:00';

          final mealTime = _mapMealTime(rawMealTime);
          final hour = _formatHour(rawMealTime);
          final carbohydrate = _asDouble(item['carbohydrate']).round();
          final proteins = _asDouble(item['protein']).round();
          final fat = _asDouble(item['fat']).round();
          final totalcalories = _asDouble(item['calories']).round();

          final itemMap = item is Map<String, dynamic>
              ? item
              : <String, dynamic>{};

          return HistoryListCmp(
            onTap: () =>
                _showDetailBottomSheet(context, mealTime, itemMap, itemName),
            mealTime: mealTime,
            hour: hour,
            carbohydrate: carbohydrate,
            proteins: proteins,
            fat: fat,
            totalcalories: totalcalories,
            itemName: itemName,
          );
        }).toList(),
      ),
    );
  }
}
