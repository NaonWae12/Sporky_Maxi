import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../../components/expert_components/dashboard_cmp/balance_card_cmp.dart';
import '../../../components/expert_components/dashboard_cmp/insight_consultation_cmp.dart';
import '../../../components/globals/bar/top_bar/top_bar_expert_cmp.dart';
import 'transaction/page_transaction_history.dart';

class DashboardExpertPage extends StatefulWidget {
  const DashboardExpertPage({super.key});

  @override
  State<DashboardExpertPage> createState() => _DashboardExpertPageState();
}

class _DashboardExpertPageState extends State<DashboardExpertPage> {
  String _expertName = 'Dokter';
  String? _expertPhoto;
  int _totalBalance = 0;
  String _balancePeriod = '-';
  int _totalConsultations = 0;

  @override
  void initState() {
    super.initState();
    _loadExpertProfileCache();
    _loadExpertBalance();
  }

  Future<void> _loadExpertProfileCache() async {
    final name = await SecureStorageService.getUserName();
    final photo = await SecureStorageService.getUserPhoto();
    if (!mounted) return;
    setState(() {
      _expertName = (name == null || name.trim().isEmpty) ? 'Dokter' : name;
      _expertPhoto = photo;
    });
  }

  Future<void> _loadExpertBalance() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.expertMyBalance),
        headers: {'Authorization': token, 'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[DashboardExpertPage] Balance request failed: ${response.statusCode}',
        );
        return;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) return;

      final totalBalanceRaw = data['total_balance'];
      final totalConsultationsRaw = data['total_consultations'];
      final periodRaw = data['period'];

      final parsedTotalBalance = totalBalanceRaw is int
          ? totalBalanceRaw
          : int.tryParse(totalBalanceRaw?.toString() ?? '') ?? 0;

      final parsedTotalConsultations = totalConsultationsRaw is int
          ? totalConsultationsRaw
          : int.tryParse(totalConsultationsRaw?.toString() ?? '') ?? 0;

      final parsedPeriod = (periodRaw?.toString() ?? '').trim();

      if (!mounted) return;
      setState(() {
        _totalBalance = parsedTotalBalance;
        _totalConsultations = parsedTotalConsultations;
        _balancePeriod = parsedPeriod.isEmpty ? '-' : parsedPeriod;
      });
    } catch (e) {
      debugPrint('[DashboardExpertPage] Error load balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: TopBarExpertCmp(
          name: _expertName,
          photoUrl: _expertPhoto,
          title: 'Ahli Gizi, Spesialis Rehabilitas Nutrisi',
        ),
      ),
      body: Column(
        children: [
          BalanceCardCmp(
            balance: _totalBalance,
            balanceCollected: _totalBalance,
            period: _balancePeriod,
            totalConsultations: _totalConsultations,
            onTapHistory: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageTransactionHistory(),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          InsightConsultationCmp(),
        ],
      ),
    );
  }
}
