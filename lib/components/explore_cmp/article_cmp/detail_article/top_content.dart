import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../globals/card/globals_card.dart';
import '../../../globals/card/globals_card_outlined.dart';

class TopContent extends StatefulWidget {
  final String? imageAsset;
  final String title;
  final String? doctor;
  final String? doctorImage;
  final VoidCallback? onTap;
  final int views;
  final int likes;
  final List<String> categories;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  const TopContent({
    super.key,
    this.imageAsset,
    required this.title,
    this.doctor,
    this.doctorImage,
    this.onTap,
    required this.views,
    required this.likes,
    required this.categories,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;
  }

  @override
  void didUpdateWidget(covariant TopContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorited != widget.isFavorited) {
      _isFavorited = widget.isFavorited;
    }
  }

  void _handleFavoriteTap() {
    if (widget.onFavoriteTap != null) {
      widget.onFavoriteTap!();
      return;
    }
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  bool _isNetworkImage(String imagePath) {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  Widget _buildImage() {
    final imagePath = widget.imageAsset?.trim();
    if (imagePath == null || imagePath.isEmpty) {
      return _placeholderCover();
    }

    if (_isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: 180,
            width: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholderCover(),
      );
    }

    return Image.asset(
      imagePath,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholderCover(),
    );
  }

  Widget _placeholderCover() {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppColors.base3,
      child: const Icon(Icons.broken_image, size: 48, color: AppColors.base2),
    );
  }

  Widget _buildDoctorImage() {
    final doctorImage = widget.doctorImage?.trim();
    if (doctorImage == null || doctorImage.isEmpty) {
      return const Icon(Icons.person, size: 12, color: AppColors.base2);
    }

    if (_isNetworkImage(doctorImage)) {
      return Image.network(
        doctorImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 12, color: AppColors.base2);
        },
      );
    }

    return Image.asset(
      doctorImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 12, color: AppColors.base2);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorName = (widget.doctor?.trim().isNotEmpty ?? false)
        ? widget.doctor!.trim()
        : 'Tim Sporky';
    final categories = widget.categories.isNotEmpty
        ? widget.categories
        : const ['Artikel'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // gambar/video
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),
        ),

        GlobalsCard(
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori — Wrap selebar kartu (bukan di dalam Row) sehingga
                // saat tags banyak akan membungkus ke baris berikutnya, tidak
                // meluber keluar container. Gaya mengikuti detail video.
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: categories
                      .map(
                        (cat) => GlobalsCardOutlined(
                          text: cat,
                          textStyle: AppTextStyles.lable3SemiBold(
                            AppColors.primary1,
                          ),
                          backgroundColor: AppColors.base5,
                          borderColor: AppColors.primary1,
                          textColor: AppColors.primary1,
                          height: 26,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                // Judul + tombol favorit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headList1Bold(),
                      ),
                    ),
                    IconButton(
                      onPressed: _handleFavoriteTap,
                      icon: Icon(
                        _isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.warn1,
                      ),
                    ),
                  ],
                ),
                // Penulis + views + likes (mengikuti detail video)
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.base5,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.base2, width: 1),
                      ),
                      child: ClipOval(child: _buildDoctorImage()),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        doctorName,
                        style: AppTextStyles.list1Regular(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 14,
                      color: AppColors.base1,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${widget.views} views',
                      style: AppTextStyles.list1Regular(AppColors.base1),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.favorite,
                      size: 14,
                      color: AppColors.warn1,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${widget.likes} likes',
                      style: AppTextStyles.list1Regular(AppColors.base1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
