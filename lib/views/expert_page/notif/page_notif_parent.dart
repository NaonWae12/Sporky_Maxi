import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/notification/notification_list_content.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PageNotifParent extends StatelessWidget {
  const PageNotifParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            Text('Notifikasi', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: const NotificationListContent(),
    );
  }
}
