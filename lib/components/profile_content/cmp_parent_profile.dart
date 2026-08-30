import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/profile_parent_section.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/progres_section.dart';

import '../../components/globals/text/text_style.dart';
import '../../views/profile/page_daily_activity.dart';
import '../../views/profile/page_setting_profile/page_setting_child_profile.dart';
import '../globals/colors/colors.dart';
import 'cmp_parent_profile/daily_missions.dart';
import 'cmp_parent_profile/information_center.dart';
import 'cmp_parent_profile/mission_icon_resolver.dart';
import 'cmp_parent_profile/packages_and_coupons.dart';
import 'cmp_parent_profile/profile_child_section.dart';

class CmpParentProfile extends StatefulWidget {
  final String name;
  final int? countNotif;
  final String? photoUrl;
  final String badgeImg;
  final VoidCallback directToEditPage;
  final String childName;
  final int childAgeYear;
  final int childAgeMonth;

  const CmpParentProfile({
    super.key,
    required this.directToEditPage,
    required this.name,
    this.photoUrl,
    this.countNotif,
    required this.badgeImg,
    required this.childName,
    required this.childAgeYear,
    required this.childAgeMonth,
  });

  @override
  State<CmpParentProfile> createState() => _CmpParentProfileState();
}

class _CmpParentProfileState extends State<CmpParentProfile> {
  final GlobalKey<ProgresSectionState> _progresKey =
      GlobalKey<ProgresSectionState>();
  bool _isLoading = true;
  String? _errorMessage;
  int _totalCount = 0;
  int _pendingCount = 0;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchDailyTasks();
  }

  Future<void> _fetchDailyTasks() async {
    _progresKey.currentState?.fetchProgress();
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Token tidak ditemukan';
          });
        }
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final uri = Uri.parse(ApiEndpoints.dailyTasks);

      final response = await http.get(
        uri,
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final tasksList = decoded['tasks'] as List? ?? [];
        final progress = decoded['progress'] as Map<String, dynamic>? ?? {};

        if (mounted) {
          setState(() {
            _totalCount =
                int.tryParse(progress['total']?.toString() ?? '') ??
                tasksList.length;
            _pendingCount =
                int.tryParse(progress['pending']?.toString() ?? '') ??
                tasksList.length;
            _tasks = tasksList.map((e) => e as Map<String, dynamic>).toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Gagal memuat tugas harian';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileParentSection(
          directToEditPage: widget.directToEditPage,
          name: widget.name,
          photoUrl: widget.photoUrl,
          countNotif: widget.countNotif,
        ),
        // progress content
        ProgresSection(key: _progresKey, badgeImg: widget.badgeImg),
        _isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary1,
                    ),
                  ),
                ),
              )
            : _errorMessage != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    'Gagal memuat tugas harian',
                    style: AppTextStyles.list1Regular(AppColors.warn1),
                  ),
                ),
              )
            : Builder(
                builder: (context) {
                  // Buat list MissionData sekali, dipakai di profil & halaman penuh
                  final missionDataList = _tasks.map((task) {
                    final uuid = task['uuid']?.toString() ?? '';
                    final title = task['title']?.toString() ?? '';
                    final category = task['category']?.toString() ?? '';
                    final description = task['description']?.toString() ?? '';
                    final points = (task['point'] as num?)?.toInt() ?? 0;
                    final status = task['status']?.toString() ?? 'pending';
                    final iconAsset = MissionIconResolver.resolveIcon(
                      category,
                      title,
                      description,
                    );
                    final iconColor = MissionIconResolver.resolveColor(
                      iconAsset,
                      category,
                      title,
                      description,
                    );
                    return MissionData(
                      uuid: uuid,
                      iconAsset: iconAsset,
                      iconColor: iconColor,
                      label: title,
                      points: points,
                      status: status,
                    );
                  }).toList();

                  return DailyMissions(
                    missionCount: _pendingCount,
                    totalCount: _totalCount,
                    missions: missionDataList,
                    onTaskCompleted: _fetchDailyTasks,
                    onSeeAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PageDailyActivity(
                            dailyMissions: missionDataList,
                            dailyPending: _pendingCount,
                            dailyTotal: _totalCount,
                            onTaskCompleted: _fetchDailyTasks,
                          ),
                        ),
                      ).then((_) => _fetchDailyTasks());
                    },
                  );
                },
              ),
        ProfileChildSection(
          childName: widget.childName,
          ageMonth: widget.childAgeMonth,
          ageYear: widget.childAgeYear,
          status: 'Normal',
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageSettingChildProfile(),
              ),
            );
          },
        ),
        const PackagesAndCouponsList(
          data: [
            {
              'title': 'Langkah Untuk Masa Depan',
              'name': 'Kiara Alicia',
              'badgeImg': 'assets/svg/sun.svg',
              'validUntil': '31 Juni 2026',
              'expertGroup': true,
            },
            {
              'title': 'Konsultasi Hebat',
              'name': 'Rafa Pratama',
              'badgeImg': 'assets/svg/ic_ doctor.svg',
              'validUntil': '15 Agustus 2026',
              'expertGroup': false,
              'imageColor': AppColors.base1,
            },
            {
              'title': 'Langkah Untuk Masa Depan',
              'name': 'Kiara Alicia',
              'badgeImg': 'assets/svg/sun.svg',
              'validUntil': '31 Juni 2026',
              'expertGroup': true,
            },
          ],
        ),
        const InformationCenter(),
      ],
    );
  }
}
