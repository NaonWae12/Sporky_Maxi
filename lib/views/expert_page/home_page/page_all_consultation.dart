import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/schedule/expert_agenda_list.dart';

class PageAllConsultation extends StatelessWidget {
  const PageAllConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExpertAgendaList(
      limit: 100,
      showHeader: true,
      useOwnScroll: true,
    );
  }
}
