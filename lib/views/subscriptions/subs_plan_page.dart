import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/dialog/badge_tooltip.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/subscriptions/subs_plan_cmp.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../components/globals/button/globals_button.dart';

class SubsPlanPage extends StatefulWidget {
  const SubsPlanPage({super.key});

  @override
  State<SubsPlanPage> createState() => _SubsPlanPageState();
}

class _SubsPlanPageState extends State<SubsPlanPage> {
  int _selectedIndex = -1;
  bool _isSubmitting = false;
  late Future<List<_SubsPlanItem>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() {
    _plansFuture = _fetchPlans();
  }

  Future<List<_SubsPlanItem>> _fetchPlans() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.subscriptions),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    debugPrint('Response Body_subs: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Gagal mengambil data subscription (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final subscriptions = (data['subscriptions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    // debugPrint('🔍 Subscriptions fetched uuid: $subscriptions');
    // for (var sub in subscriptions) {
    //   final package = sub['package'] as Map<String, dynamic>? ?? {};
    //   final uuid = package['uuid'];
    //   debugPrint('Package UUID: $uuid');
    // }

    for (var sub in subscriptions) {
      final package = sub['package'] as Map<String, dynamic>? ?? {};
      final step = package['step'];
      debugPrint('Step: $step');
    }

    return subscriptions
        .map((subscription) => _SubsPlanItem.fromApi(subscription))
        .toList();
  }

  Future<void> _handleCheckout(String productUuid) async {
    setState(() => _isSubmitting = true);

    try {
      final token = await SecureStorageService.getToken();
      final childUuid = await SecureStorageService.getSelectedChildUuid();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan');
      }

      if (childUuid == null || childUuid.isEmpty) {
        throw Exception('Anak belum dipilih');
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.subscriptionsCheckout),
        headers: {
          'Authorization': token,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'product_uuid': productUuid,
          'child_uuid': childUuid,
        }),
      );

      debugPrint('Response checkout: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>? ?? {};
        final checkoutUrl = data['checkout_url']?.toString() ?? '';

        if (checkoutUrl.isNotEmpty) {
          final uri = Uri.parse(checkoutUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw Exception('Tidak dapat membuka checkout URL');
          }
        } else {
          throw Exception('Checkout URL kosong');
        }
      } else {
        throw Exception(
            'Gagal melakukan checkout (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('Error checkout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memulai pembayaran: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                'Pilih Paket Anda',
                style: AppTextStyles.heading1SemiBold(),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<_SubsPlanItem>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = -1;
                    _loadPlans();
                  });
                },
                child: const Text('Gagal memuat paket. Coba lagi'),
              ),
            );
          }

          final plans = snapshot.data ?? [];
          if (plans.isEmpty) {
            return const Center(child: Text('Belum ada paket subscription'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Langganan sesuai kebutuhan, demi tumbuh kembang anak yang optimal',
                    style: AppTextStyles.heading3SemiBold(AppColors.base2),
                  ),
                ),
                ...plans.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final plan = entry.value;

                    return SubsPlanCmp(
                      price: plan.priceInK,
                      periodLabel: plan.periodLabel,
                      title: plan.title,
                      desc: plan.desc,
                      image: plan.step.asset,
                      step: plan.step,
                      features: plan.features,
                      gradient: plan.gradient,
                      selectedBorderColor: plan.selectedBorderColor,
                      isSelected: _selectedIndex == index,
                      onTap: () => setState(() => _selectedIndex = index),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlobalsButton(
                    color: (_selectedIndex == -1 || _isSubmitting)
                        ? AppColors.secondary2
                        : AppColors.secondary1,
                    text: _isSubmitting ? 'Memproses...' : 'Berlangganan',
                    onPressed: (_selectedIndex == -1 || _isSubmitting)
                        ? null
                        : () {
                            final selectedPlan = plans[_selectedIndex];
                            _handleCheckout(selectedPlan.uuid);
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubsPlanItem {
  final String uuid;
  final String priceInK;
  final String periodLabel;
  final String title;
  final String desc;
  final TooltipStep step;
  final Gradient? gradient;
  final Color selectedBorderColor;
  final List<FeatureTile> features;

  const _SubsPlanItem({
    required this.uuid,
    required this.priceInK,
    required this.periodLabel,
    required this.title,
    required this.desc,
    required this.step,
    required this.gradient,
    required this.selectedBorderColor,
    required this.features,
  });

  static const Map<TooltipStep, _PlanUiPreset> _presetsByStep = {
    TooltipStep.awal: _PlanUiPreset(
      step: TooltipStep.awal,
      defaultDesc: 'Coba dulu, tanpa risiko!',
      features: [
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Akses Gratis 1 Meal Plan',
        ),
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Pantau Kalori Harian',
        ),
      ],
    ),
    TooltipStep.pertama: _PlanUiPreset(
      step: TooltipStep.pertama,
      defaultDesc: 'Mulai pelan, dampingi dengan tenang.',
      features: [
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Akses Semua Meal Plan',
        ),
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: '1x Konsultasi Ahli Gizi',
        ),
      ],
    ),
    TooltipStep.pasti: _PlanUiPreset(
      step: TooltipStep.pasti,
      defaultDesc: 'Lebih hemat dari paket bulanan.',
      features: [
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: '3x Konsultasi Ahli Gizi',
        ),
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Akses Konten Edukasi Premium',
        ),
      ],
    ),
    TooltipStep.hebat: _PlanUiPreset(
      step: TooltipStep.hebat,
      defaultDesc: 'Pendampingan intensif untuk progres maksimal.',
      features: [
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: '6 Bulan Pendampingan',
        ),
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: '1x Sesi Zoom Dokter Gizi',
        ),
      ],
    ),
    TooltipStep.lengkap: _PlanUiPreset(
      step: TooltipStep.lengkap,
      defaultDesc: 'Dukungan lengkap untuk tumbuh kembang optimal.',
      selectedBorderColor: AppColors.primary1,
      gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color.fromRGBO(167, 190, 188, 0.6),
          Color.fromRGBO(243, 243, 243, 0.8),
          Color.fromRGBO(255, 250, 225, 0.5),
        ],
      ),
      features: [
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Konsultasi Rutin',
        ),
        FeatureTile(
          iconAsset: 'assets/svg/check-box.svg',
          text: 'Akses Konten Edukasi Premium',
        ),
      ],
    ),
  };

  static const _PlanUiPreset _defaultPreset = _PlanUiPreset(
    step: TooltipStep.awal,
    defaultDesc: 'Coba dulu, tanpa risiko!',
    features: [
      FeatureTile(
        iconAsset: 'assets/svg/check-box.svg',
        text: 'Akses Gratis 1 Meal Plan',
      ),
      FeatureTile(
        iconAsset: 'assets/svg/check-box.svg',
        text: 'Pantau Kalori Harian',
      ),
    ],
  );

  factory _SubsPlanItem.fromApi(Map<String, dynamic> json) {
    final package = json['package'] as Map<String, dynamic>? ?? {};
    final rawStep = (package['step']?.toString() ?? '').trim().toLowerCase();
    final step = _stepFromApi(rawStep);
    final preset = _presetsByStep[step] ?? _defaultPreset;

    final rawUuid = (package['uuid']?.toString() ?? '').trim();
    final rawName = (package['name']?.toString() ?? '').trim();
    final rawDesc = (package['description']?.toString() ?? '').trim();
    final rawStartDate = (json['start_date']?.toString() ?? '').trim();
    final rawEndDate = (json['end_date']?.toString() ?? '').trim();

    final rawPrice = package['price'];
    int price = 0;
    if (rawPrice is int) {
      price = rawPrice;
    } else if (rawPrice is String) {
      price = int.tryParse(rawPrice) ?? 0;
    }

    return _SubsPlanItem(
      uuid: rawUuid,
      priceInK: _formatPriceInK(price),
      periodLabel: _periodLabelFromDates(rawStartDate, rawEndDate),
      title: rawName.isEmpty ? 'Paket Subscription' : rawName,
      desc: rawDesc.isEmpty ? preset.defaultDesc : rawDesc,
      step: preset.step,
      gradient: preset.gradient,
      selectedBorderColor: preset.selectedBorderColor,
      features: preset.features,
    );
  }

  static TooltipStep _stepFromApi(String rawStep) {
    switch (rawStep) {
      case 'awal':
        return TooltipStep.awal;
      case 'pertama':
        return TooltipStep.pertama;
      case 'pasti':
        return TooltipStep.pasti;
      case 'hebat':
        return TooltipStep.hebat;
      case 'lengkap':
        return TooltipStep.lengkap;
      default:
        return TooltipStep.awal;
    }
  }

  static String _periodLabelFromDates(String startDateRaw, String endDateRaw) {
    if (startDateRaw.isEmpty || endDateRaw.isEmpty) return '-';

    final startDate = DateTime.tryParse(startDateRaw);
    final endDate = DateTime.tryParse(endDateRaw);
    if (startDate == null || endDate == null) return '-';

    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    if (end.isBefore(start)) return '-';

    final totalDays = end.difference(start).inDays + 1;
    if (totalDays == 365 || totalDays == 366) return '1 tahun';
    if (totalDays >= 28 && totalDays <= 31) return '1 bulan';
    return '$totalDays hari';
  }

  static String _formatPriceInK(int price) {
    if (price <= 0) return '0';
    return (price / 1000).round().toString();
  }
}

class _PlanUiPreset {
  final TooltipStep step;
  final String defaultDesc;
  final Gradient? gradient;
  final Color selectedBorderColor;
  final List<FeatureTile> features;

  const _PlanUiPreset({
    required this.step,
    required this.defaultDesc,
    this.gradient,
    this.selectedBorderColor = AppColors.secondary1,
    this.features = const [],
  });
}
