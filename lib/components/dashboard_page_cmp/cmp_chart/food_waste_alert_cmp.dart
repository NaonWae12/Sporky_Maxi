import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class FoodWasteAlertCmp extends StatefulWidget {
  final String? childUuid;

  const FoodWasteAlertCmp({
    super.key,
    this.childUuid,
  });

  @override
  State<FoodWasteAlertCmp> createState() => _FoodWasteAlertCmpState();
}

class _FoodWasteAlertCmpState extends State<FoodWasteAlertCmp> {
  bool _isLoading = false;
  Map<String, dynamic>? _summaryData;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  @override
  void didUpdateWidget(covariant FoodWasteAlertCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childUuid != widget.childUuid) {
      _fetchSummary();
    }
  }

  Future<void> _fetchSummary() async {
    final uuid = widget.childUuid;
    if (uuid == null || uuid.isEmpty) {
      if (mounted) {
        setState(() {
          _summaryData = null;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) return;
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final now = DateTime.now();
      final currentMonth =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final uri = Uri.parse(
        ApiEndpoints.foodWasteMonthlySummary(uuid, month: currentMonth),
      );
      debugPrint('[FoodWasteAlertCmp] GET $uri');

      final response = await http.get(uri, headers: {
        'Authorization': authHeader,
        'Accept': 'application/json',
      });

      debugPrint('[FoodWasteAlertCmp] status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] != null) {
          if (mounted) {
            setState(() {
              _summaryData = decoded['data'] as Map<String, dynamic>;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[FoodWasteAlertCmp] Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_summaryData == null) {
      return const SizedBox.shrink();
    }

    final alert = _summaryData!['alert'] as Map<String, dynamic>? ?? {};
    final summary = _summaryData!['summary'] as Map<String, dynamic>? ?? {};
    final narration = _summaryData!['narration'] as Map<String, dynamic>? ?? {};

    final alertType = alert['type']?.toString().toLowerCase() ?? 'success';
    final periodLabel = alert['period_label']?.toString() ?? 'Bulan Ini';

    final totalRecords = summary['total_records']?.toString() ?? '0';
    final avgPct = summary['avg_consumption_pct']?.toString() ?? '0';
    final statusLabel = summary['status_label']?.toString() ?? '-';

    final title = narration['title']?.toString() ?? '';
    final summaryText = narration['summary']?.toString() ?? '';

    // Determine colors based on alert type
    Color primaryColor = AppColors.success2;
    Color bgColor = AppColors.success1.withAlpha(20);
    IconData icon = Icons.check_circle_outline_rounded;

    if (alertType == 'warning') {
      primaryColor = AppColors.primary1;
      bgColor = AppColors.primary3.withAlpha(80);
      icon = Icons.warning_amber_rounded;
    } else if (alertType == 'danger' || alertType == 'error') {
      primaryColor = AppColors.warn1;
      bgColor = AppColors.warn3.withAlpha(80);
      icon = Icons.error_outline_rounded;
    } else if (alertType == 'info') {
      primaryColor = AppColors.info1;
      bgColor = AppColors.info1.withAlpha(20);
      icon = Icons.info_outline_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.base5,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.base4,
            width: 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Accent bar
                Container(
                  width: 6,
                  color: primaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              periodLabel,
                              style: AppTextStyles.list1Bold(AppColors.secondary1),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: AppTextStyles.list3SemiBold(primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Summary Content
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Big Percentage Display
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withAlpha(20),
                                border: Border.all(
                                  color: primaryColor.withAlpha(51),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$avgPct%',
                                  style: AppTextStyles.heading1SemiBold(primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Summary Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title.isNotEmpty ? title : 'Statistik Konsumsi',
                                    style: AppTextStyles.heading3SemiBold(AppColors.base1),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    summaryText.isNotEmpty
                                        ? summaryText
                                        : 'Si Kecil menghabiskan rata-rata $avgPct% makanannya.',
                                    style: AppTextStyles.list1Regular(AppColors.base2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: AppColors.base4,
                          thickness: 1,
                        ),
                        const SizedBox(height: 4),
                        // Bottom Meta info
                        Row(
                          children: [
                            const Icon(
                              Icons.history_toggle_off_rounded,
                              size: 14,
                              color: AppColors.base2,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Berdasarkan $totalRecords catatan makan',
                              style: AppTextStyles.list3SemiBold(AppColors.base2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
