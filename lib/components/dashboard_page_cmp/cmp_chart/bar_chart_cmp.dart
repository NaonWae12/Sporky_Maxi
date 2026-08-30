import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/dashboard/food_history_service.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/components/dashboard/food_history_model.dart';

import '../../../views/dashboard_page/child_eating_history/main_page_eating_history.dart';
import '../../globals/chart/z_score_bar_chart.dart';
import 'food_waste_alert_cmp.dart';

class BarChartCmp extends StatefulWidget {
  final double heightButton;
  final String? childUuid;

  const BarChartCmp({super.key, this.heightButton = 22, this.childUuid});

  @override
  State<BarChartCmp> createState() => _BarChartCmpState();
}

class _BarChartCmpState extends State<BarChartCmp> {
  static const FoodHistoryService _service = FoodHistoryService();

  late Future<_WeeklyChartData> _chartFuture;

  @override
  void initState() {
    super.initState();
    _loadChart();
  }

  @override
  void didUpdateWidget(covariant BarChartCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childUuid != widget.childUuid) {
      _loadChart();
    }
  }

  void _loadChart() {
    _chartFuture = _fetchChartData();
  }

  Future<_WeeklyChartData> _fetchChartData() async {
    final childUuid =
        widget.childUuid?.trim() ??
        (await SecureStorageService.getSelectedChildUuid() ?? '').trim();

    if (childUuid.isEmpty) {
      throw Exception('Profil anak belum dipilih');
    }

    final summaries = await _service.getDailyNutritionHistory(
      childUuid: childUuid,
    );
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final days = List<DateTime>.generate(7, (index) {
      return weekStart.add(Duration(days: index));
    });

    final byDate = <String, DailyNutritionSummary>{};
    for (final summary in summaries) {
      byDate[_dateKey(summary.date)] = summary;
    }

    final data = days.map((day) {
      final summary = byDate[_dateKey(day)];
      return ZScoreBarChartData(day.day, summary?.calories ?? 0);
    }).toList();

    final maxCalories = data.fold<double>(
      0,
      (current, item) => item.y > current ? item.y : current,
    );

    return _WeeklyChartData(
      data: data,
      maxCalories: maxCalories,
      periodLabel:
          'Minggu ${DateFormat('d MMM', 'id_ID').format(weekStart)} - ${DateFormat('d MMM yyyy', 'id_ID').format(weekStart.add(const Duration(days: 6)))}',
    );
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalsCard(
          width: 90,
          hasShadow: false,
          padding: const EdgeInsets.only(left: 8),
          border: Border.all(color: AppColors.primary2),
          child: Row(
            children: [
              Text(
                'Mingguan',
                style: AppTextStyles.list1Bold(AppColors.primary1),
              ),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.primary1),
            ],
          ),
        ),
        FutureBuilder<_WeeklyChartData>(
          future: _chartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: TextButton(
                    onPressed: () => setState(_loadChart),
                    child: Text(
                      'Gagal memuat data kalori mingguan. Coba lagi',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            final chartData = snapshot.data;
            if (chartData == null || chartData.data.isEmpty) {
              return const SizedBox(
                height: 160,
                child: Center(child: Text('Belum ada data kalori mingguan')),
              );
            }

            final maxY = chartData.maxCalories <= 0
                ? 100.0
                : (chartData.maxCalories * 1.2).ceilToDouble();

            return SizedBox(
              height: 200,
              child: ZScoreBarChart(
                data: chartData.data,
                minY: 0,
                maxY: maxY,
                intervalY: maxY / 4,
                barColor: AppColors.primary1,
                trackColor: AppColors.primary2.withAlpha(70),
                barWidth: 0.3,
                borderRadius: 8,
              ),
            );
          },
        ),
        FutureBuilder<_WeeklyChartData>(
          future: _chartFuture,
          builder: (context, snapshot) {
            final label = snapshot.data?.periodLabel ?? 'Minggu ini';

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 9,
                  width: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary1,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(label, style: AppTextStyles.list1Regular()),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        FoodWasteAlertCmp(childUuid: widget.childUuid),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: GlobalsButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPageEatingHistory(),
                  ),
                ).then((_) {
                  if (mounted) setState(_loadChart);
                });
              },
              height: widget.heightButton,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Riwayat Makan Anak',
                    style: AppTextStyles.list1Bold(AppColors.base5),
                  ),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyChartData {
  final List<ZScoreBarChartData> data;
  final double maxCalories;
  final String periodLabel;

  const _WeeklyChartData({
    required this.data,
    required this.maxCalories,
    required this.periodLabel,
  });
}
