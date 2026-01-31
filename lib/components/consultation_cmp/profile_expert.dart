import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/cmp_profile_expert.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../globals/bar/full_width_tab_bar.dart';
import 'cmp_tab_profile_expert.dart';
import 'cmp_tab_ticket_expert.dart';

class ProfileExpert extends StatelessWidget {
  const ProfileExpert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('Profil Expert', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: Column(
        children: [
          const CmpProfileExpert(doctorName: 'dr.Palomina'),
          Expanded(
            child: FullWidthTabBar(tabs: const [
              'Profil',
              'Tiket Konsultasi'
            ], tabViews: [
              const CmpTabProfileExpert(),
              CmpTabTicketExpert(
                buyTicketCall: () {},
                buyTicketChat: () {},
                callPrice: '100.000',
                chatPrice: '50.000',
                duration: '30',
                session: '1',
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
