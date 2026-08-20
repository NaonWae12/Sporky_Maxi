import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // list makanan
            ...items.map((item) => _FoodItemTile(data: item)),

            // spacing bawah biar enak di iPhone
            const SizedBox(height: 10),
          ],
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
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // IMAGE
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

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Disajikan : ${data.served} kcal',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Dimakan : ${data.eaten} kcal',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Tersisa : ${data.remaining} kcal',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // CALORIES BADGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.red,
                  size: 16,
                ),
                Text(
                  '${data.calories} kcal',
                  style: const TextStyle(fontSize: 12),
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
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.fastfood,
        size: 20,
        color: Colors.grey[600],
      ),
    );
  }
}
