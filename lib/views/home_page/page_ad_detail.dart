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
//  PageAdDetail — Halaman detail iklan
//  Terima [adId] (int), fetch detail dari API, tampilkan thumbnail + HTML body
// ===========================================================================
class PageAdDetail extends StatefulWidget {
  final int adId;
  final String? heroTag;

  const PageAdDetail({
    super.key,
    required this.adId,
    this.heroTag,
  });

  @override
  State<PageAdDetail> createState() => _PageAdDetailState();
}

class _PageAdDetailState extends State<PageAdDetail> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _ad;

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

      final url = ApiEndpoints.adDetail(widget.adId);
      debugPrint('[PageAdDetail] 🚀 Fetching Ad Detail ID: ${widget.adId} ($url)');
      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      debugPrint('[PageAdDetail] 📥 Status Code: ${res.statusCode}');
      debugPrint('[PageAdDetail] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _ad = decoded['data'] as Map<String, dynamic>?;
            _isLoading = false;
          });
        }
      } else {
        debugPrint('[PageAdDetail] ❌ Failed with status ${res.statusCode}');
        if (mounted) setState(() { _error = 'Gagal memuat iklan (${res.statusCode})'; _isLoading = false; });
      }
    } catch (e, stack) {
      debugPrint('[PageAdDetail] 🚨 Error fetching ad detail: $e');
      debugPrint('[PageAdDetail] 🚨 StackTrace: $stack');
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
          _ad?['title'] ?? 'Detail Iklan',
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
    final ad = _ad!;
    final thumbnail = ad['thumbnail']?.toString() ?? '';
    final title = ad['title']?.toString() ?? '';
    final subtitle = ad['subtitle']?.toString() ?? '';
    final description = ad['description']?.toString() ?? '';
    final targetUrl = ad['target_url']?.toString() ?? '';
    final startsAt = ad['starts_at']?.toString();
    final endsAt = ad['ends_at']?.toString();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ─────────────────────────────────────────────────
          if (thumbnail.isNotEmpty)
            Hero(
              tag: widget.heroTag ?? 'ad_${widget.adId}',
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
                // ── Judul ──────────────────────────────────────────────
                Text(title,
                    style: AppTextStyles.heading2SemiBold(AppColors.base1)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: AppTextStyles.list1Regular(AppColors.base2)),
                ],

                // ── Periode ─────────────────────────────────────────────
                if (startsAt != null || endsAt != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary3,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: AppColors.primary1),
                        const SizedBox(width: 6),
                        Text(
                          _formatPeriode(startsAt, endsAt),
                          style:
                              AppTextStyles.list3SemiBold(AppColors.primary1),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.base4),
                const SizedBox(height: 16),

                // ── Deskripsi HTML ────────────────────────────────────
                if (description.isNotEmpty)
                  Html(
                    data: description,
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

                // ── Tombol buka URL ───────────────────────────────────
                if (targetUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openUrl(targetUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary1,
                        foregroundColor: AppColors.base5,
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
                          Text('Kunjungi Halaman',
                              style: AppTextStyles.heading3SemiBold(
                                  AppColors.base5)),
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

  String _formatPeriode(String? starts, String? ends) {
    if (starts == null && ends == null) return '';
    if (starts != null && ends != null) {
      return 'Berlaku: ${_formatDate(starts)} – ${_formatDate(ends)}';
    }
    if (starts != null) return 'Mulai: ${_formatDate(starts)}';
    return 'Hingga: ${_formatDate(ends!)}';
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
