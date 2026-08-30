import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/button/globals_button_transparent.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../globals/constants/api_endpoints.dart';
import 'chip_selector_form_field.dart';
import 'package:http/http.dart' as http;

class MakananPage extends StatefulWidget {
  final Map<String, String> data;
  final void Function(String key, String value) onUpdate;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final double progressValue;

  const MakananPage({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.onNext,
    required this.onBack,
    required this.progressValue,
  });

  @override
  State<MakananPage> createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  List<String> selectedFavorit = [];
  List<String> selectedDihindari = [];

  List<String> favoriteFoodOptions = [];
  List<String> avoidedFoodOptions = [];
  bool isLoadingFavorit = false;
  bool isLoadingDihindari = false;

  @override
  void initState() {
    super.initState();
    selectedFavorit = _splitData("makananFavorit");
    selectedDihindari = _splitData("makananDihindari");
    fetchFavoriteFoods();
    fetchAvoidedFoods();
  }

  List<String> _splitData(String key) {
    return widget.data[key]
            ?.split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList() ??
        [];
  }

  void _syncData() {
    widget.onUpdate("makananFavorit", selectedFavorit.join(', '));
    widget.onUpdate("makananDihindari", selectedDihindari.join(', '));
  }

  void handleNext() {
    _syncData();
    widget.onNext();
  }

  void handleBack() {
    _syncData();
    widget.onBack();
  }

  Future<void> fetchFavoriteFoods() async {
    setState(() => isLoadingFavorit = true);
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return;

      final url = Uri.parse(ApiEndpoints.favoriteFoods);
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        if (data is List) {
          setState(() {
            favoriteFoodOptions = data
                .where((item) => item['is_active'] == 1)
                .map<String>((item) => item['name'].toString())
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetch favorite foods: $e");
    } finally {
      setState(() => isLoadingFavorit = false);
    }
  }

  Future<void> fetchAvoidedFoods() async {
    setState(() => isLoadingDihindari = true);
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return;

      final url = Uri.parse(ApiEndpoints.avoidedFoods);
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        if (data is List) {
          setState(() {
            avoidedFoodOptions = data
                .where((item) => item['is_active'] == 1)
                .map<String>((item) => item['name'].toString())
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetch avoided foods: $e");
    } finally {
      setState(() => isLoadingDihindari = false);
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
            "Yuk bantu kami buatkan menu yang bikin si kecil semangat makan tiap hari",
            style: AppTextStyles.heading3SemiBold(const Color(0xFFBCBCBC)),
          ),
          const SizedBox(height: 20),
          isLoadingFavorit
              ? const Center(child: CircularProgressIndicator())
              : ChipSelectorFormField(
                  hint: 'Makanan Favorit',
                  label: "Makanan Favorit",
                  options: favoriteFoodOptions,
                  selectedItems: selectedFavorit,
                  onChanged: (newItems) {
                    setState(() {
                      selectedFavorit = newItems;
                      _syncData();
                    });
                  },
                ),
          const SizedBox(height: 16),
          isLoadingDihindari
              ? const Center(child: CircularProgressIndicator())
              : ChipSelectorFormField(
                  hint: "Makanan yang Dihindari",
                  label: "Makanan yang Dihindari",
                  options: avoidedFoodOptions,
                  selectedItems: selectedDihindari,
                  onChanged: (newItems) {
                    setState(() {
                      selectedDihindari = newItems;
                      _syncData();
                    });
                  },
                ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GlobalsButtonTransparent(
                  text: "Sebelumnya",
                  onPressed: handleBack,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlobalsButton(
                  text: "Selanjutnya",
                  onPressed: handleNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
