import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CmpListChat extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final bool isActive;
  final String? photoUrl; // bisa asset atau url network
  final bool isAsset; // true: AssetImage, false: NetworkImage
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final int maxLines;

  const CmpListChat({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.isActive,
    this.photoUrl,
    this.isAsset = false,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    this.onTap,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: photoUrl != null
                            ? Image(
                                image: isAsset
                                    ? AssetImage(photoUrl!) as ImageProvider
                                    : NetworkImage(photoUrl!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.base2,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.base2,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color:
                              isActive ? AppColors.success1 : AppColors.base2,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.base5, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.heading3SemiBold(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: AppTextStyles.list1Regular(AppColors.base2),
                        overflow: TextOverflow.ellipsis,
                        maxLines: maxLines,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      time,
                      style: AppTextStyles.list3SemiBold(),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppColors.primary1,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: AppTextStyles.list1Regular(AppColors.base5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 1.05,
              color: AppColors.base4,
            )
          ],
        ),
      ),
    );
  }
}
