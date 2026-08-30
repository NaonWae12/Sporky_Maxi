import 'package:flutter/material.dart';
import '../../../components/globals/button/globals_button.dart';
import '../../../components/globals/card/globals_card.dart';
import '../../../components/globals/chart/syncfusion_z_score_chart.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/dialog/globals_bottom_sheet.dart';
import '../../../components/globals/text/text_style.dart';
import '../../../core/services/child/z_score_chart_service.dart';
import '../../../models/components/child/z_score_chart_point_model.dart';
import '../../../views/dashboard_page/update_data/update_child/page_child_growth_updates.dart';

enum ChartMode { weekly, monthly }

class ZScoreLineChartCmp extends StatefulWidget {
  final String childUuid;
  final int limit;
  final bool showButton;
  final double heightButton;

  const ZScoreLineChartCmp({
    super.key,
    required this.childUuid,
    this.limit = 30,
    this.showButton = true,
    this.heightButton = 22,
  });

  @override
  State<ZScoreLineChartCmp> createState() => _ZScoreLineChartCmpState();
}

class _ZScoreLineChartCmpState extends State<ZScoreLineChartCmp> {
  bool isLoading = true;
  List<ZScoreChartPoint> allPoints = [];
  List<ChartData> chartData = [];
  ChartMode chartMode = ChartMode.weekly;

  double minX = 0, maxX = 0, minY = -3, maxY = 3;

  @override
  void initState() {
    super.initState();
    _loadZScoreChart();
  }

  Future<void> _loadZScoreChart() async {
    try {
      final points = await ZScoreChartService().getZScoreChart(
        childUuid: widget.childUuid,
        limit: widget.limit,
      );
      allPoints = points;
      _mapChartData();
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("❌ ZScore Chart Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _switchMode(ChartMode mode) {
    setState(() {
      chartMode = mode;
      _mapChartData();
    });
  }

  void _mapChartData() {
    if (allPoints.isEmpty) {
      chartData = [];
      return;
    }

    if (chartMode == ChartMode.weekly) {
      chartData = allPoints.asMap().entries.map((entry) {
        return ChartData((entry.key + 1).toDouble(), entry.value.y);
      }).toList();
    } else {
      // Bulanan: average per month
      Map<int, List<ZScoreChartPoint>> monthMap = {};
      for (var point in allPoints) {
        final month = DateTime.fromMillisecondsSinceEpoch(
          point.x.toInt(),
        ).month;
        monthMap.putIfAbsent(month, () => []).add(point);
      }

      chartData = monthMap.entries.map((entry) {
        final avgY =
            entry.value.map((e) => e.y).reduce((a, b) => a + b) /
            entry.value.length;
        return ChartData(entry.key.toDouble(), avgY);
      }).toList();
      chartData.sort((a, b) => a.x.compareTo(b.x));
    }

    minX = chartData.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    maxX = chartData.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    minY = chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 3;
    maxY = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ===== FILTER MODE =====
        GlobalsCard(
          width: 120,
          hasShadow: false,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          border: Border.all(color: AppColors.primary2),
          child: InkWell(
            onTap: () async {
              final result = await showAppBottomSheet<ChartMode>(
                context: context,
                isScrollControlled: false,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Mingguan',
                        style: AppTextStyles.headList1Regular(
                          chartMode == ChartMode.weekly
                              ? AppColors.primary1
                              : AppColors.base1,
                        ),
                      ),
                      trailing: chartMode == ChartMode.weekly
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary1,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, ChartMode.weekly),
                    ),
                    ListTile(
                      title: Text(
                        'Bulanan',
                        style: AppTextStyles.headList1Regular(
                          chartMode == ChartMode.monthly
                              ? AppColors.primary1
                              : AppColors.base1,
                        ),
                      ),
                      trailing: chartMode == ChartMode.monthly
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary1,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, ChartMode.monthly),
                    ),
                  ],
                ),
              );
              if (result != null) _switchMode(result);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chartMode == ChartMode.weekly ? 'Mingguan' : 'Bulanan',
                  style: AppTextStyles.list1Bold(AppColors.primary1),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColors.primary1),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        /// ===== CHART =====
        if (isLoading)
          const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (chartData.isEmpty)
          SizedBox(
            height: 220,
            child: Center(
              child: Text(
                "Data z-score belum tersedia",
                style: AppTextStyles.list1Regular(),
              ),
            ),
          )
        else
          SyncfusionZScoreChart(
            data: chartData,
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            lineColor: AppColors.primary2,
            fillColor: AppColors.primary2,
          ),

        const SizedBox(height: 12),

        /// ===== FOOTNOTE =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 9,
              width: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary1,
                boxShadow: [
                  BoxShadow(color: AppColors.primary1, blurRadius: 5),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Text('Riwayat Z-Score Anak', style: AppTextStyles.list1Regular()),
          ],
        ),

        /// ===== BUTTON (opsional) =====
        if (widget.showButton)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: GlobalsButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageChildGrowthUpdates(),
                    ),
                  );
                },
                height: widget.heightButton,
                width: MediaQuery.of(context).size.width / 1.1,
                color: AppColors.secondary1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GlobalsButtonText(
                        text: 'Update Data Anak',
                        style: AppTextStyles.list1Bold(AppColors.base5),
                      ),
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
