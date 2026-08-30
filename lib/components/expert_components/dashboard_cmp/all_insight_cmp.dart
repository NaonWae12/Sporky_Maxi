import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/expert_feature/expert_feature_service.dart';
import 'package:sporky_maxi/models/components/expert_feature/expert_insight_model.dart';
import 'package:sporky_maxi/views/expert_page/home_page/page_agenda_consultations.dart';

import 'chat_card_cmp.dart';
import 'total_card_cmp.dart';
import 'zoom_card_cmp.dart';

class AllInsightCmp extends StatefulWidget {
  final String period;

  const AllInsightCmp({super.key, this.period = 'all'});

  @override
  State<AllInsightCmp> createState() => _AllInsightCmpState();
}

class _AllInsightCmpState extends State<AllInsightCmp> {
  static const ExpertFeatureService _service = ExpertFeatureService();

  late Future<ExpertConsultationInsight> _insightFuture;

  @override
  void initState() {
    super.initState();
    _insightFuture = _service.getConsultationInsight(period: widget.period);
  }

  @override
  void didUpdateWidget(AllInsightCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _insightFuture = _service.getConsultationInsight(period: widget.period);
    }
  }

  void _retry() {
    setState(() {
      _insightFuture = _service.getConsultationInsight(period: widget.period);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExpertConsultationInsight>(
      future: _insightFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: TextButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Gagal memuat insight'),
            ),
          );
        }

        final insight = snapshot.data;
        if (insight == null) {
          return Center(
            child: Text(
              'Insight belum tersedia',
              style: AppTextStyles.list1Regular(AppColors.base2),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChatCardCmp(count: insight.chatCount.toString()),
                ZoomCardCmp(count: insight.zoomCount.toString()),
                TotalCardCmp(count: insight.totalCount.toString()),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageAgendaConsultations(),
                    ),
                  );
                },
                child: GlobalsCardOutlined(
                  backgroundColor: Colors.transparent,
                  height: 30,
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Riwayat Konsultasi',
                        style: AppTextStyles.list1Bold(),
                      ),
                      const Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
