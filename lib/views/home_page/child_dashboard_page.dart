import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_cmp.dart';
import 'package:sporky_maxi/components/globals/button/cmp_floating_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/home_page_cmp/card_consultation.dart';
import 'package:sporky_maxi/components/home_page_cmp/insight_section.dart';
import 'package:sporky_maxi/components/home_page_cmp/learning_section.dart';

import 'package:sporky_maxi/components/home_page_cmp/promo_section.dart';

import '../../components/dashboard_page_cmp/child_profile/child_profile.dart';
import '../../components/home_page_cmp/carousel_section.dart';
import '../../components/meal_plan_cmp/cmp_top_meal_plan.dart';
import '../../core/services/child/child_service.dart';
import '../../core/utils/secure_storage_service.dart';
import '../initial_display/profil_si_kecil_flow_test.dart';
import '../profile/parent_profile.dart';

class ChildDashboardPage extends StatefulWidget {
  final VoidCallback? onDashboardTap;

  const ChildDashboardPage({super.key, this.onDashboardTap});

  @override
  State<ChildDashboardPage> createState() => _ChildDashboardPageState();
}

class _ChildDashboardPageState extends State<ChildDashboardPage> {
  late Future<List<String>> _childUuidsFuture;
  String _parentName = 'Bunda';
  String? _parentPhoto;
  String? _selectedChildUuid;

  @override
  void initState() {
    super.initState();
    _childUuidsFuture = ChildService().getChildUuids();
    _loadParentProfileCache();
    _loadSelectedChildUuid();
  }

  Future<void> _loadParentProfileCache() async {
    final name = await SecureStorageService.getUserName();
    final photo = await SecureStorageService.getUserPhoto();
    // debugPrint("👤 Parent name loaded: $name");
    if (mounted) {
      setState(() {
        _parentName = (name == null || name.trim().isEmpty) ? 'Bunda' : name;
        _parentPhoto = photo;
      });
    }
  }

  Future<void> _loadSelectedChildUuid() async {
    final uuid = await SecureStorageService.getSelectedChildUuid();
    if (mounted) {
      setState(() {
        _selectedChildUuid = uuid;
      });
    }
  }

  Future<void> _persistSelectedChildUuid(String uuid) async {
    await SecureStorageService.saveSelectedChildUuid(uuid);
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
        leadingWidth: MediaQuery.of(context).size.width,
        leading: TopBarParentCmp(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ParentProfile()),
            ).then((_) => _loadParentProfileCache());
          },
          name: _parentName,
          photoUrl: _parentPhoto,
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

                if (_selectedChildUuid == null ||
                    !childUuids.contains(_selectedChildUuid)) {
                  final fallbackUuid = childUuids.first;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _selectedChildUuid = fallbackUuid;
                      });
                    }
                  });
                  _persistSelectedChildUuid(fallbackUuid);
                }

                final selectedUuid =
                    (_selectedChildUuid != null &&
                        childUuids.contains(_selectedChildUuid))
                    ? _selectedChildUuid
                    : childUuids.first;

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ChildProfile(
                    childUuids: childUuids,
                    selectedChildUuid: selectedUuid,
                    showAddChildCard: true,
                    onAddChildTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilSiKecilFlowTest(),
                        ),
                      );
                    },
                    onChildSelected: (uuid) {
                      setState(() {
                        _selectedChildUuid = uuid;
                      });
                      _persistSelectedChildUuid(uuid);
                    },
                  ),
                );
              },
            ),

            /// =============== KOMPONEN SHORTCUT ================
            CmpTagAttention(
              text:
                  'Sudah cek kebutuhan gizi harian anak hari ini, Bun? Bekal sehat bantu tumbuh optimal!',
              imageAsset: 'assets/svg/ic_warn.svg',
            ),
            CardConsultation(onGrowthTap: widget.onDashboardTap),

            /// ================= KOMPONEN MENU =================
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Menu Terbaik Hari Ini',
                imageAsset: 'assets/svg/bento-box-rounded.svg',
                textAndImageColor: AppColors.primary1,
                wrapText: 1.5,
              ),
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Expanded(child: CmpTopMealPlan()),
              ],
            ),
            // =========== ads ===================
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                text: 'Penawaran Seru untuk Bunda',
                imageAsset: 'assets/svg/ic_ rocket.svg',
                textAndImageColor: AppColors.warn1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CarouselSection(),
            PromoSection(),
            // ============== ===================
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
