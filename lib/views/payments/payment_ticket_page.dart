import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/payments/payment_cmp.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class PaymentTicketPage extends StatefulWidget {
  final String? expertId;
  final String? expertUuid;
  final String? doctorName;
  final double? price;

  const PaymentTicketPage({
    super.key,
    this.expertId,
    this.expertUuid,
    this.doctorName,
    this.price,
  });

  @override
  State<PaymentTicketPage> createState() => _PaymentTicketPageState();
}

class _PaymentTicketPageState extends State<PaymentTicketPage> {
  bool _isSubmitting = false;

  String _priceInThousands(double? amount) {
    if (amount == null || amount <= 0) return '0';
    if (amount >= 1000) {
      final kValue = amount / 1000;
      if (kValue == kValue.roundToDouble()) {
        return kValue.toStringAsFixed(0);
      }
      return kValue.toStringAsFixed(1);
    }
    return amount.toStringAsFixed(0);
  }

  Future<void> _showResultDialog({
    required bool isSuccess,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isSuccess ? 'Berhasil' : 'Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _createChatRoomAfterPayment() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        await _showResultDialog(
          isSuccess: false,
          message: 'Token tidak ditemukan. Silakan login ulang.',
        );
        return;
      }

      final selectedChildUuidRaw =
          await SecureStorageService.getSelectedChildUuid();
      final selectedChildUuid = (selectedChildUuidRaw ?? '').trim();
      final expertIdRaw = (widget.expertId ?? '').trim();
      final expertUserUuidRaw = (widget.expertUuid ?? '').trim();
      final expertUserUuidPayload =
          expertUserUuidRaw.isNotEmpty ? expertUserUuidRaw : expertIdRaw;

      debugPrint('[PaymentTicketPage] expertIdRaw: $expertIdRaw');
      debugPrint('[PaymentTicketPage] expertUserUuidRaw: $expertUserUuidRaw');
      debugPrint(
          '[PaymentTicketPage] expertUserUuidPayload: $expertUserUuidPayload');
      debugPrint('[PaymentTicketPage] selectedChildUuid: $selectedChildUuid');

      if (expertUserUuidPayload.isEmpty) {
        await _showResultDialog(
          isSuccess: false,
          message:
              'Data user expert tidak ditemukan. Silakan pilih expert lagi.',
        );
        return;
      }

      if (selectedChildUuid.isEmpty) {
        await _showResultDialog(
          isSuccess: false,
          message: 'Profil anak belum dipilih. Pilih anak terlebih dahulu.',
        );
        return;
      }

      final payload = <String, dynamic>{
        'user_uuid': expertUserUuidPayload,
        'expert_id': expertUserUuidPayload,
        'expert_uuid': expertUserUuidPayload,
        'child_uuid': selectedChildUuid,
        'room_type': 'konsultasi',
      };

      debugPrint('[PaymentTicketPage] Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(ApiEndpoints.chatRoomGetOrCreate),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      debugPrint('[PaymentTicketPage] Status: ${response.statusCode}');
      debugPrint('[PaymentTicketPage] Response: ${response.body}');

      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        body = {};
        debugPrint('[PaymentTicketPage] Response body is not valid JSON');
      }

      final message = (body['message'] as String?)?.trim().isNotEmpty == true
          ? (body['message'] as String)
          : 'Status: ${response.statusCode}';

      await _showResultDialog(
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        message: message,
      );
    } catch (e) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Terjadi kesalahan: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                'Pembayar',
                style: AppTextStyles.heading1SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: PaymentCmp(
        doctorName: (widget.doctorName ?? '').trim().isEmpty
            ? 'dr.Palomina'
            : widget.doctorName!.trim(),
        specialization: 'Anak',
        price: _priceInThousands(widget.price),
        session: '1',
        isExpertGroup: true,
        textButton: _isSubmitting ? "Memproses..." : "Beli Tiket",
        onPressedButton: _isSubmitting
            ? () {}
            : () {
                _createChatRoomAfterPayment();
              },
      ),
    );
  }
}
