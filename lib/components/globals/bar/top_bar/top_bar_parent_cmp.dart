import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/avatar/profile_avatar.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/notification_badge_button.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../../views/expert_page/notif/page_notif_parent.dart';

class TopBarParentCmp extends StatelessWidget {
  final String name;
  final String chitChat;
  final String? photoUrl;
  final String? greeting;
  final VoidCallback? onTap;
  const TopBarParentCmp({
    super.key,
    required this.name,
    required this.chitChat,
    this.photoUrl,
    this.greeting = 'Hai',
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
              // Avatar orang tua
              GestureDetector(
                onTap: onTap,
                child: ProfileAvatar(photoUrl: photoUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name',
                    style: AppTextStyles.heading2SemiBold(),
                  ),
                  Text(chitChat, style: AppTextStyles.list1Regular()),
                ],
              ),
            ],
          ),
          NotificationBadgeButton(
            pageBuilder: (context) => const PageNotifParent(),
          ),
        ],
      ),
    );
  }
}
