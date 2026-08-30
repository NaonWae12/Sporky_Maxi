import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_in_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/profile_cmp/in_expert/child_profile_in_box.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/child/screening_service.dart';
import 'package:sporky_maxi/core/utils/age_helper.dart';
import 'package:sporky_maxi/models/components/child/child_latest_screening_model.dart';
import 'package:sporky_maxi/views/expert_page/chatroom/chating_page.dart';
import 'package:sporky_maxi/views/expert_page/medical_record/page_medical_record.dart';

import '../../../components/globals/dialog/badge_tooltip.dart';
import '../../../components/globals/dialog/child_profile_in_expert.dart';
import '../../profile/child_profile/page_child_profile_in_expert.dart';
import '../../../components/globals/chat_cache/chat_sync_service.dart';

class DetailProfile extends StatefulWidget {
  final String childUuid;
  final String roomUuid;
  final String parentName;
  const DetailProfile({
    super.key,
    required this.childUuid,
    required this.roomUuid,
    this.parentName = 'Orang Tua',
  });

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  String _childName = 'Anak';
  int _ageYear = 0;
  int _ageMonth = 0;
  String _nutritionStatus = '-';
  String _weight = '-';
  String _height = '-';
  String _medicalHistories = '-';
  String _allergies = '-';

  @override
  void initState() {
    super.initState();
    _loadChildProfile();
  }

  String get _resolvedParentName {
    final normalized = widget.parentName.trim();
    return normalized.isEmpty ? 'Orang Tua' : normalized;
  }

  Future<void> _loadChildProfile() async {
    final childUuid = widget.childUuid.trim();
    if (childUuid.isEmpty) return;

    try {
      final data = await ScreeningService().getLatestByChildUuid(childUuid);
      final profileData = await ChatSyncService.fetchChildProfile(
        widget.roomUuid,
      );

      if (!mounted) return;

      _applyChildData(data);

      setState(() {
        _medicalHistories = profileData.medicalHistories.isEmpty
            ? '-'
            : profileData.medicalHistories.join(', ');
        _allergies = profileData.allergies.isEmpty
            ? '-'
            : profileData.allergies.join(', ');
      });
    } catch (e) {
      debugPrint('[DetailProfile] Gagal memuat profil anak: $e');
    }
  }

  void _applyChildData(ChildLatestScreening data) {
    final childName = data.child.name.trim().isEmpty
        ? 'Anak'
        : data.child.name.trim();
    final age = calculateAge(data.child.dob);
    final nutritionStatus = (data.screening?.nutritionStatus ?? '').trim();

    setState(() {
      _childName = childName;
      _ageYear = age['year'] ?? 0;
      _ageMonth = age['month'] ?? 0;
      _nutritionStatus = nutritionStatus.isEmpty ? '-' : nutritionStatus;
      _weight = data.screening?.weight?.toStringAsFixed(1) ?? '-';
      _height = data.screening?.height?.toString() ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            TopBarParentInExpertCmp(
              parentName: _resolvedParentName,
              childName: _childName,
              isActive: true,
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            lineColor: AppColors.base1,
            imageColor: AppColors.base1,
            imageAsset: 'assets/svg/ic_warn.svg',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesi Konsultasi Chat belum dimulai',
                  style: AppTextStyles.list1Bold(),
                ),
                Text(
                  'Klik tombol “Mulai Konsultasi” sesuai jadwal. Cek profil anak untuk pahami kondisinya.',
                  style: AppTextStyles.list1Regular(),
                ),
              ],
            ),
          ),
          ChildProfileInBox(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ChildProfileInExpert(
                      childName: _childName,
                      ageMonth: _ageMonth,
                      ageYear: _ageYear,
                      status: _nutritionStatus,
                      weight: _weight,
                      height: _height,
                      medicalHistories: _medicalHistories,
                      allergies: _allergies,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageChildProfileInExpert(
                              childUuid: widget.childUuid,
                              roomUuid: widget.roomUuid,
                              parentName: _resolvedParentName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            isAsset: true,
            photoUrl: 'assets/temp_img/kids.png',
            childName: _childName,
            ageMonth: _ageMonth,
            ageYear: _ageYear,
            status: _nutritionStatus,
            step: TooltipStep.awal,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PageMedicalRecord(roomUuid: widget.roomUuid),
                ),
              );
            },
            child: const Text('Buka Rekam Medis'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GlobalsButton(
          color: AppColors.secondary1,
          text: 'Mulai Sesi',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatingPage(
                  roomUuid: widget.roomUuid,
                  parentName: _resolvedParentName,
                  childName: _childName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
