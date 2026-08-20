import 'package:flutter/material.dart';

import '../../../components/explore_cmp/video_cmp/short_vid_content_more_views.dart';
import '../../../components/explore_cmp/video_cmp/short_vid_content_special.dart';
import '../../../components/globals/card/cmp_tag_category.dart';

class VideoPage extends StatefulWidget {
  final String searchQuery;

  const VideoPage({
    super.key,
    this.searchQuery = '',
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25),
          const CmpTagCategory(
            imageAsset: 'assets/svg/ic_ rocket.svg',
            text: 'Sedang Banyak Ditonton',
          ),
          ShortVidContentMoreViews(searchQuery: widget.searchQuery),
          const CmpTagCategory(
            imageAsset: 'assets/svg/sun.svg',
            text: 'Spesial Untuk Bunda & Si Kecil',
          ),
          ShortVidContentSpecial(searchQuery: widget.searchQuery),
        ],
      ),
    );
  }
}
