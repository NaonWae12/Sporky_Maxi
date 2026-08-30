import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/child/z_score_chart_service.dart';
import 'package:sporky_maxi/models/components/child/z_score_chart_point_model.dart';

import '../../../components/dashboard_page_cmp/cmp_chart/z_score_line_chart_cmp.dart';
import '../../../components/expert_components/profile/child_development_cmp.dart';

class PageZScore extends StatefulWidget {
  final String childUuid;
  final String? childName;

  const PageZScore({
    super.key,
    this.childName = 'Kiano',
    required this.childUuid,
  });

  @override
  State<PageZScore> createState() => _PageZScoreState();
}

class _PageZScoreState extends State<PageZScore> {
  static final ZScoreChartService _service = ZScoreChartService();

  late Future<List<ZScoreChartPoint>> _pointsFuture;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() {
    _pointsFuture = _service.getZScoreChart(
      childUuid: widget.childUuid,
      limit: 60,
    );
  }

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
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            Text(
              'Z-Score ${widget.childName ?? 'Anak'}',
              style: AppTextStyles.heading2SemiBold(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZScoreLineChartCmp(
              showButton: false,
              childUuid: widget.childUuid,
              limit: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                text: 'Detail Perkembangan Anak',
                textStyle: AppTextStyles.heading3SemiBold(AppColors.secondary1),
                imageAsset: 'assets/svg/ic_ growth.svg',
              ),
            ),
            FutureBuilder<List<ZScoreChartPoint>>(
              future: _pointsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: TextButton(
                        onPressed: () => setState(_loadPoints),
                        child: const Text(
                          'Gagal memuat detail perkembangan. Coba lagi',
                        ),
                      ),
                    ),
                  );
                }

                final points = snapshot.data ?? [];
                if (points.isEmpty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: Text('Belum ada data perkembangan')),
                  );
                }

                final latestPoints = points.reversed.take(10).toList();
                return Column(
                  children: latestPoints.map((point) {
                    return ChildDevelopmentCmp(
                      zScore: point.y.toStringAsFixed(2),
                      weight: '-',
                      height: '-',
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
