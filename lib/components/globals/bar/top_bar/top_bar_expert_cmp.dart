import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/avatar/profile_avatar.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/notification_badge_button.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/notif/page_notif_expert.dart';

class TopBarExpertCmp extends StatelessWidget {
  final String name;
  final String title;
  final String? photoUrl;
  final VoidCallback? onTap;
  const TopBarExpertCmp({
    super.key,
    required this.name,
    required this.title,
    this.photoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar anak
              GestureDetector(
                onTap: onTap,
                child: ProfileAvatar(photoUrl: photoUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.heading2SemiBold()),
                  Text(title, style: AppTextStyles.list1Regular()),
                ],
              ),
            ],
          ),
          NotificationBadgeButton(
            pageBuilder: (context) => const PageNotifExpert(),
          ),
        ],
      ),
    );
  }
}
