import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/views/home_page/page_carousel_detail.dart';

// ===========================================================================
//  CarouselSection — Komponen horizontal slider untuk data carousel/promo
//  Dapat dipanggil di mana saja (home, dll.)
//  Tap item → buka PageCarouselDetail
// ===========================================================================
class CarouselSection extends StatefulWidget {
  const CarouselSection({super.key});

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchCarousels();
  }

  Future<void> _fetchCarousels() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final url = ApiEndpoints.carousels;
      debugPrint('[CarouselSection] 🚀 Fetching Carousels: $url');
      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      debugPrint('[CarouselSection] 📥 Status Code: ${res.statusCode}');
      debugPrint('[CarouselSection] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        final list = data?['carousels'] as List? ?? [];
        debugPrint('[CarouselSection] ✅ Parsed ${list.length} carousels');
        if (mounted) {
          setState(() {
            _items = list.map((e) => e as Map<String, dynamic>).toList();
            _isLoading = false;
          });
        }
      } else {
        debugPrint('[CarouselSection] ❌ Failed to fetch carousels with status ${res.statusCode}');
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e, stack) {
      debugPrint('[CarouselSection] 🚨 Error fetching carousels: $e');
      debugPrint('[CarouselSection] 🚨 StackTrace: $stack');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (_, __) => _CarouselSkeleton(),
        ),
      );
    }

    if (_items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final item = _items[i];
          final uuid = item['uuid']?.toString() ?? '';
          final title = item['title']?.toString() ?? '';
          final subtitle = item['subtitle']?.toString() ?? '';
          final thumbnail = item['thumbnail']?.toString() ?? '';
          final heroTag = 'carousel_$uuid';

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PageCarouselDetail(
                  carouselUuid: uuid,
                  heroTag: heroTag,
                ),
              ),
            ),
            child: Container(
              width: 260,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.secondary1,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary1.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // ── Thumbnail ───────────────────────────────────────
                  if (thumbnail.isNotEmpty)
                    Hero(
                      tag: heroTag,
                      child: SizedBox.expand(
                        child: Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.secondary2.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(color: AppColors.secondary2.withValues(alpha: 0.3)),

                  // ── Gradient overlay ────────────────────────────────
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.secondary1.withValues(alpha: 0.85),
                          ],
                          stops: const [0.35, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // ── Teks ────────────────────────────────────────────
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.heading3SemiBold(AppColors.base5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: AppTextStyles.list1Regular(
                                AppColors.base5.withValues(alpha: 0.8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton loading card
// ---------------------------------------------------------------------------
class _CarouselSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.base4,
      ),
    );
  }
}
