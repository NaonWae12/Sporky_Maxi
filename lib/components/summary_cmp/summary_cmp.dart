import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';

class SummaryCmp extends StatefulWidget {
  const SummaryCmp({super.key, this.apiClient = const ApiClient()});

  final ApiClient apiClient;

  @override
  State<SummaryCmp> createState() => _SummaryCmpFormState();
}

class _SummaryCmpFormState extends State<SummaryCmp> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool _isLoading = false;
  String? _summaryText;
  String? _suggestionText;

  @override
  void initState() {
    super.initState();
    _fetchNarration();
  }

  void _toggleSummary() {
    setState(() {
      isExpanded1 = !isExpanded1;
    });
  }

  void _toggleParentAdvice() {
    setState(() {
      isExpanded2 = !isExpanded2;
    });
  }

  Future<void> _fetchNarration() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final childUuid = await SecureStorageService.getSelectedChildUuid();
      if (childUuid == null || childUuid.isEmpty) return;

      final today = _formatDate(DateTime.now());
      final listUri = Uri.parse(ApiEndpoints.foodWaste).replace(
        queryParameters: {
          'child_uuid': childUuid,
          'date_from': today,
          'date_to': today,
          'per_page': '1',
        },
      );

      final listResponse = await widget.apiClient.get(listUri.toString());
      final listData = ApiParser.map(listResponse['data']);
      final wasteItems = ApiParser.mapList(listData['food_waste']);
      if (wasteItems.isEmpty) return;

      final wasteUuid = ApiParser.string(wasteItems.first['uuid']).trim();
      if (wasteUuid.isEmpty) return;

      final detailResponse = await widget.apiClient.get(
        '${ApiEndpoints.foodWaste}/$wasteUuid',
      );
      final detailData = ApiParser.map(detailResponse['data']);
      final narration = ApiParser.map(detailData['narration']);

      final summary = ApiParser.nullableString(narration['summary']);
      final suggestion = ApiParser.nullableString(narration['suggestion']);

      if (!mounted) return;
      setState(() {
        _summaryText = summary;
        _suggestionText = suggestion;
      });
    } catch (e) {
      debugPrint('[SummaryCmp] failed to load narration: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String get _summaryContent =>
      _summaryText ?? 'Belum ada ringkasan asupan dari API untuk hari ini.';

  String get _suggestionContent =>
      _suggestionText ?? 'Belum ada saran orangtua dari API untuk hari ini.';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeaderCard(
          onTap: _toggleSummary,
          isExpanded: isExpanded1,
          iconAsset: 'assets/svg/ic_ growth.svg',
          iconColor: AppColors.primary1,
          title: 'Ringkasan',
        ),
        if (isExpanded1)
          _buildContentCard(
            child: _isLoading
                ? _buildLoading()
                : _buildScrollableText(_summaryContent),
          ),
        const SizedBox(height: 20),
        _buildHeaderCard(
          onTap: _toggleParentAdvice,
          isExpanded: isExpanded2,
          iconAsset: 'assets/svg/ic_list.svg',
          title: 'Saran Untuk Orangtua',
        ),
        if (isExpanded2)
          _buildContentCard(
            child: _isLoading
                ? _buildLoading()
                : _buildScrollableText(_suggestionContent),
            maxHeight: 190,
          ),
      ],
    );
  }

  Widget _buildHeaderCard({
    required VoidCallback onTap,
    required bool isExpanded,
    required String iconAsset,
    required String title,
    Color? iconColor,
  }) {
    return GlobalsCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: AppColors.base4,
      hasShadow: false,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: isExpanded ? Radius.zero : const Radius.circular(12),
        bottomRight: isExpanded ? Radius.zero : const Radius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  colorFilter: iconColor == null
                      ? null
                      : ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(title, style: AppTextStyles.headList1Regular()),
                ),
              ],
            ),
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({required Widget child, double maxHeight = 170}) {
    return GlobalsCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.base5,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: child,
      ),
    );
  }

  Widget _buildScrollableText(String text) {
    return SingleChildScrollView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(text, style: AppTextStyles.list1Regular()),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
