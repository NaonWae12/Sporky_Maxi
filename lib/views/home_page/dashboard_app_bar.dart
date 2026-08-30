import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/notification_badge_button.dart';
import 'package:sporky_maxi/views/expert_page/notif/page_notif_parent.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.base5,
      elevation: 0,
      expandedHeight: 90,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Height dari app bar saat ini
          final double currentHeight = constraints.biggest.height;

          // Tampilkan title hanya jika tinggi app bar sudah collapse
          final bool isCollapsed = currentHeight <= kToolbarHeight + 10;

          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16),
            title: isCollapsed
                ? Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icon_Crown.png",
                                height: 25,
                                width: 25,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Hai, Alicia',
                                style: AppTextStyles.heading1SemiBold(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        NotificationBadgeButton(
                          pageBuilder: (context) => const PageNotifParent(),
                        ),
                      ],
                    ),
                  )
                : null,
            background: Padding(
              padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/temp_img/parent.png'),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Hai, Alicia',
                            style: AppTextStyles.heading2SemiBold(),
                          ),
                          const SizedBox(width: 4),
                          Image.asset("assets/icon_Crown.png"),
                        ],
                      ),
                      Text(
                        'Bagaimana kondisi anakmu hari ini?',
                        style: AppTextStyles.list1Regular(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
