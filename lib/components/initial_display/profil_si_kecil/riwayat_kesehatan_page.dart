import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/initial_display/profil_si_kecil/chip_selector_form_field.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../globals/button/globals_button.dart';
import '../../globals/button/globals_button_transparent.dart';
import '../../globals/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;

class RiwayatKesehatanPage extends StatefulWidget {
  final Map<String, String> data;
  final void Function(String key, String value) onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final double progressValue;

  const RiwayatKesehatanPage({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.progressValue,
  });

  @override
  State<RiwayatKesehatanPage> createState() => _RiwayatKesehatanPageState();
}

class _RiwayatKesehatanPageState extends State<RiwayatKesehatanPage> {
  bool hasDiseaseHistory = false;
  bool hasAllergy = false;

  List<String> selectedDisease = [];
  List<String> selectedAllergies2 = [];

  List<String> diseaseOptions = [];
  bool isLoadingDisease = false;

  void handleNext() {
    widget.onUpdate("riwayatPenyakitAnak", selectedDisease.join(', '));
    widget.onUpdate("alergiAnak", selectedAllergies2.join(', '));
    widget.onNext();
  }

  @override
  void initState() {
    super.initState();
    fetchMedicalHistory();
    fetchAllergies();
  }

  Future<void> fetchMedicalHistory() async {
    setState(() => isLoadingDisease = true);
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        debugPrint("Token tidak ditemukan");
        return;
      }

      final url = Uri.parse(ApiEndpoints.medicalHistory);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        if (data is List) {
          setState(() {
            diseaseOptions = data
                .where((item) => item['is_active'] == 1)
                .map<String>((item) => item['name'].toString())
                .toList();
          });
        } else {
          debugPrint("Unexpected data format: $data");
        }
      } else {
        debugPrint("Failed to fetch medical histories: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching medical histories: $e");
    } finally {
      setState(() => isLoadingDisease = false);
    }
  }

  List<String> allergyOptions = [];
  bool isLoadingAllergy = false;

  Future<void> fetchAllergies() async {
    setState(() => isLoadingAllergy = true);
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        debugPrint("Token tidak ditemukan");
        return;
      }

      final url = Uri.parse(ApiEndpoints.allergies);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        if (data is List) {
          setState(() {
            allergyOptions = data
                .where((item) => item['is_active'] == 1)
                .map<String>((item) => item['name'].toString())
                .toList();
          });
        }
      } else {
        debugPrint("Failed to fetch allergies: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching allergies: $e");
    } finally {
      setState(() => isLoadingAllergy = false);
    }
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
            "Apakah si kecil punya alergi atau riwayat kesehatan tertentu?",
            style: AppTextStyles.heading3SemiBold(const Color(0xFFBCBCBC)),
          ),

          const SizedBox(height: 20),
          GlobalsCard(
            height: 48,
            hasShadow: false,
            radius: 18,
            margin: EdgeInsets.symmetric(horizontal: 2),
            onTap: () {
              setState(() {
                hasDiseaseHistory = !hasDiseaseHistory;
              });
            },
            backgroundColor:
                hasDiseaseHistory ? AppColors.primary3 : AppColors.base5,
            border: Border.all(
              color: hasDiseaseHistory ? AppColors.primary2 : AppColors.base3,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasDiseaseHistory
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: hasDiseaseHistory
                        ? AppColors.primary1
                        : AppColors.base3,
                  ),
                  onPressed: () {
                    setState(() {
                      hasDiseaseHistory = !hasDiseaseHistory;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  "Anak memiliki riwayat penyakit",
                  style: AppTextStyles.list1Regular(),
                ),
              ],
            ),
          ),
          if (hasDiseaseHistory)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: isLoadingDisease
                  ? const Center(child: CircularProgressIndicator())
                  : ChipSelectorFormField(
                      label: "Riwayat Penyakit Anak",
                      options: diseaseOptions,
                      selectedItems: selectedDisease,
                      onChanged: (newItems) {
                        setState(() {
                          selectedDisease = newItems;
                        });
                      },
                    ),
            ),

          // Card Riwayat Alergi
          const SizedBox(height: 15),
          GlobalsCard(
            height: 48,
            hasShadow: false,
            radius: 18,
            margin: EdgeInsets.symmetric(horizontal: 2),
            onTap: () {
              setState(() {
                hasAllergy = !hasAllergy;
              });
            },
            backgroundColor: hasAllergy ? AppColors.primary3 : AppColors.base5,
            border: Border.all(
              color: hasAllergy ? AppColors.primary2 : AppColors.base3,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasAllergy
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: hasAllergy ? AppColors.primary1 : AppColors.base3,
                  ),
                  onPressed: () {
                    setState(() {
                      hasAllergy = !hasAllergy;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  "Anak memiliki riwayat alergi",
                  style: AppTextStyles.list1Regular(),
                ),
              ],
            ),
          ),

          if (hasAllergy)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: isLoadingAllergy
                  ? const Center(child: CircularProgressIndicator())
                  : ChipSelectorFormField(
                      label: "Alergi Anak",
                      options: allergyOptions,
                      selectedItems: selectedAllergies2,
                      onChanged: (newItems) {
                        setState(() {
                          selectedAllergies2 = newItems;
                        });
                      },
                    ),
            ),

          const Spacer(),
          Row(
            children: [
              Expanded(
                  child: GlobalsButtonTransparent(
                      text: "Sebelumnya", onPressed: widget.onBack)),
              const SizedBox(width: 10),
              Expanded(
                child:
                    GlobalsButton(text: "Selanjutnya", onPressed: handleNext),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              )
            ],
          ),
        ],
      ),
    );
  }
}
