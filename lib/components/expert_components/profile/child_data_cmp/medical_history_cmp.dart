import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/expert_feature/expert_feature_service.dart';
import 'package:sporky_maxi/models/components/expert_feature/child_medical_model.dart';
import 'package:sporky_maxi/views/profile/child_profile/medical_history_details_page.dart';

class MedicalHistoryCmp extends StatefulWidget {
  final String childUuid;
  final String? roomUuid;
  final String parentName;

  const MedicalHistoryCmp({
    super.key,
    required this.childUuid,
    this.roomUuid,
    required this.parentName,
  });

  @override
  State<MedicalHistoryCmp> createState() => _MedicalHistoryCmpState();
}

class _MedicalHistoryCmpState extends State<MedicalHistoryCmp> {
  static const ExpertFeatureService _service = ExpertFeatureService();

  late Future<List<ChildScreeningHistoryItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final roomUuid = widget.roomUuid?.trim() ?? '';
    if (roomUuid.isEmpty) {
      _historyFuture = Future.value(const []);
      return;
    }

    _historyFuture = _service.getChildScreeningHistory(roomUuid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChildScreeningHistoryItem>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 180,
            child: Center(
              child: TextButton(
                onPressed: () => setState(_loadHistory),
                child: const Text('Gagal memuat riwayat medis. Coba lagi'),
              ),
            ),
          );
        }

        final histories = snapshot.data ?? [];
        if (histories.isEmpty) {
          return const SizedBox(
            height: 160,
            child: Center(child: Text('Belum ada riwayat medis anak')),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: histories.map((history) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicalHistoryDetailsPage(
                            childUuid: widget.childUuid,
                            roomUuid: widget.roomUuid,
                            parentName: widget.parentName,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.base3,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              history.zScore.toStringAsFixed(1),
                              style: AppTextStyles.list1Bold(AppColors.base1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      history.nutritionStatus,
                                      style: AppTextStyles.headList1Bold(
                                        AppColors.base1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    history.date,
                                    style: AppTextStyles.list1Regular(
                                      AppColors.base2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      'Berat ${history.weight}, tinggi ${history.height}, Z-score ${history.zScore.toStringAsFixed(2)}',
                                      style: AppTextStyles.list1Regular(
                                        AppColors.base2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/medical_record.svg',
                                    height: 24,
                                    width: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.base3, thickness: 1),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
