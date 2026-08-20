import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../core/services/child/eer_service.dart';
import '../../../core/services/child/screening_service.dart';
import '../../../core/utils/age_helper.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../../models/components/child/child_latest_screening_model.dart';
import '../../globals/dialog/badge_tooltip.dart';
import '../../globals/profile_cmp/child_profile_section.dart';
import '../../globals/dialog/dialog_alert.dart';

class ChildProfile extends StatefulWidget {
  final List<String> childUuids;
  final ValueChanged<String>? onChildSelected;
  final String? selectedChildUuid;

  // Opsional: tampilkan card tambah anak
  final bool showAddChildCard;
  final VoidCallback? onAddChildTap;

  const ChildProfile({
    super.key,
    required this.childUuids,
    this.onChildSelected,
    this.selectedChildUuid,
    this.showAddChildCard = false,
    this.onAddChildTap,
  });

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  final Map<String, Future<ChildLatestScreening>> _screeningFutureCache = {};
  Future<TooltipStep>? _activeStepFuture;
  String? _alertShownForChildUuid;

  /// Mengubah nilai status nutrisi dari BE (misal "gizi_buruk", "GIZI_LEBIH")
  /// menjadi label tampilan yang rapi dan konsisten dalam Bahasa Indonesia.
  String _formatNutritionStatus(String? raw) {
    if (raw == null || raw.trim().isEmpty || raw.trim() == '-') return '-';
    const lookup = <String, String>{
      'gizi_buruk': 'Gizi Buruk',
      'gizi_kurang': 'Gizi Kurang',
      'gizi_normal': 'Gizi Normal',
      'gizi_baik': 'Gizi Baik',
      'gizi_lebih': 'Gizi Lebih',
      'obesitas': 'Obesitas',
      'overweight': 'Kelebihan Berat',
      'underweight': 'Kekurangan Berat',
    };
    final key = raw.trim().toLowerCase();
    if (lookup.containsKey(key)) return lookup[key]!;
    // Fallback generik: ganti '_' dengan spasi, title-case setiap kata
    return key
        .split('_')
        .map(
            (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  Future<TooltipStep> _fetchActiveSubscriptionStep() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[ChildProfile] Active subscription token tidak ditemukan');
        return TooltipStep.awal;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.activeSubscription),
        headers: {
          'Authorization': token,
          'Accept': 'application/json',
        },
      );

      debugPrint(
        '[ChildProfile] Active subscription status: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        return TooltipStep.awal;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return TooltipStep.awal;
      }

      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        return TooltipStep.awal;
      }

      final package = data['package'];
      if (package is! Map<String, dynamic>) {
        return TooltipStep.awal;
      }

      final stepRaw = (package['step']?.toString() ?? '').trim();
      final normalizedStep = stepRaw.trim().toLowerCase();
      final mappedStep = _toTooltipStep(normalizedStep);

      return mappedStep;
    } catch (e) {
      debugPrint('[ChildProfile] Active subscription fetch error: $e');
      return TooltipStep.awal;
    }
  }

  TooltipStep _toTooltipStep(String step) {
    switch (step) {
      case 'awal':
        return TooltipStep.awal;
      case 'pertama':
        return TooltipStep.pertama;
      case 'pasti':
        return TooltipStep.pasti;
      case 'hebat':
        return TooltipStep.hebat;
      case 'lengkap':
        return TooltipStep.lengkap;
      default:
        return TooltipStep.awal;
    }
  }

  Future<double> _fetchTodayCalories(String childUuid) async {
    try {
      final token = await SecureStorageService.getToken();
      // debugPrint(
      //     '[ChildProfile] Token present: ${token != null && token.isNotEmpty}');
      if (token == null || token.isEmpty) return 0.0;

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final localTodayStr = DateTime.now().toLocal().toString().split(' ')[0];
      final uri = Uri.parse(ApiEndpoints.totalCalories).replace(
        queryParameters: {
          'child_uuid': childUuid,
          'date': localTodayStr,
        },
      );
      // debugPrint('[ChildProfile] GET $uri');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      // debugPrint(
      //     '[ChildProfile] HTTP Response Status Code: ${response.statusCode}');
      // debugPrint('[ChildProfile] HTTP Response Body: ${response.body}');

      if (response.statusCode != 200) {
        debugPrint(
            '[ChildProfile] Failed to fetch total calories, status code is not 200');
        return 0.0;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        debugPrint('[ChildProfile] Decoded response is not a Map');
        return 0.0;
      }

      final dataNode = decoded['data'];
      if (dataNode is! Map<String, dynamic>) {
        debugPrint('[ChildProfile] data field is not a Map: $dataNode');
        return 0.0;
      }

      final totalCaloriesVal = dataNode['total_calories'];
      // debugPrint('[ChildProfile] Raw total_calories: $totalCaloriesVal');

      if (totalCaloriesVal is num) {
        final val = totalCaloriesVal.toDouble();
        // debugPrint('[ChildProfile] Parsed total calories as double: $val');
        return val;
      } else if (totalCaloriesVal is String) {
        final val = double.tryParse(totalCaloriesVal) ?? 0.0;
        debugPrint('[ChildProfile] Parsed total calories from string: $val');
        return val;
      }
      debugPrint('[ChildProfile] total_calories is null or not a valid type');
      return 0.0;
    } catch (e) {
      debugPrint('[ChildProfile] Error fetching today calories: $e');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screeningService = ScreeningService();
    final activeStepFuture =
        _activeStepFuture ??= _fetchActiveSubscriptionStep();

    return FutureBuilder<TooltipStep>(
      future: activeStepFuture,
      builder: (context, stepSnapshot) {
        final activeStep = stepSnapshot.data ?? TooltipStep.awal;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Existing child cards
              ...widget.childUuids.map((childUuid) {
                final screeningFuture = _screeningFutureCache.putIfAbsent(
                  childUuid,
                  () => screeningService.getLatestByChildUuid(childUuid),
                );

                return FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    screeningFuture,
                    _fetchTodayCalories(childUuid),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 372,
                          height: 140,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 372,
                          height: 140,
                          child: Center(
                            child: Text('Gagal memuat data anak'),
                          ),
                        ),
                      );
                    }

                    final combined = snapshot.data!;
                    final data = combined[0] as ChildLatestScreening;
                    final todayCalories = combined[1] as double;

                    final screening = data.screening;
                    final eer = screening?.eer;
                    final age = calculateAge(data.child.dob);
                    final isSelected =
                        data.child.uuid == widget.selectedChildUuid;

                    final rawEer =
                        eer == null ? 0 : EERService.roundToClosest(eer);
                    final targetEer = rawEer == 0 ? 2000 : rawEer;

                    debugPrint(
                      '[ChildProfile] ${data.child.name} '
                      '(UUID: ${data.child.uuid}) '
                      'nutritionStatus: ${screening?.nutritionStatus ?? '-'}',
                    );

                    debugPrint(
                      '[ChildProfile] EER asli: $eer, Target EER: $targetEer, Hari ini: $todayCalories',
                    );

                    final percent =
                        targetEer > 0 ? (todayCalories / targetEer) : 0.0;

                    // Munculkan dialog alert jika kalori melebihi EER dan anak ini yang sedang aktif dipilih
                    if (isSelected &&
                        todayCalories > targetEer &&
                        _alertShownForChildUuid != data.child.uuid) {
                      _alertShownForChildUuid = data.child.uuid;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        DialogAlert.show(
                          context: context,
                          barrierDismissible: true,
                          child: Content1(
                            title: 'Kalori Melebihi Batas!',
                            titleStyle:
                                AppTextStyles.heading1SemiBold(AppColors.warn4),
                            image: 'assets/giff/fail.gif',
                            message:
                                'Waduh, konsumsi kalori harian ${data.child.name} sudah melebihi target EER (${targetEer.round()} kkal) hari ini.',
                            messageStyle:
                                AppTextStyles.desc1Regular(AppColors.base1),
                            textNav: 'Tutup',
                            textNavStyle:
                                AppTextStyles.headList1Bold(AppColors.base5),
                            colorButton: AppColors.primary1,
                            iconAsset: 'assets/svg/ic_warn.svg',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      });
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () =>
                            widget.onChildSelected?.call(data.child.uuid),
                        child: AnimatedScale(
                          scale: isSelected ? 1.01 : 1.0,
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary1.withAlpha(50),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Stack(
                              children: [
                                ChildProfileSection(
                                  badgeTooltip: activeStep,
                                  childName: data.child.name,
                                  ageYear: age['year'] ?? 0,
                                  ageMonth: age['month'] ?? 0,
                                  tb: screening?.height ?? 0,
                                  bb: screening?.weight?.round() ?? 0,
                                  status: _formatNutritionStatus(
                                      screening?.nutritionStatus),
                                  score: todayCalories.round(),
                                  percent: percent,
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.base5,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary1,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: AppColors.primary1,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              // Add child card (optional)
              if (widget.showAddChildCard)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: widget.onAddChildTap,
                    child: SizedBox(
                      width: 372,
                      height: 140,
                      child: Card(
                        color: AppColors.primary3,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tambah Anak',
                                style: AppTextStyles.lable2Regular(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
