import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

// ===========================================================================
//  PageCarouselDetail — Halaman detail carousel/promo event
//  Terima [carouselUuid] (String), fetch detail dari API,
//  tampilkan thumbnail + HTML content + tags + tombol buka link
// ===========================================================================
class PageCarouselDetail extends StatefulWidget {
  final String carouselUuid;
  final String? heroTag;

  const PageCarouselDetail({
    super.key,
    required this.carouselUuid,
    this.heroTag,
  });

  @override
  State<PageCarouselDetail> createState() => _PageCarouselDetailState();
}

class _PageCarouselDetailState extends State<PageCarouselDetail> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _carousel;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final url = ApiEndpoints.carouselDetail(widget.carouselUuid);
      debugPrint('[PageCarouselDetail] 🚀 Fetching Carousel UUID: ${widget.carouselUuid} ($url)');
      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      debugPrint('[PageCarouselDetail] 📥 Status Code: ${res.statusCode}');
      debugPrint('[PageCarouselDetail] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _carousel = decoded['data'] as Map<String, dynamic>?;
            _isLoading = false;
          });
        }
      } else {
        debugPrint('[PageCarouselDetail] ❌ Failed with status ${res.statusCode}');
        if (mounted) {
          setState(() {
            _error = 'Gagal memuat konten (${res.statusCode})';
            _isLoading = false;
          });
        }
      }
    } catch (e, stack) {
      debugPrint('[PageCarouselDetail] 🚨 Error fetching carousel detail: $e');
      debugPrint('[PageCarouselDetail] 🚨 StackTrace: $stack');
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.base1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _carousel?['title'] ?? 'Detail Promo',
          style: AppTextStyles.heading3SemiBold(AppColors.base1),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary1))
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: AppTextStyles.list1Regular(AppColors.warn1)))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final c = _carousel!;
    final thumbnail = c['thumbnail']?.toString() ?? '';
    final title = c['title']?.toString() ?? '';
    final subtitle = c['subtitle']?.toString() ?? '';
    final content = c['content']?.toString() ?? '';
    final hrefLink = c['href_link']?.toString() ?? '';
    final rawTags = c['tags'];
    final List<String> tags = rawTags is List
        ? rawTags.map((t) => t.toString()).toList()
        : [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ─────────────────────────────────────────────────
          if (thumbnail.isNotEmpty)
            Hero(
              tag: widget.heroTag ?? 'carousel_${widget.carouselUuid}',
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: AppColors.base4,
                    child: const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 48, color: AppColors.base2),
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tags ──────────────────────────────────────────────
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: tags.map((tag) => _TagChip(label: tag)).toList(),
                  ),
                if (tags.isNotEmpty) const SizedBox(height: 12),

                // ── Judul ─────────────────────────────────────────────
                Text(title,
                    style: AppTextStyles.heading2SemiBold(AppColors.base1)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: AppTextStyles.list1Regular(AppColors.base2)),
                ],

                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.base4),
                const SizedBox(height: 16),

                // ── Konten HTML ──────────────────────────────────────
                if (content.isNotEmpty)
                  Html(
                    data: content,
                    style: {
                      'body': Style(
                        fontSize: FontSize(14),
                        color: AppColors.base1,
                        margin: Margins.zero,
                      ),
                      'p': Style(margin: Margins.only(bottom: 8)),
                    },
                  ),

                const SizedBox(height: 28),

                // ── Tombol buka link ────────────────────────────────
                if (hrefLink.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openUrl(hrefLink),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary1,
                        foregroundColor: AppColors.base1,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.open_in_new, size: 16),
                          const SizedBox(width: 8),
                          Text('Lihat Selengkapnya',
                              style: AppTextStyles.heading3SemiBold(
                                  AppColors.base1)),
                        ],
                      ),
                    ),
                  ),

                SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tag chip kecil
// ---------------------------------------------------------------------------
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '#$label',
        style: AppTextStyles.list3SemiBold(AppColors.secondary1),
      ),
    );
  }
}
