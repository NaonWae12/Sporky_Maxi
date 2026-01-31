import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

enum AgendaCategory { chat, video }

class CardAgendaCmp extends StatelessWidget {
  final String nameParrent;
  final String nameChild;
  final String chat;
  final bool isOnline;
  final bool isScheduled;
  final bool isCanceled;
  final Color color;
  final AgendaCategory category;

  const CardAgendaCmp({
    super.key,
    required this.nameChild,
    required this.nameParrent,
    required this.chat,
    this.isOnline = false,
    this.isScheduled = false,
    this.isCanceled = false,
    this.color = AppColors.base4,
    this.category = AgendaCategory.chat,
  });

  Color get _statusColor {
    if (isOnline) return AppColors.success1;
    if (isScheduled) return AppColors.secondary2;
    if (isCanceled) return AppColors.warn1;
    return color;
  }

  String get _iconAsset {
    switch (category) {
      case AgendaCategory.chat:
        return 'assets/svg/shape_chat.svg';
      case AgendaCategory.video:
        return 'assets/svg/shape_video.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      height: 76,
      hasShadow: false,
      border: Border.all(color: _statusColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SvgPicture.asset(
                    _iconAsset,
                    width: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nameParrent - $nameChild',
                      style: AppTextStyles.list1Bold(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        chat,
                        style: AppTextStyles.list1Regular(AppColors.base3),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GlobalsCard(
              margin: EdgeInsets.zero,
              height: 76,
              hasShadow: false,
              backgroundColor: _statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(0),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(
                      isCanceled ? 'Dibatalkan' : '10.00 - 10.00',
                      style: AppTextStyles.list1Bold().copyWith(
                        color: (isOnline || isScheduled || isCanceled)
                            ? AppColors.base5
                            : AppColors.base1,
                        overflow: TextOverflow.clip,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
