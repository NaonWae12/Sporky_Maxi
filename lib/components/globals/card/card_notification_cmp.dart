import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../category_icon_notif/notification_icon_mapper.dart';

class CardNotificationCmp extends StatelessWidget {
  final String title;
  final String desc;
  final String category;
  final Color? iconColor;
  const CardNotificationCmp({
    super.key,
    required this.title,
    required this.desc,
    required this.category,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      NotificationIconMapper.getIcon(category),
                      width: 36,
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.list1Bold()),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          desc,
                          style: AppTextStyles.list1Regular(AppColors.base3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text('11.35 WIB',
                    style: AppTextStyles.list3SemiBold(AppColors.base3)),
              )
            ],
          ),
        ),
        Container(
          color: AppColors.base3,
          height: 1,
          width: MediaQuery.of(context).size.width / 1.05,
        )
      ],
    );
  }
}
