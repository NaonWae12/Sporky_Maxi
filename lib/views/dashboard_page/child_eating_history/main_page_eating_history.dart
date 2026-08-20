import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/profile_cmp/short_banner_profile.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/child_eating_history_cmp/page_history_list.dart';
import 'package:sporky_maxi/components/dashboard_page_cmp/cmp_chart/child_nutrition_chart.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/core/services/child/screening_service.dart';
import 'package:sporky_maxi/models/components/child/child_latest_screening_model.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/age_helper.dart';

class MainPageEatingHistory extends StatefulWidget {
  const MainPageEatingHistory({super.key});

  @override
  State<MainPageEatingHistory> createState() => _MainPageEatingHistoryState();
}

class _MainPageEatingHistoryState extends State<MainPageEatingHistory> {
  // Screening hanya di-load sekali
  Future<ChildLatestScreening>? _screeningFuture;

  // State untuk tanggal yang dipilih dan data history
  DateTime _selectedDate = DateTime.now();
  bool _historyLoading = false;
  bool _historyApiError = false;
  double _carbohydrate = 0.0;
  double _protein = 0.0;
  double _fat = 0.0;
  List<dynamic> _intakesList = [];

  @override
  void initState() {
    super.initState();
    _screeningFuture = _fetchScreening();
    _fetchHistory(_selectedDate);
  }

  Future<ChildLatestScreening> _fetchScreening() async {
    final childUuid = await SecureStorageService.getSelectedChildUuid();
    if (childUuid == null || childUuid.isEmpty) {
      throw Exception('Child UUID is empty');
    }
    return ScreeningService().getLatestByChildUuid(childUuid);
  }

  String _formatDateParam(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _fetchHistory(DateTime date) async {
    setState(() {
      _historyLoading = true;
      _historyApiError = false;
      _carbohydrate = 0.0;
      _protein = 0.0;
      _fat = 0.0;
      _intakesList = [];
    });

    try {
      final childUuid = await SecureStorageService.getSelectedChildUuid();
      if (childUuid == null || childUuid.isEmpty) {
        debugPrint('[MainPageEatingHistory] child_uuid is empty');
        setState(() => _historyApiError = true);
        return;
      }

      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[MainPageEatingHistory] token is empty');
        setState(() => _historyApiError = true);
        return;
      }
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final dateStr = _formatDateParam(date);
      final uri = Uri.parse(ApiEndpoints.childFoodHistory(childUuid)).replace(
        queryParameters: {
          'date_from': dateStr,
          'date_to': dateStr,
        },
      );
      debugPrint('[MainPageEatingHistory] GET $uri');

      final response = await http.get(uri, headers: {
        'Authorization': authHeader,
        'Accept': 'application/json',
      });
      debugPrint('[MainPageEatingHistory] API response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('[MainPageEatingHistory] API error — status: ${response.statusCode}, body: ${response.body}');
        setState(() => _historyApiError = true);
        return;
      }

      final decoded = jsonDecode(response.body);
      final dataMap = decoded['data'];
      if (dataMap is! Map<String, dynamic>) {
        debugPrint('[MainPageEatingHistory] data field is not a map: $dataMap');
        setState(() => _historyApiError = true);
        return;
      }

      // Parse daily_totals untuk nilai nutrisi
      double carbohydrate = 0.0;
      double protein = 0.0;
      double fat = 0.0;

      final dailyTotals = dataMap['daily_totals'];
      debugPrint('[MainPageEatingHistory] daily_totals type: ${dailyTotals.runtimeType}, count: ${dailyTotals is List ? dailyTotals.length : "n/a"}');
      if (dailyTotals is List && dailyTotals.isNotEmpty) {
        final entry = dailyTotals.first;
        if (entry is Map<String, dynamic>) {
          carbohydrate = _asDouble(entry['carbohydrate']);
          protein = _asDouble(entry['protein']);
          fat = _asDouble(entry['fat']);
          debugPrint('[MainPageEatingHistory] Totals — carb: $carbohydrate, protein: $protein, fat: $fat');
        }
      } else {
        debugPrint('[MainPageEatingHistory] daily_totals is empty — no food recorded for $dateStr');
      }

      // Parse intakes
      final rawIntakes = dataMap['intakes'];
      final List<dynamic> intakesList =
          rawIntakes is List ? rawIntakes : [];
      debugPrint('[MainPageEatingHistory] intakes count: ${intakesList.length}');
      if (intakesList.isEmpty) {
        debugPrint('[MainPageEatingHistory] intakes list is empty — no food recorded yet');
      }

      if (!mounted) return;
      setState(() {
        _carbohydrate = carbohydrate;
        _protein = protein;
        _fat = fat;
        _intakesList = intakesList;
      });
    } catch (e) {
      debugPrint('[MainPageEatingHistory] Exception fetching history: $e');
      if (mounted) setState(() => _historyApiError = true);
    } finally {
      if (mounted) setState(() => _historyLoading = false);
    }
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void _onPrevDay() {
    final newDate = _selectedDate.subtract(const Duration(days: 1));
    setState(() => _selectedDate = newDate);
    _fetchHistory(newDate);
  }

  void _onNextDay() {
    final newDate = _selectedDate.add(const Duration(days: 1));
    setState(() => _selectedDate = newDate);
    _fetchHistory(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Riwayat Makan Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: FutureBuilder<ChildLatestScreening>(
        future: _screeningFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
                child: Text('Gagal memuat data profil anak'));
          }

          final screeningData = snapshot.data!;
          final child = screeningData.child;
          final screening = screeningData.screening;
          final age = calculateAge(child.dob);

          return Column(
            children: [
              ShortBannerProfile(
                childName: child.name,
                ageYear: age['year'] ?? 0,
                ageMonth: age['month'] ?? 0,
                status: screening?.nutritionStatus ?? '-',
              ),
              ChildNutritionChart(
                carbohydrate: _carbohydrate,
                protein: _protein,
                fat: _fat,
                hasData: !_historyApiError && _intakesList.isNotEmpty,
                isLoading: _historyLoading,
                selectedDate: _selectedDate,
                onPrevDay: _onPrevDay,
                onNextDay: _onNextDay,
              ),
              Expanded(
                child: _historyLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PageHistoryList(intakes: _intakesList),
              )
            ],
          );
        },
      ),
    );
  }
}
