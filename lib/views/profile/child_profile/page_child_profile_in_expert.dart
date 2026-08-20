import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/profile/child_profile_cmp.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/globals/dialog/badge_tooltip.dart';
import 'biodata_in_expert.dart';
import 'food_history_in_expert.dart';
import 'medical_history_in_expert.dart';
import 'page_z_score.dart';
import '../../../core/services/child/screening_service.dart';
import '../../../components/globals/chat_cache/chat_sync_service.dart';
import 'package:intl/intl.dart';

class PageChildProfileInExpert extends StatefulWidget {
  final String childUuid;
  final String? roomUuid;
  final String parentName;
  const PageChildProfileInExpert({
    super.key,
    required this.childUuid,
    this.roomUuid,
    this.parentName = 'Orang Tua',
  });

  @override
  State<PageChildProfileInExpert> createState() => _PageChildProfileInExpertState();
}

class _PageChildProfileInExpertState extends State<PageChildProfileInExpert> {
  String _childName = 'Memuat...';
  String _dob = '-';
  String _weight = '-';
  String _height = '-';
  String _medicalHistories = '-';
  String _allergies = '-';
  String _favorites = '-';
  String _avoided = '-';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load basic data from screening
      final screeningData = await ScreeningService().getLatestByChildUuid(widget.childUuid);
      _childName = screeningData.child.name;
      _dob = DateFormat('dd/MM/yyyy').format(screeningData.child.dob);
      _weight = screeningData.screening?.weight?.toStringAsFixed(1) ?? '-';
      _height = screeningData.screening?.height?.toString() ?? '-';

      // Load health/diet data if roomUuid is available
      if (widget.roomUuid != null) {
        final profileData = await ChatSyncService.fetchChildProfile(widget.roomUuid!);
        _medicalHistories = profileData.medicalHistories.isEmpty ? '-' : profileData.medicalHistories.join(', ');
        _allergies = profileData.allergies.isEmpty ? '-' : profileData.allergies.join(', ');
        _favorites = profileData.favorites.isEmpty ? '-' : profileData.favorites.join(', ');
        _avoided = profileData.avoided.isEmpty ? '-' : profileData.avoided.join(', ');
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('[PageChildProfileInExpert] Gagal memuat data: $e');
      if (mounted) {
        setState(() {
          _childName = 'Gagal memuat';
        });
      }
    }
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
                icon: Icon(Icons.arrow_back_ios_new)),
            Text(
              'Profil Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          ChildProfileCmp(
            childName: _childName,
            badge: TooltipStep.hebat,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageZScore(
                      childUuid: widget.childUuid,
                    ),
                  ));
            },
          ),
          Expanded(
            child: FullWidthTabBar(tabs: const [
              'Biodata',
              'Riwayat Makan',
              'Riwayat Medis',
            ], tabViews: [
              BiodataInExpert(
                childName: _childName,
                dob: _dob,
                weight: _weight,
                height: _height,
                medicalHistories: _medicalHistories,
                allergies: _allergies,
                favorites: _favorites,
                avoided: _avoided,
              ),
              const FoodHistoryInExpert(),
              MedicalHistoryInExpert(
                childUuid: widget.childUuid,
                roomUuid: widget.roomUuid,
                parentName: widget.parentName,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
