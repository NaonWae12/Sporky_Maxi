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
  final double views;
  final int likes;
  final List<String> categories;

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
  });

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  bool isFavorited = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // gambar/video
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.imageAsset != null
                ? Image.asset(
                    widget.imageAsset!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.base3,
                    child: const Icon(Icons.broken_image,
                        size: 48, color: AppColors.base2),
                  ),
          ),
        ),

        SizedBox(
          width: MediaQuery.of(context).size.width * 80,
          child: GlobalsCard(
              backgroundColor: AppColors.base4,
              hasShadow: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Kategori
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: widget.categories
                              .map((cat) => GlobalsCardOutlined(
                                    text: cat,
                                    textStyle: AppTextStyles.lable4SemiRegular(
                                        AppColors.primary1),
                                    backgroundColor: AppColors.base5,
                                    borderColor: AppColors.primary1,
                                    textColor: AppColors.primary1,
                                    height: 16,
                                  ))
                              .toList(),
                        ),
                        // Views & Likes
                        Row(
                          children: [
                            const Icon(Icons.remove_red_eye_outlined,
                                size: 13, color: AppColors.base1),
                            const SizedBox(width: 4),
                            Text('${widget.views.toString()} views',
                                style: AppTextStyles.list3Regular(
                                    AppColors.base1)),
                            const SizedBox(width: 5),
                            const Icon(Icons.favorite,
                                size: 13, color: AppColors.warn1),
                            const SizedBox(width: 4),
                            Text('${widget.likes.toString()} likes',
                                style: AppTextStyles.list3Regular(
                                    AppColors.base1)),
                          ],
                        ),
                      ],
                    ),
                    // Judul
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            widget.title,
                            style: AppTextStyles.headList1Bold(),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isFavorited = !isFavorited;
                              });
                            },
                            icon: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.warn1,
                            ))
                      ],
                    ),
                    // Subtitle
                    Row(
                      children: [
                        // Gambar bulat dengan outline
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.base5,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.base2, width: 1),
                            image: DecorationImage(
                              image: AssetImage(widget.doctorImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          widget.doctor!,
                          style: AppTextStyles.list1Regular(),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
