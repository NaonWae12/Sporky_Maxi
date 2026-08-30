import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/saved_content_favorites_list.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ArticleFav extends StatelessWidget {
  const ArticleFav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel Favorit', style: AppTextStyles.heading2SemiBold()),
      ),
      body: const SavedContentFavoritesList(
        type: SavedContentFavoriteType.article,
      ),
    );
  }
}
