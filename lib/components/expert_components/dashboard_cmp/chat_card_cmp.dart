import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ChatCardCmp extends StatelessWidget {
  final String count;
  const ChatCardCmp({super.key, this.count = '0'});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      margin: EdgeInsets.all(0),
      height: 70,
      width: 110,
      hasShadow: false,
      backgroundColor: AppColors.base5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Chat',
            style: AppTextStyles.lable2Medium(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/ic_increase.svg'),
              const SizedBox(width: 5),
              Text(
                count,
                style: AppTextStyles.upperDisplay1SemiBold(AppColors.success1)
                    .copyWith(height: 1.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}
