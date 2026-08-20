import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

// ===========================================================================
//  MainPageVouchers — Halaman Utama Daftar Voucher
// ===========================================================================
class MainPageVouchers extends StatefulWidget {
  const MainPageVouchers({super.key});

  @override
  State<MainPageVouchers> createState() => _MainPageVouchersState();
}

class _MainPageVouchersState extends State<MainPageVouchers> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _vouchers = [];

  @override
  void initState() {
    super.initState();
    _fetchVouchers();
  }

  Future<void> _fetchVouchers() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final url = ApiEndpoints.vouchers;
      debugPrint('[VoucherPage] 🚀 Fetching Vouchers: $url');

      final res = await http.get(Uri.parse(url), headers: headers);
      debugPrint('[VoucherPage] 📥 Status Code: ${res.statusCode}');
      debugPrint('[VoucherPage] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final list = decoded['data'] as List? ?? [];
        debugPrint('[VoucherPage] ✅ Parsed ${list.length} vouchers');
        if (mounted) {
          setState(() {
            _vouchers = list.map((e) => e as Map<String, dynamic>).toList();
            _isLoading = false;
          });
        }
      } else {
        debugPrint('[VoucherPage] ❌ Failed to fetch vouchers (${res.statusCode})');
        if (mounted) {
          setState(() {
            _errorMessage = 'Gagal mengambil data voucher (${res.statusCode})';
            _isLoading = false;
          });
        }
      }
    } catch (e, stack) {
      debugPrint('[VoucherPage] 🚨 Exception: $e');
      debugPrint('[VoucherPage] 🚨 StackTrace: $stack');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter aktif & riwayat (kadaluarsa / terpakai)
    final activeVouchers = _vouchers.where((v) {
      final isExpired = v['is_expired'] == true;
      final status = v['status']?.toString().toLowerCase() ?? '';
      return !isExpired && status == 'unused';
    }).toList();

    final historyVouchers = _vouchers.where((v) {
      final isExpired = v['is_expired'] == true;
      final status = v['status']?.toString().toLowerCase() ?? '';
      return isExpired || status != 'unused';
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.base5,
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.base1),
            ),
            Text(
              'Voucher Saya',
              style: AppTextStyles.heading2SemiBold(AppColors.base1),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const CmpTagAttention(
            text:
                'Gunakan kode voucher untuk mendapatkan manfaat potongan harga, konsultasi gratis, atau periode akses premium!',
            imageAsset: 'assets/svg/ic_warn.svg',
            imageColor: AppColors.primary1,
            lineColor: AppColors.primary1,
            space: 10,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary1),
                  )
                : _errorMessage != null
                    ? _buildErrorView()
                    : FullWidthTabBar(
                        tabs: const ['Aktif', 'Riwayat'],
                        tabViews: [
                          _VoucherListView(
                            vouchers: activeVouchers,
                            onRefresh: _fetchVouchers,
                            emptyMessage: 'Belum ada voucher aktif yang tersedia',
                          ),
                          _VoucherListView(
                            vouchers: historyVouchers,
                            onRefresh: _fetchVouchers,
                            emptyMessage: 'Belum ada riwayat voucher',
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            style: AppTextStyles.list1Regular(AppColors.warn1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _fetchVouchers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary1,
              foregroundColor: AppColors.base1,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
//  _VoucherListView — List view pembungkus kartu voucher
// ===========================================================================
class _VoucherListView extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers;
  final Future<void> Function() onRefresh;
  final String emptyMessage;

  const _VoucherListView({
    required this.vouchers,
    required this.onRefresh,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary1,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/ic_coupon - ticket.svg',
                    width: 48,
                    height: 48,
                    colorFilter: const ColorFilter.mode(
                        AppColors.base3, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    emptyMessage,
                    style: AppTextStyles.list1Regular(AppColors.base2),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary1,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final data = vouchers[index];
          return _VoucherCardItem(data: data);
        },
      ),
    );
  }
}

// ===========================================================================
//  _VoucherCardItem — Kartu item voucher tunggal
// ===========================================================================
class _VoucherCardItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const _VoucherCardItem({required this.data});

  void _showDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VoucherDetailSheet(uuid: data['uuid']?.toString() ?? ''),
    );
  }

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode voucher "$code" telah disalin!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = data['code']?.toString() ?? '-';
    final name = data['name']?.toString() ?? 'Voucher';
    final description = data['description']?.toString() ?? '';
    final type = data['type']?.toString() ?? '';
    final value = (data['value'] as num?)?.toInt() ?? 0;
    final durationDays = (data['duration_days'] as num?)?.toInt();
    final expiredAt = data['expired_at']?.toString() ?? '';
    final isExpired = data['is_expired'] == true;
    final status = data['status']?.toString().toLowerCase() ?? 'unused';

    final bool isInactive = isExpired || status != 'unused';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlobalsCard(
        backgroundColor: isInactive ? AppColors.base4 : AppColors.base5,
        padding: const EdgeInsets.all(16),
        border: Border.all(
          color: isInactive ? AppColors.base3 : AppColors.primary1,
          width: 1.5,
        ),
        onTap: () => _showDetailBottomSheet(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Baris Atas: Badge Tipe & Status ────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTypeBadge(type),
                _buildStatusBadge(status, isExpired),
              ],
            ),
            const SizedBox(height: 10),

            // ── Nama Voucher ──────────────────────────────────────────
            Text(
              name,
              style: AppTextStyles.heading3SemiBold(
                  isInactive ? AppColors.base2 : AppColors.base1),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.list1Regular(AppColors.base2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),

            // ── Info Nilai / Durasi ──────────────────────────────────
            if (value > 0 || (durationDays != null && durationDays > 0)) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isInactive ? AppColors.base3 : AppColors.primary3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer,
                      size: 14,
                      color: isInactive ? AppColors.base2 : AppColors.primary1,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getValueText(value, durationDays),
                      style: AppTextStyles.list3Bold(
                          isInactive ? AppColors.base2 : AppColors.primary1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            const Divider(height: 1, color: AppColors.base3),
            const SizedBox(height: 10),

            // ── Baris Bawah: Kode + Tombol Salin + Tanggal Expire ──────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tanggal expired
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: AppColors.base2),
                    const SizedBox(width: 4),
                    Text(
                      _formatExpireDate(expiredAt),
                      style: AppTextStyles.list3Regular(AppColors.base2),
                    ),
                  ],
                ),

                // Tombol Salin Kode
                InkWell(
                  onTap: () => _copyCode(context, code),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary3,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          code,
                          style: AppTextStyles.list3Bold(AppColors.secondary1),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.copy,
                          size: 13,
                          color: AppColors.secondary1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    String label;
    Color color;
    switch (type.toLowerCase()) {
      case 'consultation_purchased':
        label = 'Konsultasi';
        color = AppColors.secondary1;
        break;
      case 'premium_access':
        label = 'Akses Premium';
        color = AppColors.primary1;
        break;
      case 'consultation_gift':
        label = 'Gift Konsultasi';
        color = AppColors.info1;
        break;
      default:
        label = 'Voucher';
        color = AppColors.base2;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.list3SemiBold(color),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isExpired) {
    String label;
    Color bg;
    Color text;

    if (isExpired) {
      label = 'Kadaluarsa';
      bg = AppColors.warn3;
      text = AppColors.warn4;
    } else if (status == 'used') {
      label = 'Terpakai';
      bg = AppColors.base3;
      text = AppColors.base1;
    } else {
      label = 'Tersedia';
      bg = AppColors.primary3;
      text = AppColors.primary1;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.list3Bold(text),
      ),
    );
  }

  String _getValueText(int value, int? durationDays) {
    if (value > 0) {
      final currency = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return 'Potongan ${currency.format(value)}';
    }
    if (durationDays != null && durationDays > 0) {
      return 'Gratis Akses $durationDays Hari';
    }
    return 'Voucher Spesial';
  }

  String _formatExpireDate(String raw) {
    if (raw.isEmpty) return 'Tidak ada batasan';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return 's/d ${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return 's/d $raw';
    }
  }
}

// ===========================================================================
//  _VoucherDetailSheet — Bottom Sheet Detail Voucher (API /api/v1/vouchers/{uuid})
// ===========================================================================
class _VoucherDetailSheet extends StatefulWidget {
  final String uuid;

  const _VoucherDetailSheet({required this.uuid});

  @override
  State<_VoucherDetailSheet> createState() => _VoucherDetailSheetState();
}

class _VoucherDetailSheetState extends State<_VoucherDetailSheet> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _detail;

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

      final url = ApiEndpoints.voucherDetail(widget.uuid);
      debugPrint('[VoucherDetailSheet] 🚀 Fetching Voucher Detail: $url');

      final res = await http.get(Uri.parse(url), headers: headers);
      debugPrint('[VoucherDetailSheet] 📥 Status Code: ${res.statusCode}');
      debugPrint('[VoucherDetailSheet] 📥 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _detail = decoded['data'] as Map<String, dynamic>?;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'Gagal mengambil detail (${res.statusCode})';
            _isLoading = false;
          });
        }
      }
    } catch (e, stack) {
      debugPrint('[VoucherDetailSheet] 🚨 Exception: $e');
      debugPrint('[VoucherDetailSheet] 🚨 StackTrace: $stack');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kode voucher "$code" berhasil disalin!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle pill
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.base3,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary1),
              ),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(_error!,
                    style: AppTextStyles.list1Regular(AppColors.warn1)),
              ),
            )
          else ...[
            Text('Detail Voucher',
                style: AppTextStyles.heading2SemiBold(AppColors.base1)),
            const SizedBox(height: 12),

            // Item detail
            _buildDetailRow('Nama Voucher', _detail?['name']?.toString() ?? '-'),
            _buildDetailRow('Kode Voucher', _detail?['code']?.toString() ?? '-'),
            _buildDetailRow('Tipe', _detail?['type']?.toString() ?? '-'),
            _buildDetailRow(
                'Deskripsi', _detail?['description']?.toString() ?? '-'),
            _buildDetailRow(
                'Masa Berlaku', _detail?['expired_at']?.toString() ?? '-'),
            _buildDetailRow(
                'Status',
                _detail?['is_expired'] == true
                    ? 'Kadaluarsa'
                    : (_detail?['status']?.toString() ?? 'Unused')),

            const SizedBox(height: 20),

            // Tombol Salin Kode
            if (_detail?['code'] != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _copyCode(_detail!['code'].toString()),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Salin Kode Voucher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary1,
                    foregroundColor: AppColors.base1,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTextStyles.list1Regular(AppColors.base2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.list1Bold(AppColors.base1),
            ),
          ),
        ],
      ),
    );
  }
}
