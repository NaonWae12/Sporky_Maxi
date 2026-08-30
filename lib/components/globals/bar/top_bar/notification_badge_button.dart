import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';

class NotificationBadgeButton extends StatefulWidget {
  final WidgetBuilder pageBuilder;

  const NotificationBadgeButton({super.key, required this.pageBuilder});

  @override
  State<NotificationBadgeButton> createState() =>
      _NotificationBadgeButtonState();
}

class _NotificationBadgeButtonState extends State<NotificationBadgeButton> {
  static const ApiFoundationService _service = ApiFoundationService();

  late Future<int> _unreadCountFuture;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  void _loadUnreadCount() {
    _unreadCountFuture = _service
        .getNotifications(perPage: 100)
        .then(
          (response) =>
              response.notifications.where((item) => !item.isRead).length,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: AppColors.primary1,
            size: 36,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: widget.pageBuilder),
            );
            if (mounted) setState(_loadUnreadCount);
          },
        ),
        FutureBuilder<int>(
          future: _unreadCountFuture,
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            if (count <= 0) return const SizedBox.shrink();

            return Positioned(
              right: 8,
              top: 8,
              child: Container(
                constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.secondary1,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: AppTextStyles.lable4SemiRegular(AppColors.base5),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
