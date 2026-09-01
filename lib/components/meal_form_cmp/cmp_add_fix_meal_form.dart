// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';
// import 'package:sporky_maxi/components/meal_form_cmp/cmp_fix_add_meal_form.dart';
import '../../views/form_food_waste/page_form_food_waste.dart';
import '../globals/constants/api_endpoints.dart';
import '../globals/button/globals_button.dart';
import '../globals/colors/colors.dart';
import '../globals/dialog/dialog_alert.dart';
import '../globals/dialog/dialog_content_cmp/content2.dart';
import '../globals/form/globals_form.dart';
import '../globals/text/text_style.dart';
import 'cmp_add_meal_form.dart';
import 'cmp_meal_form.dart';
import '../../core/utils/app_clock.dart';
import '../../core/utils/secure_storage_service.dart';

class CmpAddFixMealForm extends StatefulWidget {
  const CmpAddFixMealForm({
    super.key,
    this.selectedMeal,
    this.selectedCalorieMethod,
    this.mealPlanUuid,
    this.mealPlanName,
    this.mealPlanCarbohydrate,
    this.mealPlanProtein,
    this.mealPlanFat,
    this.mealPlanCalories,
  });

  final DropdownItem? selectedMeal;
  final DropdownItem? selectedCalorieMethod;
  final String? mealPlanUuid;
  final String? mealPlanName;
  final double? mealPlanCarbohydrate;
  final double? mealPlanProtein;
  final double? mealPlanFat;
  final double? mealPlanCalories;

  @override
  State<CmpAddFixMealForm> createState() => _CmpAddFixMealFormState();
}

class _CmpAddFixMealFormState extends State<CmpAddFixMealForm> {
  late DropdownItem? _selectedMeal;
  late DropdownItem? _selectedCalorieMethod;
  final List<MealFormItem> _forms = [MealFormItem()];
  final TextEditingController _carbController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  bool _isSubmitting = false;
  final List<String> _mealPlanNamesCache = [];
  final List<Map<String, dynamic>> _mealPlansCache = [];

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.selectedMeal;
    _selectedCalorieMethod =
        widget.selectedCalorieMethod ??
        (widget.mealPlanUuid != null
            ? DropdownItem(
                text: 'Meal Plan (Auto Filled)',
                iconAsset: 'assets/svg/bento-box-rounded.svg',
              )
            : null);
    _carbController.addListener(_onNutritionChanged);
    _proteinController.addListener(_onNutritionChanged);
    _fatController.addListener(_onNutritionChanged);
    _caloriesController.addListener(_onNutritionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryAutoFillFromMealPlan();
      if (_isAutoSelected) {
        _loadMealPlanNames();
      }
    });
  }

  @override
  void dispose() {
    _carbController.removeListener(_onNutritionChanged);
    _proteinController.removeListener(_onNutritionChanged);
    _fatController.removeListener(_onNutritionChanged);
    _caloriesController.removeListener(_onNutritionChanged);
    _carbController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _caloriesController.dispose();
    for (final item in _forms) {
      item.mealNameController.dispose();
      item.portionsController.dispose();
    }
    super.dispose();
  }

  bool get _isManualSelected => _selectedCalorieMethod?.text == 'Isi Manual';
  bool get _isAutoSelected =>
      _selectedCalorieMethod?.text == 'Meal Plan (Auto Filled)';

  bool get _isFormValid {
    if (!_isManualSelected && !_isAutoSelected) return false;
    if (_selectedMeal == null) return false;
    final name = _combinedMealName();
    if (name.isEmpty) return false;
    final carb = _parseDouble(_carbController.text);
    final protein = _parseDouble(_proteinController.text);
    final fat = _parseDouble(_fatController.text);
    final calories = _parseDouble(_caloriesController.text);
    return carb != null && protein != null && fat != null && calories != null;
  }

  String _mealTimeFromSelection(String? mealText) {
    switch (mealText) {
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
        return '08:00:00';
    }
  }

  String _todayDateString() {
    return AppClock.todayDateString();
  }

  String _combinedMealName() {
    final names = _forms
        .map((e) => e.mealNameController.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return names.join(' + ');
  }

  List<MealFormItem> _activeForms() {
    return _forms
        .where((item) => item.mealNameController.text.trim().isNotEmpty)
        .toList();
  }

  double? _parseDouble(String value) {
    final normalized = value.replaceAll(',', '.').trim();
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  double _parsePortion(String value) {
    final parsed = _parseDouble(value);
    if (parsed == null || parsed <= 0) return 1;
    return parsed;
  }

  double _portionTotal(List<MealFormItem> forms) {
    return forms.fold<double>(
      0,
      (total, item) => total + _parsePortion(item.portionsController.text),
    );
  }

  double _splitByPortion(
    double total,
    MealFormItem item,
    double portionTotal,
    int itemCount,
  ) {
    if (itemCount <= 1) return total;
    if (portionTotal <= 0) return total / itemCount;

    final portion = _parsePortion(item.portionsController.text);
    return total * (portion / portionTotal);
  }

  Map<String, dynamic> _nutritionFromMealPlan(Map<String, dynamic> mealPlan) {
    if (mealPlan['nutrition'] is Map<String, dynamic>) {
      return mealPlan['nutrition'] as Map<String, dynamic>;
    }

    if (mealPlan['nutritions'] is List &&
        (mealPlan['nutritions'] as List).isNotEmpty) {
      final firstNutrition = (mealPlan['nutritions'] as List).first;
      if (firstNutrition is Map<String, dynamic>) {
        return firstNutrition;
      }
    }

    return const <String, dynamic>{};
  }

  Map<String, dynamic>? _findMealPlanByName(String name) {
    final normalizedName = name.toLowerCase().trim();
    for (final mealPlan in _mealPlansCache) {
      if ((mealPlan['name']?.toString().toLowerCase().trim() ?? '') ==
          normalizedName) {
        return mealPlan;
      }
    }

    if (widget.mealPlanUuid != null &&
        widget.mealPlanName?.toLowerCase().trim() == normalizedName) {
      return {
        'uuid': widget.mealPlanUuid,
        'name': widget.mealPlanName,
        'nutrition': {
          'carbohydrate': widget.mealPlanCarbohydrate,
          'protein': widget.mealPlanProtein,
          'fat': widget.mealPlanFat,
          'calories': widget.mealPlanCalories,
        },
      };
    }

    return null;
  }

  Future<http.Response> _postFoodIntake(
    String endpoint,
    String token,
    Map<String, dynamic> body,
  ) {
    return http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  void _onFormChanged() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (_isAutoSelected) {
            _recalculateTotalNutritions();
          }
          setState(() {});
        }
      });
    }
  }

  void _onNutritionChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _tryAutoFillFromMealPlan() async {
    if (!_isAutoSelected) return;

    if (widget.mealPlanUuid != null) {
      final carb = widget.mealPlanCarbohydrate;
      final protein = widget.mealPlanProtein;
      final fat = widget.mealPlanFat;
      final calories = widget.mealPlanCalories;

      if (widget.mealPlanName != null && widget.mealPlanName!.isNotEmpty) {
        if (_forms.isNotEmpty) {
          _forms.first.mealNameController.text = widget.mealPlanName!;
        }
      }

      if (carb != null) _carbController.text = carb.toString();
      if (protein != null) _proteinController.text = protein.toString();
      if (fat != null) _fatController.text = fat.toString();
      if (calories != null) _caloriesController.text = calories.toString();

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
      _loadMealPlanNames();
    }
    if (widget.mealPlanUuid == null) {
      _loadMealPlanNames();
    }
  }

  void _recalculateTotalNutritions() {
    if (_mealPlansCache.isEmpty) return;
    double totalCarb = 0.0;
    double totalProtein = 0.0;
    double totalFat = 0.0;
    double totalCalories = 0.0;

    for (final item in _forms) {
      final name = item.mealNameController.text.toLowerCase().trim();
      if (name.isEmpty) continue;

      double portion = 1.0;
      final portionText = item.portionsController.text.trim();
      if (portionText.isNotEmpty) {
        portion = double.tryParse(portionText) ?? 1.0;
      }

      final matched = _mealPlansCache.firstWhere(
        (mp) => (mp['name']?.toString().toLowerCase().trim() ?? '') == name,
        orElse: () => <String, dynamic>{},
      );

      if (matched.isNotEmpty) {
        Map<String, dynamic> nutrition = {};
        if (matched['nutrition'] is Map<String, dynamic>) {
          nutrition = matched['nutrition'] as Map<String, dynamic>;
        } else if (matched['nutritions'] is List &&
            (matched['nutritions'] as List).isNotEmpty) {
          final firstNutrition = (matched['nutritions'] as List).first;
          if (firstNutrition is Map<String, dynamic>) {
            nutrition = firstNutrition;
          }
        }

        final cVal =
            _parseDouble(nutrition['carbohydrate']?.toString() ?? '0') ?? 0.0;
        final pVal =
            _parseDouble(nutrition['protein']?.toString() ?? '0') ?? 0.0;
        final fVal = _parseDouble(nutrition['fat']?.toString() ?? '0') ?? 0.0;
        final calVal =
            _parseDouble(nutrition['calories']?.toString() ?? '0') ?? 0.0;

        totalCarb += cVal * portion;
        totalProtein += pVal * portion;
        totalFat += fVal * portion;
        totalCalories += calVal * portion;
      }
    }

    if (totalCarb > 0 ||
        totalProtein > 0 ||
        totalFat > 0 ||
        totalCalories > 0) {
      _carbController.text = totalCarb
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      _proteinController.text = totalProtein
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      _fatController.text = totalFat
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      _caloriesController.text = totalCalories
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
    } else {
      _carbController.text = '0';
      _proteinController.text = '0';
      _fatController.text = '0';
      _caloriesController.text = '0';
    }
  }

  Future<void> _applyMealPlanByName(String name) async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) return;

    final mealPlan = await _fetchMealPlanByName(token, name);
    if (mealPlan == null) return;

    final uuid = mealPlan['uuid']?.toString();
    if (uuid == null || uuid.isEmpty) return;

    _recalculateTotalNutritions();

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> _submitManual() async {
    if (_isSubmitting) return;

    if (!_isManualSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Metode selain manual belum tersedia.')),
      );
      return;
    }

    final childUuid = await SecureStorageService.getSelectedChildUuid();
    if (childUuid == null || childUuid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Child UUID tidak ditemukan.')),
      );
      return;
    }

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan. Silakan login.')),
      );
      return;
    }

    final activeForms = _activeForms();
    if (activeForms.isEmpty) return;

    final carb = _parseDouble(_carbController.text);
    final protein = _parseDouble(_proteinController.text);
    final fat = _parseDouble(_fatController.text);
    final calories = _parseDouble(_caloriesController.text);

    if (carb == null || protein == null || fat == null || calories == null) {
      return;
    }

    final portionTotal = _portionTotal(activeForms);

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (final item in activeForms) {
        final body = {
          "child_uuid": childUuid,
          "name": item.mealNameController.text.trim(),
          "type": "berat",
          "meal_time": _mealTimeFromSelection(_selectedMeal?.text),
          "photo": null,
          "carbohydrate": _splitByPortion(
            carb,
            item,
            portionTotal,
            activeForms.length,
          ),
          "protein": _splitByPortion(
            protein,
            item,
            portionTotal,
            activeForms.length,
          ),
          "fat": _splitByPortion(fat, item, portionTotal, activeForms.length),
          "calories": _splitByPortion(
            calories,
            item,
            portionTotal,
            activeForms.length,
          ),
          "data_source": "manual",
          "date": _todayDateString(),
        };

        final response = await _postFoodIntake(
          ApiEndpoints.createManualFoodIntake,
          token,
          body,
        );

        if (!mounted) return;

        debugPrint('[CreateManual] status=${response.statusCode}');
        debugPrint('[CreateManual] body=${response.body}');

        if (response.statusCode < 200 || response.statusCode >= 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan. (${response.statusCode})'),
            ),
          );
          return;
        }
      }

      _resetFormAfterSuccess();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan jaringan.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitAutoFilled() async {
    if (_isSubmitting) return;

    if (!_isAutoSelected) return;

    final childUuid = await SecureStorageService.getSelectedChildUuid();
    if (childUuid == null || childUuid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Child UUID tidak ditemukan.')),
      );
      return;
    }

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan. Silakan login.')),
      );
      return;
    }

    if (_mealPlansCache.isEmpty) {
      await _loadMealPlanNames();
    }

    final activeForms = _activeForms();
    if (activeForms.isEmpty) return;

    for (final item in activeForms) {
      final name = item.mealNameController.text.trim();
      final mealPlan = _findMealPlanByName(name);
      final mealPlanUuid = mealPlan?['uuid']?.toString() ?? '';
      if (mealPlan == null || mealPlanUuid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal plan "$name" tidak ditemukan.')),
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (final item in activeForms) {
        final name = item.mealNameController.text.trim();
        final mealPlan = _findMealPlanByName(name)!;
        final nutrition = _nutritionFromMealPlan(mealPlan);
        final portion = _parsePortion(item.portionsController.text);

        final body = {
          "child_uuid": childUuid,
          "mealplan_uuid": mealPlan['uuid']?.toString(),
          "type": "berat",
          "meal_time": _mealTimeFromSelection(_selectedMeal?.text),
          "photo": null,
          "carbohydrate":
              (_parseDouble(nutrition['carbohydrate']?.toString() ?? '0') ??
                  0) *
              portion,
          "protein":
              (_parseDouble(nutrition['protein']?.toString() ?? '0') ?? 0) *
              portion,
          "fat":
              (_parseDouble(nutrition['fat']?.toString() ?? '0') ?? 0) *
              portion,
          "calories":
              (_parseDouble(nutrition['calories']?.toString() ?? '0') ?? 0) *
              portion,
          "data_source": "internal",
          "date": _todayDateString(),
        };

        final response = await _postFoodIntake(
          ApiEndpoints.createFoodIntakeFromMealPlan,
          token,
          body,
        );

        if (!mounted) return;

        debugPrint('[CreateFromMealPlan] status=${response.statusCode}');
        debugPrint('[CreateFromMealPlan] body=${response.body}');

        if (response.statusCode < 200 || response.statusCode >= 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan. (${response.statusCode})'),
            ),
          );
          return;
        }
      }

      _resetFormAfterSuccess();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan jaringan.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _loadMealPlanNames() async {
    if (_mealPlansCache.isNotEmpty) return;
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) return;
    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlan),
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return;
      }

      final decoded = jsonDecode(response.body);
      final mealPlans = _extractMealPlanList(decoded);
      if (mealPlans.isEmpty) return;

      _mealPlansCache.clear();
      _mealPlansCache.addAll(mealPlans.whereType<Map<String, dynamic>>());

      _mealPlanNamesCache
        ..clear()
        ..addAll(
          _mealPlansCache
              .map((e) => e['name']?.toString() ?? '')
              .where((e) => e.isNotEmpty),
        );

      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> _fetchMealPlanByName(
    String token,
    String name,
  ) async {
    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlan),
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      final mealPlans = _extractMealPlanList(decoded);
      if (mealPlans.isEmpty) return null;

      _mealPlansCache.clear();
      _mealPlansCache.addAll(mealPlans.whereType<Map<String, dynamic>>());

      _mealPlanNamesCache
        ..clear()
        ..addAll(
          _mealPlansCache
              .map((e) => e['name']?.toString() ?? '')
              .where((e) => e.isNotEmpty),
        );

      final normalizedName = name.toLowerCase().trim();
      for (final mealPlan in mealPlans) {
        if ((mealPlan['name']?.toString().toLowerCase() ?? '') ==
            normalizedName) {
          return mealPlan;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> _extractMealPlanList(dynamic decoded) {
    if (decoded is! Map<String, dynamic>) {
      return const <Map<String, dynamic>>[];
    }

    final dataNode = decoded['data'];

    if (dataNode is Map<String, dynamic>) {
      final mealPlansNode = dataNode['meal_plans'];
      if (mealPlansNode is List) {
        return mealPlansNode.whereType<Map<String, dynamic>>().toList();
      }

      final mealPlanNode = dataNode['meal_plan'];
      if (mealPlanNode is Map<String, dynamic>) {
        return <Map<String, dynamic>>[mealPlanNode];
      }
    }

    if (dataNode is List) {
      return dataNode.whereType<Map<String, dynamic>>().toList();
    }

    return const <Map<String, dynamic>>[];
  }

  void _resetFormAfterSuccess() {
    for (final item in _forms) {
      item.mealNameController.clear();
      item.portionsController.clear();
    }
    _carbController.clear();
    _proteinController.clear();
    _fatController.clear();
    _caloriesController.clear();

    setState(() {
      _forms
        ..clear()
        ..add(MealFormItem());
    });
    if (!mounted) return;
    DialogAlert.show(
      context: context,
      customChild: Content2(
        title: 'Yeay, Sudah Tersimpan!',
        message:
            'Data kalori hari ini berhasil disimpan. Bunda bisa lanjut isi form food waste atau lihat ringkasan harian, ya!',
        textNavLeft: 'Bagikan',
        texLeftWidth: 6.5,
        texRightWidth: 6.5,
        iconAssetRight: 'assets/svg/ic_waste.svg',
        buttonCollorLeft: AppColors.primary1,
        textNavRight: 'Food Waste',
        iconAssetLeft: 'assets/svg/ic_share.svg',
        buttonCollorRight: AppColors.success2,
        onClose: (context) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Navbar()),
          );
        },
        onPressedLeft: () {
          Navigator.pop(context);
        },
        onPressedRight: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageFormFoodWaste()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Detail Makanan',
          style: AppTextStyles.heading3SemiBold(AppColors.secondary1),
        ),
        const SizedBox(height: 2),
        Text(
          'Lengkapi data makanan yang dikonsumsi hari ini',
          style: AppTextStyles.list1Regular(
            AppColors.base1.withValues(alpha: 0.65),
          ),
        ),

        // =============== form tambah makanan ===============
        const SizedBox(height: 12),

        CmpMealForm(
          selectedMeal: _selectedMeal,
          selectedCalorieMethod: _selectedCalorieMethod,
          onMealChanged: (item) {
            setState(() {
              _selectedMeal = item;
            });
            _tryAutoFillFromMealPlan();
          },
          onCalorieMethodChanged: (item) {
            setState(() {
              _selectedCalorieMethod = item;
            });
            _tryAutoFillFromMealPlan();
            if (_isAutoSelected) {
              _loadMealPlanNames();
            }
          },
        ),
        const SizedBox(height: 16),
        CmpAddMealForm(
          forms: _forms,
          onChanged: _onFormChanged,
          onItemAdded: (item) {},
          onItemRemoved: (index) {},
          enableAutoComplete: _isAutoSelected,
          autoCompleteOptions: _mealPlanNamesCache,
          onAutoCompleteSelected: (value) async {
            await _applyMealPlanByName(value);
          },
        ),
        if (_isManualSelected || _isAutoSelected) ...[
          const SizedBox(height: 16),
          Text(
            'Informasi Gizi',
            style: AppTextStyles.heading3SemiBold(AppColors.secondary1),
          ),
          const SizedBox(height: 2),
          Text(
            'Perbarui nilai gizi sesuai jumlah porsi yang dimakan',
            style: AppTextStyles.list1Regular(
              AppColors.base1.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildNutritionCard(
                iconPath: 'assets/svg/ic_nutrition.svg',
                title: 'Karbohidrat',
                unit: 'gr',
                controller: _carbController,
              ),
              _buildNutritionCard(
                iconPath: 'assets/svg/ic_fat.svg',
                title: 'Lemak',
                unit: 'gr',
                controller: _fatController,
              ),
              _buildNutritionCard(
                iconPath: 'assets/svg/ic_proteins.svg',
                title: 'Protein',
                unit: 'gr',
                controller: _proteinController,
              ),
              _buildNutritionCard(
                iconPath: 'assets/svg/ic_fire.svg',
                title: 'Total Kalori',
                unit: 'kcal',
                controller: _caloriesController,
              ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        GlobalsButton(
          color: _isFormValid ? AppColors.secondary1 : AppColors.base2,
          height: 48,
          onPressed: (_isSubmitting || !_isFormValid)
              ? null
              : () {
                  DialogAlert.show(
                    context: context,
                    customChild: Content2(
                      title: 'Simpan Data Kalori?',
                      message:
                          'Pastikan semua takaran dan data sudah sesuai ya, Bun. Setelah disimpan, kamu tetap bisa mengedit kapan saja jika dibutuhkan.',
                      textNavLeft: 'Cek Kembali',
                      buttonCollorLeft: AppColors.warn1,
                      textNavRight: 'Simpan',
                      buttonCollorRight: AppColors.success2,
                      onPressedLeft: () {
                        Navigator.pop(context);
                      },
                      onPressedRight: () async {
                        Navigator.pop(context);
                        if (_isManualSelected) {
                          await _submitManual();
                        } else if (_isAutoSelected) {
                          await _submitAutoFilled();
                        }
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
              else ...[
                Text(
                  'Simpan Kalori Makanan',
                  style: AppTextStyles.headList1Bold(AppColors.base5),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildNutritionCard({
  required String iconPath,
  required String title,
  required String unit,
  required TextEditingController controller,
}) {
  return SizedBox(
    width: 168,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.base4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: SvgPicture.asset(iconPath),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.list1Medium(
                    AppColors.base1.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: IntrinsicWidth(
                  child: GlobalsForm(
                    focusBorderColor: Colors.transparent,
                    enableBorderColor: Colors.transparent,
                    labelColor: Colors.grey,
                    outlineInputBorderColor: Colors.transparent,
                    enableFloatingLabel: false,
                    hasShadow: false,
                    controller: controller,
                    label: '0',
                    textStyle: AppTextStyles.heading3SemiBold(),
                    hintStyle: AppTextStyles.heading3SemiBold(),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.base4,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  unit,
                  style: AppTextStyles.list1Bold(AppColors.secondary1),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
