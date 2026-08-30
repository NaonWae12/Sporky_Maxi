import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/dialog/globals_bottom_sheet.dart';
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';

import '../../core/utils/secure_storage_service.dart';
import '../../views/summary_of_daily/page_summary.dart';
import '../globals/button/food_portion_guide_button.dart';
import '../globals/dialog/dialog_alert.dart';
import '../globals/dialog/dialog_content_cmp/content2.dart';
import 'first_form_cmp.dart';
import '../globals/card/cmp_tag_attention.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/constants/api_endpoints.dart';
import '../globals/progres/progres_slider.dart';
import '../globals/text/text_style.dart';
import '../meal_form_cmp/cmp_add_meal_form.dart';

class AddFormWasteCmp extends StatefulWidget {
  const AddFormWasteCmp({
    super.key,
    this.selectedMealOption,
    this.onMealOptionChanged,
  });

  final FoodWasteMealOption? selectedMealOption;
  final ValueChanged<FoodWasteMealOption>? onMealOptionChanged;

  @override
  State<AddFormWasteCmp> createState() => _AddFormWasteCmpState();
}

class _AddFormWasteCmpState extends State<AddFormWasteCmp> {
  bool _isLoadingFoodIntakes = false;
  bool _isSubmitting = false;
  bool _isExpanded1 = false;
  XFile? _photoEvidence;

  static const List<FoodWasteMealOption> _mealOptions = [
    FoodWasteMealOption(
      text: 'Makan Pagi',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.primary1,
    ),
    FoodWasteMealOption(
      text: 'Snack Pagi',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.info1,
    ),
    FoodWasteMealOption(
      text: 'Makan Siang',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.warn1,
    ),
    FoodWasteMealOption(
      text: 'Snack Sore',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.info1,
    ),
    FoodWasteMealOption(
      text: 'Makan Malam',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.secondary1,
    ),
  ];
  final List<String> _foodIntakeNamesCache = [];
  final List<_FoodIntakeOption> _foodIntakeOptions = [];
  final Map<MealFormItem, _FoodIntakeOption> _foodIntakeOptionByForm = {};
  final List<MealFormItem> _foodForms = [];
  final List<double> _leftoverByForm = [];
  ScaffoldMessengerState? _scaffoldMessenger;
  String? _lastSliderAlertMessage;
  DateTime? _lastSliderAlertAt;
  double _carbohydrateTotal = 0;
  double _proteinTotal = 0;
  double _fatTotal = 0;
  double _caloriesTotal = 0;

  @override
  void initState() {
    super.initState();
    _loadFoodIntakeNames();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  }

  void _clearForms() {
    for (final form in _foodForms) {
      form.mealNameController.dispose();
      form.portionsController.dispose();
    }
    _foodForms.clear();
    _leftoverByForm.clear();
    _foodIntakeOptionByForm.clear();
  }

  void _attachListeners(MealFormItem item) {
    item.mealNameController.addListener(_recalculateNutrition);
    item.portionsController.addListener(_recalculateNutrition);
  }

  @override
  void didUpdateWidget(covariant AddFormWasteCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMealOption?.text != oldWidget.selectedMealOption?.text) {
      _clearCurrentAlert();
      _resetSliderAlertThrottle();
      _loadFoodIntakeNames();
    }
  }

  @override
  void dispose() {
    _clearCurrentAlert();
    for (final form in _foodForms) {
      form.mealNameController.dispose();
      form.portionsController.dispose();
    }
    super.dispose();
  }

  String? _selectedMealTime() {
    switch (widget.selectedMealOption?.text) {
      case 'Makan Pagi':
        return '08:00:00';
      case 'Snack Pagi':
        return '10:00:00';
      case 'Makan Siang':
        return '12:00:00';
      case 'Snack Sore':
        return '15:00:00';
      case 'Makan Malam':
        return '18:00:00';
      default:
        return null;
    }
  }

  String _todayDateString() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  Future<void> _pickPhotoEvidence(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null || !mounted) return;

      setState(() {
        _photoEvidence = pickedFile;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka kamera atau galeri.')),
      );
    }
  }

  Future<void> _showPhotoSourcePicker() async {
    final source = await showAppBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: false,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.primary1),
            title: Text(
              'Ambil dari Kamera',
              style: AppTextStyles.headList1Regular(),
            ),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.primary1),
            title: Text(
              'Pilih dari Galeri',
              style: AppTextStyles.headList1Regular(),
            ),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return;
    if (!mounted) return;

    await _pickPhotoEvidence(source);
  }

  Future<void> _loadFoodIntakeNames() async {
    debugPrint('[AddFormWasteCmp] load food-intake names started');
    debugPrint(
      '[AddFormWasteCmp] selected meal option: ${widget.selectedMealOption?.text}',
    );
    setState(() {
      _isLoadingFoodIntakes = true;
      _foodIntakeNamesCache.clear();
      _foodIntakeOptions.clear();
      _clearForms();
      _carbohydrateTotal = 0;
      _proteinTotal = 0;
      _fatTotal = 0;
      _caloriesTotal = 0;
    });

    try {
      final today = _todayDateString();
      final childUuid = await SecureStorageService.getSelectedChildUuid();
      debugPrint('[AddFormWasteCmp] selected child_uuid: $childUuid');
      if (childUuid == null || childUuid.isEmpty) {
        debugPrint('[AddFormWasteCmp] child_uuid is empty');
        return;
      }

      final token = await SecureStorageService.getToken();
      debugPrint(
        '[AddFormWasteCmp] token exists: ${token != null && token.isNotEmpty}',
      );
      if (token == null || token.isEmpty) {
        debugPrint('[AddFormWasteCmp] token is empty');
        return;
      }
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final uri = Uri.parse(ApiEndpoints.foodIntakes).replace(
        queryParameters: {
          'child_uuid': childUuid,
          'date_from': today,
          'date_to': today,
          'per_page': '100',
        },
      );
      debugPrint('[AddFormWasteCmp] GET $uri');

      final response = await http.get(
        uri,
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );
      debugPrint('[AddFormWasteCmp] response status: ${response.statusCode}');
      debugPrint('[AddFormWasteCmp] response body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('[AddFormWasteCmp] request failed');
        return;
      }

      final decoded = jsonDecode(response.body);
      final foodIntakes = _extractFoodIntakeList(decoded);
      debugPrint('[AddFormWasteCmp] parsed items count: ${foodIntakes.length}');

      final recordedIntakeUuids = await _loadRecordedWasteIntakeUuids(
        authHeader,
        childUuid,
        today,
      );
      debugPrint(
        '[AddFormWasteCmp] recorded waste intake UUIDs count: ${recordedIntakeUuids.length}',
      );

      final expectedMealTime = _selectedMealTime();
      debugPrint('[AddFormWasteCmp] expected meal_time: $expectedMealTime');

      // === DEBUG: print raw meal_time tiap item sebelum filter ===
      for (int i = 0; i < foodIntakes.length; i++) {
        final rawMealTime = foodIntakes[i]['meal_time'];
        final rawDate = foodIntakes[i]['date'];
        final rawName = _resolveDisplayName(foodIntakes[i]);
        final isMatch = rawMealTime == expectedMealTime;
        debugPrint(
          '[AddFormWasteCmp] item[$i] name="$rawName" date="$rawDate" meal_time="$rawMealTime" (expected="$expectedMealTime" match=$isMatch)',
        );
      }
      // ==========================================================

      final pendingIntakes = foodIntakes
          .where((e) => _isSameDate(e['date'], today))
          .where((e) => !_hasFoodWaste(e, recordedIntakeUuids))
          .toList();

      final filtered = expectedMealTime == null
          ? pendingIntakes
          : pendingIntakes
                .where((e) => e['meal_time'] == expectedMealTime)
                .toList();
      debugPrint('[AddFormWasteCmp] filtered count: ${filtered.length}');

      final seen = <String>{};
      final names = <String>[];
      final options = <_FoodIntakeOption>[];
      for (final item in filtered) {
        debugPrint('[AddFormWasteCmp] raw item: $item');
        final name = _resolveDisplayName(item);
        if (name.isEmpty) continue;
        final option = _foodIntakeOptionFromJson(item, name);
        if (option.intakeUuid.isEmpty) continue;

        options.add(option);

        final normalized = name.toLowerCase();
        if (seen.add(normalized)) {
          names.add(name);
        }
      }
      debugPrint('[AddFormWasteCmp] autocomplete names count: ${names.length}');
      debugPrint('[AddFormWasteCmp] autocomplete names: $names');

      if (!mounted) return;
      setState(() {
        _foodIntakeNamesCache
          ..clear()
          ..addAll(names);
        _foodIntakeOptions
          ..clear()
          ..addAll(options);

        _clearForms();
        for (final option in options) {
          final form = MealFormItem();
          form.mealNameController.text = option.name;
          form.portionsController.text = '1';
          _foodForms.add(form);
          _leftoverByForm.add(0.0);
          _foodIntakeOptionByForm[form] = option;
          _attachListeners(form);
        }
      });
      debugPrint(
        '[AddFormWasteCmp] cache updated count: ${_foodIntakeNamesCache.length}',
      );
      _recalculateNutrition();
    } catch (_) {
      debugPrint('[AddFormWasteCmp] exception while loading names');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFoodIntakes = false;
        });
      }
      debugPrint('[AddFormWasteCmp] loading finished');
    }
  }

  Future<Set<String>> _loadRecordedWasteIntakeUuids(
    String authHeader,
    String childUuid,
    String date,
  ) async {
    try {
      final uri = Uri.parse(ApiEndpoints.foodWaste).replace(
        queryParameters: {
          'child_uuid': childUuid,
          'date_from': date,
          'date_to': date,
          'per_page': '100',
        },
      );
      debugPrint('[AddFormWasteCmp] GET $uri');

      final response = await http.get(
        uri,
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );
      debugPrint(
        '[AddFormWasteCmp] food-waste response status: ${response.statusCode}',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return <String>{};
      }

      final decoded = jsonDecode(response.body);
      final wasteItems = _extractFoodWasteList(decoded);
      return wasteItems
          .map((item) => item['food_intake'])
          .whereType<Map<String, dynamic>>()
          .map((foodIntake) => foodIntake['uuid']?.toString() ?? '')
          .where((uuid) => uuid.isNotEmpty)
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  List<Map<String, dynamic>> _extractFoodIntakeList(dynamic decoded) {
    if (decoded is! Map<String, dynamic>) {
      return const <Map<String, dynamic>>[];
    }

    final dataNode = decoded['data'];
    if (dataNode is List) {
      return dataNode.whereType<Map<String, dynamic>>().toList();
    }

    if (dataNode is Map<String, dynamic>) {
      final items = dataNode['food_intakes'];
      if (items is List) {
        return items.whereType<Map<String, dynamic>>().toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _extractFoodWasteList(dynamic decoded) {
    if (decoded is! Map<String, dynamic>) {
      return const <Map<String, dynamic>>[];
    }

    final dataNode = decoded['data'];
    if (dataNode is List) {
      return dataNode.whereType<Map<String, dynamic>>().toList();
    }

    if (dataNode is Map<String, dynamic>) {
      final items = dataNode['food_waste'];
      if (items is List) {
        return items.whereType<Map<String, dynamic>>().toList();
      }
    }

    return const <Map<String, dynamic>>[];
  }

  bool _isSameDate(dynamic value, String date) {
    final rawDate = value?.toString() ?? '';
    return rawDate.length >= 10 && rawDate.substring(0, 10) == date;
  }

  bool _hasFoodWaste(Map<String, dynamic> item, Set<String> recordedUuids) {
    final uuid = item['uuid']?.toString() ?? '';
    if (uuid.isNotEmpty && recordedUuids.contains(uuid)) return true;
    if (item['has_food_waste'] == true) return true;

    final foodWaste = item['food_waste'];
    return foodWaste is Map<String, dynamic> && foodWaste.isNotEmpty;
  }

  _FoodIntakeOption _foodIntakeOptionFromJson(
    Map<String, dynamic> item,
    String name,
  ) {
    return _FoodIntakeOption(
      intakeUuid: item['uuid']?.toString() ?? '',
      name: name,
      carbohydrate: _asDouble(item['carbohydrate']),
      protein: _asDouble(item['protein']),
      fat: _asDouble(item['fat']),
      calories: _asDouble(item['calories']),
    );
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  double _parsePortion(String value) {
    final normalized = value.replaceAll(',', '.').trim();
    if (normalized.isEmpty) return 1;
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) return 1;
    return parsed;
  }

  void _recalculateNutrition() {
    if (_lastSliderAlertMessage != null) {
      _clearCurrentAlert();
      _resetSliderAlertThrottle();
    }

    double carb = 0;
    double protein = 0;
    double fat = 0;
    double calories = 0;

    for (final form in _foodForms) {
      final selectedName = form.mealNameController.text.trim();
      if (selectedName.isEmpty) continue;

      final option = _findOptionForForm(form);
      if (option == null) continue;

      final portion = _parsePortion(form.portionsController.text);
      carb += option.carbohydrate * portion;
      protein += option.protein * portion;
      fat += option.fat * portion;
      calories += option.calories * portion;
    }

    if (!mounted) return;
    setState(() {
      _carbohydrateTotal = carb;
      _proteinTotal = protein;
      _fatTotal = fat;
      _caloriesTotal = calories;
    });
  }

  String _formatValue(double value) {
    if (value == 0) return '0';
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.001) {
      return rounded.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _normalize(String value) => value.trim().toLowerCase();

  _FoodIntakeOption? _findOptionByName(String mealName) {
    final normalized = _normalize(mealName);
    if (normalized.isEmpty) return null;
    for (final option in _foodIntakeOptions) {
      if (_normalize(option.name) == normalized) {
        return option;
      }
    }
    return null;
  }

  _FoodIntakeOption? _findOptionForForm(MealFormItem form) {
    final mealName = form.mealNameController.text.trim();
    final mapped = _foodIntakeOptionByForm[form];
    if (mapped != null && _normalize(mapped.name) == _normalize(mealName)) {
      return mapped;
    }

    return _findOptionByName(mealName);
  }

  void _clearCurrentAlert() {
    _scaffoldMessenger?.clearSnackBars();
  }

  void _resetSliderAlertThrottle() {
    _lastSliderAlertMessage = null;
    _lastSliderAlertAt = null;
  }

  void _showAlert(String message, {bool throttle = false}) {
    if (!mounted) return;

    if (throttle) {
      final now = DateTime.now();
      final isSameMessage = _lastSliderAlertMessage == message;
      final isTooSoon =
          _lastSliderAlertAt != null &&
          now.difference(_lastSliderAlertAt!) < const Duration(seconds: 2);

      if (isSameMessage && isTooSoon) return;

      _lastSliderAlertMessage = message;
      _lastSliderAlertAt = now;
    }

    final messenger = _scaffoldMessenger ?? ScaffoldMessenger.maybeOf(context);
    messenger
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(duration: const Duration(seconds: 2), content: Text(message)),
      );
  }

  bool _isMealSelected(int index) {
    if (index < 0 || index >= _foodForms.length) return false;
    return _foodForms[index].mealNameController.text.trim().isNotEmpty;
  }

  void _onLeftoverChanged(int index, double value) {
    if (index < 0 || index >= _leftoverByForm.length) return;

    if (!_isMealSelected(index)) {
      _showAlert(
        'Isi nama makanan form ke-${index + 1} dulu sebelum geser slider.',
        throttle: true,
      );
      return;
    }

    _clearCurrentAlert();
    _resetSliderAlertThrottle();

    setState(() {
      _leftoverByForm[index] = value.clamp(0.0, 1.0);
    });
  }

  Future<void> _submitFoodWaste() async {
    if (_isSubmitting) return;

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      _showAlert('Token tidak ditemukan. Silakan login ulang.');
      return;
    }
    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

    final selectedIndexes = <int>[];
    for (var i = 0; i < _foodForms.length; i++) {
      if (_isMealSelected(i)) {
        selectedIndexes.add(i);
      }
    }

    if (selectedIndexes.isEmpty) {
      _showAlert('Tidak ada data makanan yang perlu diisi sisa makanannya.');
      return;
    }

    for (final i in selectedIndexes) {
      final selectedName = _foodForms[i].mealNameController.text.trim();
      final option = _findOptionForForm(_foodForms[i]);
      if (option == null || option.intakeUuid.isEmpty) {
        _showAlert(
          'Makanan "$selectedName" tidak valid. Pilih dari daftar autocomplete.',
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (final i in selectedIndexes) {
        final selectedName = _foodForms[i].mealNameController.text.trim();
        final option = _findOptionForForm(_foodForms[i]);
        if (option == null || option.intakeUuid.isEmpty) {
          _showAlert(
            'Makanan "$selectedName" tidak valid. Pilih dari daftar autocomplete.',
          );
          return;
        }
        final leftoverValue = _leftoverByForm[i].clamp(0.0, 1.0);

        final request = http.MultipartRequest(
          'POST',
          Uri.parse(ApiEndpoints.foodWaste),
        );
        request.headers.addAll({
          'Authorization': authHeader,
          'Accept': 'application/json',
        });
        request.fields['intake_uuid'] = option.intakeUuid;
        request.fields['leftover_food'] = leftoverValue.toStringAsFixed(4);

        if (_photoEvidence != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo_evidence',
              _photoEvidence!.path,
            ),
          );
        }

        final streamed = await request.send();
        final body = await streamed.stream.bytesToString();
        debugPrint(
          '[AddFormWasteCmp] submit index=$i status=${streamed.statusCode}',
        );
        debugPrint('[AddFormWasteCmp] submit body=$body');

        if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
          String message =
              'Gagal menyimpan data sisa makanan. (${streamed.statusCode})';
          try {
            final decoded = jsonDecode(body);
            if (decoded is Map<String, dynamic>) {
              final apiMessage = decoded['message']?.toString().trim() ?? '';
              if (apiMessage.isNotEmpty) {
                message = apiMessage;
              }
            }
          } catch (_) {}
          _showAlert(message);
          return;
        }
      }

      DialogAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        customChild: Content2(
          title: 'Yeay, Sudah Tersimpan!',
          message:
              'Terima kasih sudah mencatat! Data ini bantu Bunda dan tim Sporky memahami kebiasaan makan si kecil dan menyesuaikan menu harian ke depannya 💚',
          textNavLeft: 'Lihat Ringkasan',
          texLeftWidth: 6.5,
          texRightWidth: 6.5,
          iconAssetRight: 'assets/svg/home-rounded.svg',
          buttonCollorLeft: AppColors.success2,
          textNavRight: 'Home',
          iconAssetLeft: 'assets/svg/ic_pie_chart.svg',
          buttonCollorRight: AppColors.primary1,
          onPressedLeft: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PageSummary()),
            );
          },
          onPressedRight: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Navbar()),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('[AddFormWasteCmp] submit exception: $e');
      _showAlert('Terjadi kesalahan jaringan saat menyimpan.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _resolveDisplayName(Map<String, dynamic> item) {
    final name = item['name']?.toString().trim() ?? '';
    if (name.isNotEmpty) return name;

    final mealPlan = item['meal_plan'];
    if (mealPlan is Map<String, dynamic>) {
      final mealPlanName = mealPlan['name']?.toString().trim() ?? '';
      if (mealPlanName.isNotEmpty) return mealPlanName;
    }

    return '';
  }

  void _toggleMealDropdown() {
    if (widget.onMealOptionChanged == null) return;

    setState(() {
      _isExpanded1 = !_isExpanded1;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[AddFormWasteCmp] build - loading=$_isLoadingFoodIntakes cache=${_foodIntakeNamesCache.length}',
    );
    return Column(
      children: [
        const FoodPortionGuideButton(slug: 'food-waste-guide'),
        GlobalsCard(
          onTap: widget.onMealOptionChanged == null
              ? null
              : _toggleMealDropdown,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: _isExpanded1 ? Radius.zero : const Radius.circular(12),
            bottomRight: _isExpanded1 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    widget.selectedMealOption?.iconAsset ??
                        'assets/svg/bento-box-rounded.svg',
                    colorFilter: ColorFilter.mode(
                      widget.selectedMealOption?.iconColor ??
                          AppColors.primary1,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.selectedMealOption?.text ?? 'Makan Pagi',
                    style: AppTextStyles.headList1Regular(),
                  ),
                ],
              ),
              Icon(
                _isExpanded1
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: widget.onMealOptionChanged == null
                    ? AppColors.base3
                    : null,
              ),
            ],
          ),
        ),
        if (_isExpanded1 && widget.onMealOptionChanged != null) ...[
          const SizedBox(height: 8),
          for (var i = 0; i < _mealOptions.length; i++) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded1 = false;
                });
                widget.onMealOptionChanged!.call(_mealOptions[i]);
              },
              child: CmpTagAttention(
                space: 8,
                textStyle: AppTextStyles.headList1Regular(),
                imageAsset: _mealOptions[i].iconAsset,
                text: _mealOptions[i].text,
                lineColor: AppColors.base4,
                imageColor: _mealOptions[i].iconColor,
              ),
            ),
            if (i != _mealOptions.length - 1) const SizedBox(height: 8),
          ],
        ],
        const SizedBox(height: 16),
        if (_isLoadingFoodIntakes)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (!_isLoadingFoodIntakes && _foodForms.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              'Tidak ada data makanan yang perlu diisi sisa makanannya.',
              textAlign: TextAlign.center,
              style: AppTextStyles.list1Regular(AppColors.base2),
            ),
          ),
        for (int i = 0; i < _foodForms.length; i++) ...[
          CmpAddMealForm(
            key: ValueKey('form_${_foodForms[i].hashCode}'),
            normalFill: false,
            forms: [_foodForms[i]],
            onChanged: _recalculateNutrition,
            enableAutoComplete: _foodIntakeNamesCache.isNotEmpty,
            autoCompleteOptions: _foodIntakeNamesCache,
            onAutoCompleteSelected: (_) => _recalculateNutrition(),
          ),
          ProgressSlider(
            key: ValueKey('slider_${_foodForms[i].hashCode}'),
            label:
                'Geser sesuai dengan jumlah makanan yang dihabiskan anak, ya.',
            percentage: _leftoverByForm[i],
            onChanged: (value) => _onLeftoverChanged(i, value),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildNutritionCard(
              'assets/svg/ic_nutrition.svg',
              'Karbohidrat',
              _formatValue(_carbohydrateTotal),
              'gr',
            ),
            _buildNutritionCard(
              'assets/svg/ic_fat.svg',
              'Lemak',
              _formatValue(_fatTotal),
              'gr',
            ),
            _buildNutritionCard(
              'assets/svg/ic_proteins.svg',
              'Protein',
              _formatValue(_proteinTotal),
              'gr',
            ),
            _buildNutritionCard(
              'assets/svg/ic_fire.svg',
              'Total Kalori',
              _formatValue(_caloriesTotal),
              'kcal',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            GlobalsCard(
              onTap: _showPhotoSourcePicker,
              margin: const EdgeInsets.only(left: 16),
              hasShadow: false,
              backgroundColor: AppColors.primary1,
              height: 44,
              width: 56,
              child: Icon(
                _photoEvidence == null ? Icons.camera_alt : Icons.check,
                size: 20,
                color: AppColors.base5,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GlobalsButton(
                  elevation: 0,
                  height: 44,
                  width: MediaQuery.of(context).size.width / 1.5,
                  color: _isSubmitting ? AppColors.base2 : AppColors.secondary1,
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          DialogAlert.show(
                            context: context,
                            customChild: Content2(
                              title: 'Simpan Data Sisa Makanan?',
                              message:
                                  'Pastikan data sisa makanan sudah sesuai ya bun. Info ini akan bantu kamu memantau pola makan dan selera si kecil lebih akurat.',
                              textNavLeft: 'Cek Kembali',
                              buttonCollorLeft: AppColors.warn1,
                              textNavRight: 'Simpan',
                              buttonCollorRight: AppColors.success2,
                              onPressedLeft: () {
                                Navigator.pop(context);
                              },
                              onPressedRight: () async {
                                Navigator.pop(context);

                                // 👉 panggil function utama di sini
                                await _submitFoodWaste();
                              },
                            ),
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isSubmitting)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.base5,
                          ),
                        )
                      else
                        Text(
                          'Simpan Data Sisa Makanan',
                          style: AppTextStyles.headList1Bold(AppColors.base5),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FoodIntakeOption {
  final String intakeUuid;
  final String name;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double calories;

  const _FoodIntakeOption({
    required this.intakeUuid,
    required this.name,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.calories,
  });
}

Widget _buildNutritionCard(
  String iconPath,
  String title,
  String value,
  String unit,
) {
  return SizedBox(
    width: 170,
    child: GlobalsCard(
      width: 170,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 5),
      backgroundColor: AppColors.base5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath),
          Text(title, style: AppTextStyles.list1Regular()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.heading3SemiBold(AppColors.base2),
              ),
              GlobalsCard(
                radius: 4,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                hasShadow: false,
                backgroundColor: AppColors.base4,
                child: Row(
                  children: [
                    Text(unit, style: AppTextStyles.heading3SemiBold()),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
