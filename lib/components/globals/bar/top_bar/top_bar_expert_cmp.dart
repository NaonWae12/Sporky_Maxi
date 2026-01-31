import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/notif/page_notif_expert.dart';

import '../../colors/colors.dart';

class TopBarExpertCmp extends StatelessWidget {
  final String name;
  final String title;
  final VoidCallback? onTap;
  const TopBarExpertCmp({
    super.key,
    required this.name,
    required this.title,
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
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary2,
                  backgroundImage: AssetImage('assets/temp_img/kids.png'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.heading2SemiBold()),
                  Text(
                    title,
                    style: AppTextStyles.list1Regular(),
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.primary1,
                  size: 36,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageNotifExpert(),
                      ));
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary1,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '5',
                    style: AppTextStyles.lable4SemiRegular(AppColors.base5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
