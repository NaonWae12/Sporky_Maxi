import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../globals/card/globals_card.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class ProfileParentSection extends StatelessWidget {
  final String name;
  final int? countNotif;
  final VoidCallback directToEditPage;

  const ProfileParentSection({
    super.key,
    required this.directToEditPage,
    required this.name,
    this.countNotif,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary2,
            backgroundImage: AssetImage('assets/temp_img/kids.png'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.heading2SemiBold(),
                ),
                GlobalsCard(
                  onTap: directToEditPage,
                  width: 55,
                  hasShadow: false,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(5),
                  backgroundColor: AppColors.primary2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Edit',
                          style: AppTextStyles.list1Bold(AppColors.base5)),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                          colorFilter: const ColorFilter.mode(
                              AppColors.base5, BlendMode.srcIn),
                          height: 16,
                          width: 16,
                          'assets/svg/ic_edit.svg')
                    ],
                  ),
                )
              ],
            ),
          ),
          Stack(
            children: [
              SvgPicture.asset(
                  height: 33, width: 27, 'assets/svg/ic_notif.svg'),
              if (countNotif != null)
                Positioned(
                  right: 0,
                  top: -5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.base1,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '$countNotif',
                        style: AppTextStyles.lable3Regular(AppColors.base5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
