import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_cmp.dart';
import 'package:sporky_maxi/components/globals/button/cmp_floating_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/home_page_cmp/card_consultation.dart';
import 'package:sporky_maxi/components/home_page_cmp/insight_section.dart';
import 'package:sporky_maxi/components/home_page_cmp/learning_section.dart';
import 'package:sporky_maxi/components/home_page_cmp/meal_plan_recommendation.dart';
import 'package:sporky_maxi/components/home_page_cmp/promo_section.dart';

import '../../components/dashboard_page_cmp/child_profile/child_profile.dart';
import '../../core/services/child/child_service.dart';
import '../../core/utils/secure_storage_service.dart';
import '../initial_display/profil_si_kecil_flow_test.dart';
import '../profile/parent_profile.dart';

class ChildDashboardPage extends StatefulWidget {
  const ChildDashboardPage({super.key});

  @override
  State<ChildDashboardPage> createState() => _ChildDashboardPageState();
}

class _ChildDashboardPageState extends State<ChildDashboardPage> {
  late Future<List<String>> _childUuidsFuture;
  String _parentName = 'Bunda';

  @override
  void initState() {
    super.initState();
    _childUuidsFuture = ChildService().getChildUuids();
    _loadParentName();
  }

  Future<void> _loadParentName() async {
    final name = await SecureStorageService.getUserName();
    // debugPrint("👤 Parent name loaded: $name");
    if (mounted) {
      setState(() {
        _parentName = name ?? 'Bunda';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: TopBarParentCmp(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentProfile(),
                ));
          },
          name: _parentName,
          chitChat: 'Bagaimana kondisi anakmu hari ini?',
        ),
      ),
      floatingActionButton: CmpFloatingActionButton(
        imagePath: 'assets/temp_img/parent.png',
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
                    showAddChildCard: true,
                    onAddChildTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilSiKecilFlowTest(),
                          ));
                    },
                  ),
                );
              },
            ),

            /// ================= KOMPONEN LAIN =================
            CmpTagAttention(
              text:
                  'Sudah cek kebutuhan gizi harian anak hari ini, Bun? Bekal sehat bantu tumbuh optimal!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),
            CardConsultation(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Menu Terbaik Hari Ini',
                imageAsset: 'assets/svg/bento-box-rounded.svg',
                textAndImageColor: AppColors.primary1,
                wrapText: 1.5,
              ),
            ),
            MealPlanRecommendation(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Penawaran Seru untuk Bunda',
                imageAsset: 'assets/svg/ic_ rocket.svg',
                textAndImageColor: AppColors.warn1,
              ),
            ),
            PromoSection(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Yuk, Nonton & Belajar!',
                imageAsset: 'assets/svg/ic_ play.svg',
                textAndImageColor: AppColors.secondary1,
                wrapText: 1.5,
              ),
            ),
            LearningSection(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Edukasi Ringan untuk Bunda',
                imageAsset: 'assets/svg/ic_ read - book.svg',
                textAndImageColor: AppColors.secondary1,
                wrapText: 1.5,
              ),
            ),
            InsightSection(),
          ],
        ),
      ),
    );
  }
}
