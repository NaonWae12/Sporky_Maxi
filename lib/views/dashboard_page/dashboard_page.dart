import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/cmp_chart/bar_chart_cmp.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/cmp_chart/z_score_line_chart_cmp.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../components/globals/card/cmp_tag_attention.dart';
import '../../components/home_page_cmp/learning_section.dart';
import '../../components/dashboard_page_cmp/child_profile/child_profile.dart';
import '../../components/dashboard_page_cmp/meal_plan_by_calorie_recommendation.dart';
import '../../core/services/child/child_service.dart';
import '../../core/utils/secure_storage_service.dart';
import '../../components/dashboard_page_cmp/child_biodata/child_biodata_cmp.dart';

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
    _loadActiveChildUuid();
  }

  Future<void> _loadActiveChildUuid() async {
    final uuid = await SecureStorageService.getSelectedChildUuid();
    if (mounted) {
      setState(() {
        activeChildUuid = uuid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Dashboard', style: AppTextStyles.heading2SemiBold()),
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

                // Cek jika activeChildUuid stale atau belum diset
                if (activeChildUuid == null ||
                    !childUuids.contains(activeChildUuid)) {
                  activeChildUuid = childUuids.isNotEmpty
                      ? childUuids.first
                      : null;
                  if (activeChildUuid != null) {
                    SecureStorageService.saveSelectedChildUuid(
                      activeChildUuid!,
                    );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ChildProfile(
                    childUuids: childUuids,
                    selectedChildUuid: activeChildUuid,
                    onChildSelected: (uuid) {
                      setState(() {
                        activeChildUuid = uuid;
                      });
                      SecureStorageService.saveSelectedChildUuid(uuid);
                    },
                  ),
                );
              },
            ),

            /// ================= ATTENTION =================
            CmpTagAttention(
              imageColor: AppColors.warn1,
              text:
                  'Asupan anak belum konsisten minggu ini. Ayo lengkapi asupan hariannya dan sempatkan aktivitas seru bersama!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),

            /// ================= BIODATA KESEHATAN ANAK =================
            if (activeChildUuid != null)
              ChildBiodataCmp(
                key: ValueKey('biodata_$activeChildUuid'),
                childUuid: activeChildUuid!,
              )
            else
              const SizedBox(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                text: 'Cek Perkembangan Anak, Yuk!',
                imageAsset: 'assets/svg/ic_ growth.svg',
              ),
            ),

            /// ================= Z SCORE CHART =================
            if (activeChildUuid != null)
              ZScoreLineChartCmp(
                key: ValueKey(activeChildUuid),
                childUuid: activeChildUuid!,
                limit: 60,
              )
            else
              const SizedBox(),

            CmpTagAttention(
              lineColor: AppColors.warn1,
              imageColor: AppColors.warn1,
              text:
                  'Beberapa hari terakhir z-score anak menurun. Yuk bantu stimulasi fisiknya lewat aktivitas seru di rumah!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),

            /// ================= Learning sectio =================
            LearningSection(),

            /// ================= Progres History =================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                wrapText: 1.50,
                textAndImageColor: AppColors.primary1,
                text: 'Progress Kalori Harian Anak',
                imageAsset: 'assets/svg/ic_pie_chart.svg',
              ),
            ),

            BarChartCmp(childUuid: activeChildUuid),

            /// ================= MEALPLAN REKOMENDASI BY CALORIES =================
            if (activeChildUuid != null)
              MealPlanByCalorieRecommendation(
                key: ValueKey('meal_calorie_$activeChildUuid'),
                childUuid: activeChildUuid!,
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
