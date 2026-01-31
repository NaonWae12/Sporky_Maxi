import 'package:flutter/material.dart';

import 'cmp_list_not_yet.dart';

class NotYet extends StatelessWidget {
  const NotYet({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          CmpListNotYet(
            imageAsset: 'assets/temp_img/dr.palomina1.jpg',
            isAvailable: false,
            showChat: false,
            showVideoCall: true,
            role: 'Ahli Gizi',
            ticketType: 'Chat',
            doctorName: 'dr.palomina',
            expire: '12/12/25',
            ticketCount: '5',
            workingDays: 'Senin - jumat',
            workingHours: '07.00 - 20.00',
          ),
        ],
      ),
    );
  }
}
