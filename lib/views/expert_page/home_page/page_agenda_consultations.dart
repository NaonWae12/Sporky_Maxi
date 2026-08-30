import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/expert_components/schedule/expert_agenda_list.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/home_page/page_all_consultation.dart';

class PageAgendaConsultations extends StatelessWidget {
  const PageAgendaConsultations({super.key});

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
            Text('Agenda Konsultasi', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: FullWidthTabBar(
        tabs: const ['Semua', 'Chat', 'Zoom'],
        tabViews: [
          const PageAllConsultation(),
          ExpertAgendaList(
            type: 'chat',
            limit: 100,
            showHeader: true,
            useOwnScroll: true,
          ),
          ExpertAgendaList(
            type: 'zoom',
            limit: 100,
            showHeader: true,
            useOwnScroll: true,
          ),
        ],
      ),
    );
  }
}
