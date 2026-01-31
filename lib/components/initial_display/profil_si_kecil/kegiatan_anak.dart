import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/button/globals_button_transparent.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../../models/components/child/child_activity_model.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../globals/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;

class KegiatanAnak extends StatefulWidget {
  final Map<String, String> data;
  final void Function(String key, String value) onUpdate;
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final double progressValue;

  const KegiatanAnak({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.onFinish,
    required this.onBack,
    required this.progressValue,
  });

  @override
  State<KegiatanAnak> createState() => _KegiatanAnakState();
}

class _KegiatanAnakState extends State<KegiatanAnak> {
  ChildActivity? selectedActivity;
  List<ChildActivity> activities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    setState(() => isLoading = true);
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.childActivity),
        headers: {
          'Authorization': token,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['data'];

        setState(() {
          activities = list
              .map((e) => ChildActivity.fromJson(e))
              .where((e) => e.isActive) // ✅ AMAN
              .toList();
        });
      } else {
        debugPrint("❌ Activity API error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Fetch activity error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void handleFinish() {
    if (selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kegiatan anak terlebih dahulu")),
      );
      return;
    }

    widget.onUpdate(
      "kegiatanAnak",
      selectedActivity!.id.toString(),
    );

    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: widget.progressValue,
            color: Colors.orange,
            minHeight: 12,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          const SizedBox(height: 20),
          Text(
            "Yuk bantu kami buatkan menu yang bikin si kecil semangat makan tiap hari",
            style: AppTextStyles.heading3SemiBold(const Color(0xFFBCBCBC)),
          ),
          const SizedBox(height: 20),
          GlobalsCard(
            padding: const EdgeInsets.all(8),
            backgroundColor: AppColors.base4,
            hasShadow: false,
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: activities.map((activity) {
                      final isSelected = selectedActivity?.id == activity.id;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedActivity = activity;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? AppColors.primary1
                                        : AppColors.base3,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      activity.name,
                                      style: AppTextStyles.list1Regular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: AppColors.base4,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GlobalsButtonTransparent(
                  text: "Sebelumnya",
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlobalsButton(
                  text: "Selesai",
                  onPressed: handleFinish,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
