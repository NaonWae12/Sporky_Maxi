import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/globals/card/card_agenda_cmp.dart';

class PageAllConsultation extends StatelessWidget {
  const PageAllConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hari ini',
                style: AppTextStyles.heading3SemiBold(),
              ),
            ),
          ),
          CardAgendaCmp(
            isOnline: true,
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.video,
          ),
          CardAgendaCmp(
            isScheduled: true,
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.chat,
          ),
          CardAgendaCmp(
            isCanceled: true,
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.video,
          ),
        ],
      ),
    );
  }
}
