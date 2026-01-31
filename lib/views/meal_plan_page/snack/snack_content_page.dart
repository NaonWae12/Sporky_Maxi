import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_card_list_article.dart';

class SnackContentPage extends StatelessWidget {
  const SnackContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmpCardListArticle(
          onTap: () {},
          imageAsset: 'assets/temp_img/meal2.png',
          meal: 'Cemilan Pagi',
          views: 1200,
          likes: 567,
          kal: 145,
          title: "Mix Platter-1",
          description:
              'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
        ),
        CmpCardListArticle(
          onTap: () {},
          imageAsset: 'assets/temp_img/meal1.png',
          meal: 'Cemilan Pagi',
          views: 1200,
          likes: 567,
          kal: 145,
          title: "Mix Platter-1",
          description:
              'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
        ),
        CmpCardListArticle(
          onTap: () {},
          meal: 'Cemilan Pagi',
          views: 1200,
          likes: 567,
          kal: 145,
          title: "Mix Platter-1",
          description:
              'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
        ),
      ],
    );
  }
}
