import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_card_list_article.dart';

class SnackContentPage extends StatelessWidget {
  final String searchQuery;

  const SnackContentPage({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'imageAsset': 'assets/temp_img/meal2.png',
        'meal': 'Cemilan Pagi',
        'views': 1200,
        'likes': 567,
        'kal': 145,
        'title': "Mix Platter-1",
        'description':
            'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
      },
      {
        'imageAsset': 'assets/temp_img/meal1.png',
        'meal': 'Cemilan Pagi',
        'views': 1200,
        'likes': 567,
        'kal': 145,
        'title': "Mix Platter-1",
        'description':
            'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
      },
      {
        'imageAsset': null,
        'meal': 'Cemilan Pagi',
        'views': 1200,
        'likes': 567,
        'kal': 145,
        'title': "Mix Platter-1",
        'description':
            'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
      },
    ];

    final filteredItems = items.where((item) {
      if (searchQuery.isEmpty) return true;
      final title = item['title']?.toString() ?? '';
      return title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Tidak ada cemilan yang cocok dengan pencarian.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: filteredItems.map((item) {
        return CmpCardListArticle(
          onTap: () {},
          imageAsset: item['imageAsset'],
          meal: item['meal'],
          views: item['views'],
          likes: item['likes'],
          kal: item['kal'],
          title: item['title'],
          description: item['description'],
        );
      }).toList(),
    );
  }
}
