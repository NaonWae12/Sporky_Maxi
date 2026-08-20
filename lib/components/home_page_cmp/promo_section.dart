import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/views/home_page/page_ad_detail.dart';

// ===========================================================================
//  PromoSection — Horizontal scroll banner iklan dari API /api/v1/ads
//  Tap → PageAdDetail
//  [showLabel] — opsional tampilkan title & subtitle di atas thumbnail
// ===========================================================================
class PromoSection extends StatefulWidget {
  /// Jika true, tampilkan overlay teks (title + subtitle) di atas thumbnail.
  /// Jika false, hanya tampilkan gambar thumbnail saja (full bleed, tanpa teks).
  final bool showLabel;

  /// Tinggi setiap banner card (default 110)
  final double cardHeight;

  /// Lebar setiap banner card (default 240)
  final double cardWidth;

  const PromoSection({
    super.key,
    this.showLabel = true,
    this.cardHeight = 110,
    this.cardWidth = 240,
  });

  @override
  State<PromoSection> createState() => _PromoSectionState();
}

class _PromoSectionState extends State<PromoSection> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _ads = [];

  @override
  void initState() {
    super.initState();
    _fetchAds();
  }

  Future<void> _fetchAds() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final url = ApiEndpoints.ads;
      debugPrint('[PromoSection] 🚀 Fetching Ads: $url');
      final res = await http.get(Uri.parse(url), headers: headers);

      debugPrint('[PromoSection] 📥 Status Code: ${res.statusCode}');
      debugPrint('[PromoSection] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        final list = data?['ads'] as List? ?? [];
        debugPrint('[PromoSection] ✅ Parsed ${list.length} ads');
        if (mounted) {
          setState(() {
            _ads = list.map((e) => e as Map<String, dynamic>).toList();
            _isLoading = false;
          });
        }
      } else {
        debugPrint(
            '[PromoSection] ❌ Failed to fetch ads with status ${res.statusCode}');
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e, stack) {
      debugPrint('[PromoSection] 🚨 Error fetching ads: $e');
      debugPrint('[PromoSection] 🚨 StackTrace: $stack');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildSkeletonRow();
    }

    if (_ads.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: _ads.map((ad) {
            final id = ad['id'] as int? ?? 0;
            final title = ad['title']?.toString() ?? '';
            final subtitle = ad['subtitle']?.toString() ?? '';
            final thumbnail = ad['thumbnail']?.toString() ?? '';
            final heroTag = 'ad_$id';

            return _AdBannerCard(
              id: id,
              title: title,
              subtitle: subtitle,
              thumbnail: thumbnail,
              heroTag: heroTag,
              showLabel: widget.showLabel,
              cardHeight: widget.cardHeight,
              cardWidth: widget.cardWidth,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageAdDetail(adId: id, heroTag: heroTag),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSkeletonRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: List.generate(
            3,
            (_) => Container(
              width: widget.cardWidth,
              height: widget.cardHeight,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.base4,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AdBannerCard — Kartu banner tunggal, gambar full bleed tanpa background container
// ---------------------------------------------------------------------------
class _AdBannerCard extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final String thumbnail;
  final String heroTag;
  final bool showLabel;
  final double cardHeight;
  final double cardWidth;
  final VoidCallback onTap;

  const _AdBannerCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.heroTag,
    required this.showLabel,
    required this.cardHeight,
    required this.cardWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.only(right: 12),
        // ClipRRect langsung di level atas — gambar mengisi seluruh area, tanpa background
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Thumbnail full bleed ─────────────────────────────────
              if (thumbnail.isNotEmpty)
                Hero(
                  tag: heroTag,
                  child: Image.network(
                    thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _AdPlaceholder(title: title),
                  ),
                )
              else
                _AdPlaceholder(title: title),

              // ── Overlay gradient + teks (opsional) ──────────────────
              if (showLabel) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      stops: const [0.35, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.list1Bold(AppColors.base5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: AppTextStyles.list3SemiBold(
                              AppColors.base5.withValues(alpha: 0.85)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder saat thumbnail gagal dimuat / tidak ada
// ---------------------------------------------------------------------------
class _AdPlaceholder extends StatelessWidget {
  final String title;
  const _AdPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary2, AppColors.secondary1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: AppTextStyles.list1Bold(AppColors.base5),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
