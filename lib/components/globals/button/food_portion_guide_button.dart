import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

String _normalizeGuidelineImageUrl(String? imageUrl) {
  final url = imageUrl?.trim() ?? '';
  if (url.isEmpty) return '';

  if (url.contains('drive.google.com')) {
    final regExpD = RegExp(r'file/d/([a-zA-Z0-9_-]+)');
    final matchD = regExpD.firstMatch(url);
    if (matchD != null && matchD.groupCount >= 1) {
      final fileId = matchD.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    final regExpId = RegExp(r'id=([a-zA-Z0-9_-]+)');
    final matchId = regExpId.firstMatch(url);
    if (matchId != null && matchId.groupCount >= 1) {
      final fileId = matchId.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
  }

  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }

  if (url.startsWith('/')) {
    return "${ApiBaseUrl.baseUrl}$url";
  }
  return "${ApiBaseUrl.baseUrl}/$url";
}

class FoodPortionGuideButton extends StatefulWidget {
  final bool showBanner;
  final String slug;

  const FoodPortionGuideButton({
    super.key,
    this.showBanner = false,
    this.slug = 'food-measurement',
  });

  @override
  State<FoodPortionGuideButton> createState() => _FoodPortionGuideButtonState();
}

class _FoodPortionGuideButtonState extends State<FoodPortionGuideButton> {
  bool _isLoading = true;
  GuidelineData? _guidelineData;

  @override
  void initState() {
    super.initState();
    _fetchGuidelines();
  }

  Future<void> _fetchGuidelines() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.guidelines),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final rawData = decoded['data'];

        if (rawData is List) {
          final foodMeasurementJson = rawData.firstWhere(
            (element) => element['slug'] == widget.slug,
            orElse: () => null,
          );

          if (foodMeasurementJson != null) {
            final guideline = GuidelineData.fromJson(foodMeasurementJson);
            if (mounted) {
              setState(() {
                _guidelineData = guideline;
                _isLoading = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _normalizeButtonText(String? apiText) {
    final text = apiText?.trim() ?? '';
    if (text.isNotEmpty) return text;
    if (widget.slug == 'food-waste-guide') {
      return 'Panduan Sisa Makanan';
    } else if (widget.slug == 'growth-chart-guide') {
      return 'Panduan Baca Grafik';
    }
    return 'Panduan Ukuran Makanan';
  }

  @override
  Widget build(BuildContext context) {
    // Bangun banner jika diaktifkan
    Widget? bannerWidget;
    if (widget.showBanner) {
      if (_isLoading) {
        bannerWidget = const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      } else if (_guidelineData != null) {
        final bannerTitle = _guidelineData!.bannerTitle.isNotEmpty
            ? _guidelineData!.bannerTitle
            : 'Butuh Bantuan Mengukur Takaran?';
        final bannerDesc = _guidelineData!.bannerDescription.isNotEmpty
            ? _guidelineData!.bannerDescription
            : 'Lihat food model kami untuk membandingkan ukuran makanan.';

        bannerWidget = CmpTagAttention(
          imageAsset: 'assets/svg/ic_question_mark.svg',
          imageColor: AppColors.primary1,
          lineColor: AppColors.primary2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bannerTitle,
                style: AppTextStyles.list1Bold(AppColors.base1),
              ),
              const SizedBox(height: 4),
              Text(
                bannerDesc,
                style: AppTextStyles.list1Regular(
                  AppColors.base1.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      }
    }

    final buttonText = _normalizeButtonText(_guidelineData?.bannerButtonText);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (bannerWidget != null) ...[
          bannerWidget,
          const SizedBox(height: 12),
        ],
        GlobalsCard(
          hasShadow: false,
          backgroundColor: AppColors.secondary1,
          height: 30,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => FoodPortionGuideDialog(
                initialData: _guidelineData,
                slug: widget.slug,
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/bento-box-rounded.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.base5,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                buttonText,
                style: AppTextStyles.list1Bold(AppColors.base5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FoodPortionGuideDialog extends StatefulWidget {
  final GuidelineData? initialData;
  final String slug;

  const FoodPortionGuideDialog({
    super.key,
    this.initialData,
    this.slug = 'food-measurement',
  });

  @override
  State<FoodPortionGuideDialog> createState() => _FoodPortionGuideDialogState();
}

class _FoodPortionGuideDialogState extends State<FoodPortionGuideDialog> {
  bool _isLoading = true;
  String? _errorMessage;
  GuidelineData? _guidelineData;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _guidelineData = widget.initialData;
      if (_guidelineData!.categories.isNotEmpty) {
        _selectedCategoryId = _guidelineData!.categories.first.id;
      }
      _isLoading = false;
    } else {
      _fetchGuidelines();
    }
  }

  Future<void> _fetchGuidelines() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Token tidak ditemukan. Silakan login kembali.';
            _isLoading = false;
          });
        }
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.guidelines),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final rawData = decoded['data'];

        if (rawData is List) {
          final foodMeasurementJson = rawData.firstWhere(
            (element) => element['slug'] == widget.slug,
            orElse: () => null,
          );

          if (foodMeasurementJson != null) {
            final guideline = GuidelineData.fromJson(foodMeasurementJson);
            if (mounted) {
              setState(() {
                _guidelineData = guideline;
                if (guideline.categories.isNotEmpty) {
                  _selectedCategoryId = guideline.categories.first.id;
                }
                _isLoading = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _errorMessage = 'Panduan dengan slug "${widget.slug}" tidak ditemukan.';
                _isLoading = false;
              });
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _errorMessage = 'Format respons tidak valid.';
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Gagal mengambil data dari server (${response.statusCode}).';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan saat memuat panduan.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.base5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: AppColors.base1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 24.0),
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  String _normalizeDialogTitle(String? apiTitle) {
    final title = apiTitle?.trim() ?? '';
    if (title.isNotEmpty) return title;
    if (widget.slug == 'food-waste-guide') {
      return 'Panduan Mengukur Sisa Makanan';
    } else if (widget.slug == 'growth-chart-guide') {
      return 'Panduan Membaca Grafik';
    }
    return 'Panduan Ukuran Makanan';
  }

  String _normalizeDialogDescription(String? apiDesc) {
    final desc = apiDesc?.trim() ?? '';
    if (desc.isNotEmpty) return desc;
    if (widget.slug == 'food-waste-guide') {
      return 'Perkirakan sisa makanan Bunda dengan membandingkan visual di bawah ini.';
    } else if (widget.slug == 'growth-chart-guide') {
      return 'Pahami grafik pertumbuhan anak Anda berdasarkan standar WHO.';
    }
    return 'Takaran makanan bisa beda-beda, tetapi jangan khawatir!';
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary1),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.warn1, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.list1Regular(AppColors.base1),
              ),
            ],
          ),
        ),
      );
    }

    if (_guidelineData == null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Panduan tidak tersedia.',
            style: AppTextStyles.list1Regular(AppColors.base1),
          ),
        ),
      );
    }

    final title = _normalizeDialogTitle(_guidelineData!.title);
    final description = _normalizeDialogDescription(_guidelineData!.description);

    final currentCategory = _guidelineData!.categories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
      orElse: () => _guidelineData!.categories.first,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading2SemiBold(AppColors.base1),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyles.list1Regular(AppColors.base1.withValues(alpha: 0.8)),
        ),
        const SizedBox(height: 20),

        if (_guidelineData!.categories.length > 1) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _guidelineData!.categories.map((cat) {
                final isSelected = cat.id == _selectedCategoryId;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = cat.id;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondary1 : AppColors.base4,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat.name,
                      style: isSelected
                          ? AppTextStyles.list1Bold(AppColors.base5)
                          : AppTextStyles.list1Regular(AppColors.base2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (currentCategory.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Text('Tidak ada item panduan dalam kategori ini.'),
          )
        else
          SizedBox(
            height: 260,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: currentCategory.items.map((item) {
                  return Container(
                    width: 170,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.base5,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.base4,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.base2.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary1,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.label,
                              style: AppTextStyles.list1Bold(AppColors.base5)
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 100,
                            child: item.image != null && item.image!.isNotEmpty
                                ? Image.network(
                                    _normalizeGuidelineImageUrl(item.image),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.fastfood_outlined,
                                        size: 48,
                                        color: AppColors.base3,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.fastfood_outlined,
                                    size: 48,
                                    color: AppColors.base3,
                                  ),
                          ),
                          const Spacer(),
                          Text(
                            item.foodName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.list1Bold(AppColors.secondary1)
                                .copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.servingSize,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.list1Regular(AppColors.base1)
                                .copyWith(fontSize: 12),
                          ),
                          Text(
                            item.weight,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.list1Bold(AppColors.secondary1)
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class GuidelineItem {
  final int id;
  final String? image;
  final String label;
  final String foodName;
  final String servingSize;
  final String weight;

  GuidelineItem({
    required this.id,
    this.image,
    required this.label,
    required this.foodName,
    required this.servingSize,
    required this.weight,
  });

  factory GuidelineItem.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>? ?? {};
    return GuidelineItem(
      id: json['id'] as int? ?? 0,
      image: json['image'] as String?,
      label: (content['label'] ?? '').toString(),
      foodName: (content['food_name'] ?? '').toString(),
      servingSize: (content['serving_size'] ?? '').toString(),
      weight: (content['weight'] ?? '').toString(),
    );
  }
}

class GuidelineCategory {
  final int id;
  final String name;
  final List<GuidelineItem> items;

  GuidelineCategory({
    required this.id,
    required this.name,
    required this.items,
  });

  factory GuidelineCategory.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    return GuidelineCategory(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? '').toString(),
      items: rawItems
          .map((e) => GuidelineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GuidelineData {
  final String slug;
  final String bannerTitle;
  final String bannerDescription;
  final String bannerButtonText;
  final String title;
  final String description;
  final List<GuidelineCategory> categories;

  GuidelineData({
    required this.slug,
    required this.bannerTitle,
    required this.bannerDescription,
    required this.bannerButtonText,
    required this.title,
    required this.description,
    required this.categories,
  });

  factory GuidelineData.fromJson(Map<String, dynamic> json) {
    final banner = json['banner'] as Map<String, dynamic>? ?? {};
    final popup = json['popup'] as Map<String, dynamic>? ?? {};
    final rawCategories = json['categories'] as List? ?? [];
    return GuidelineData(
      slug: (json['slug'] ?? '').toString(),
      bannerTitle: (banner['title'] ?? '').toString(),
      bannerDescription: (banner['description'] ?? '').toString(),
      bannerButtonText: (banner['button_text'] ?? '').toString(),
      title: (popup['title'] ?? '').toString(),
      description: (popup['description'] ?? '').toString(),
      categories: rawCategories
          .map((e) => GuidelineCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
