// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/cmp_chart/bar_chart_cmp.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/cmp_chart/z_score_line_chart_cmp.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../components/globals/card/cmp_tag_attention.dart';
import '../../components/home_page_cmp/learning_section.dart';
import '../../components/home_page_cmp/meal_plan_recommendation.dart';
import '../../components/dashboard_page_cmp/child_profile/child_profile.dart';
import '../../core/services/child/child_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<String>> _childUuidsFuture;
  String? activeChildUuid;

  @override
  void initState() {
    super.initState();
    _childUuidsFuture = ChildService().getChildUuids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ================= CHILD PROFILE =================
            FutureBuilder<List<String>>(
              future: _childUuidsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Gagal memuat data anak"),
                  );
                }

                final childUuids = snapshot.data ?? [];

                if (childUuids.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Belum ada data anak"),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ChildProfile(
                    childUuids: childUuids,
                    onChildSelected: (uuid) {
                      setState(() {
                        activeChildUuid = uuid;
                      });
                    },
                  ),
                );
              },
            ),

            /// ================= ATTENTION =================
            CmpTagAttention(
              imageColor: AppColors.warn1,
              text:
                  'Asupan Kiara belum konsisten minggu ini. Ayo, lengkapi asupan hariannya dan sempatkan aktivitas seru bersama!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                text: 'Cek Perkembangan Kiara, Yuk!',
                imageAsset: 'assets/svg/ic_ growth.svg',
              ),
            ),

            /// ================= Z SCORE CHART (FIXED) =================
            FutureBuilder<List<String>>(
              future: _childUuidsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox();
                }

                final activeChildUuid = snapshot.data!.first;

                return ZScoreLineChartCmp(
                  childUuid: activeChildUuid,
                  limit: 60,
                );
              },
            ),

            CmpTagAttention(
              lineColor: AppColors.warn1,
              imageColor: AppColors.warn1,
              text:
                  'Beberapa hari terakhir z-score Kiara turun. Yuk bantu stimulasi fisiknya lewat aktivitas seru di rumah!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),

            LearningSection(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                wrapText: 1.50,
                textAndImageColor: AppColors.primary1,
                text: 'Progress Kalori Harian Kiara',
                imageAsset: 'assets/svg/ic_pie_chart.svg',
              ),
            ),

            BarChartCmp(),

            CmpTagAttention(
              lineColor: AppColors.warn1,
              imageColor: AppColors.warn1,
              text:
                  'Hari ini Kiara masih mendapatkan 30% kalori. Yuk lengkapi energi Kiara! ',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),

            MealPlanRecommendation(),
          ],
        ),
      ),
    );
  }
}
