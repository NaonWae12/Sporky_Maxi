import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/payments/payment_cmp.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/core/services/consultation/chat_room_service.dart';
import 'package:sporky_maxi/core/services/consultation/consultation_service.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';
import 'package:sporky_maxi/views/chatroom/chating_page_parent.dart';
import 'package:sporky_maxi/views/payments/consultation_checkout_webview_page.dart';

class PaymentTicketPage extends StatefulWidget {
  final String? expertId;
  final String? expertUuid;
  final String? doctorName;
  final double? price;
  final String? productUuid;
  final DateTime? consultationDate;

  const PaymentTicketPage({
    super.key,
    this.expertId,
    this.expertUuid,
    this.doctorName,
    this.price,
    this.productUuid,
    this.consultationDate,
  });

  @override
  State<PaymentTicketPage> createState() => _PaymentTicketPageState();
}

class _PaymentTicketPageState extends State<PaymentTicketPage> {
  static const ConsultationService _consultationService = ConsultationService();
  static const ChatRoomService _chatRoomService = ChatRoomService();
  static const ApiFoundationService _foundationService = ApiFoundationService();

  bool _isSubmitting = false;
  String? _selectedPaymentMethod;

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
    VoidCallback? onOk,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => SporkyDialog(
        title: isSuccess ? 'Berhasil' : 'Gagal',
        message: message,
        icon: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: isSuccess
                ? const Color(0xFFEAFBEA)
                : const Color(0xFFFFECE3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSuccess ? Icons.check_rounded : Icons.close_rounded,
            color: isSuccess
                ? const Color(0xFF259945)
                : const Color(0xFFED2326),
            size: 34,
          ),
        ),
        actions: [
          SporkyDialogAction(
            label: 'OK',
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onOk?.call();
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Future<void> _checkoutConsultation() async {
    if (_isSubmitting) return;

    final expertUuid = _expertUuid;
    final productUuid = (widget.productUuid ?? '').trim();

    if (expertUuid.isEmpty) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Data expert tidak ditemukan. Silakan pilih expert lagi.',
      );
      return;
    }

    if (productUuid.isEmpty) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Produk konsultasi belum tersedia untuk expert ini.',
      );
      return;
    }

    final paymentMethod = _selectedPaymentMethod?.trim();
    if (paymentMethod == null || paymentMethod.isEmpty) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Pilih metode pembayaran terlebih dahulu.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final checkout = await _consultationService.checkout(
        expertUuid: expertUuid,
        productUuid: productUuid,
        date:
            widget.consultationDate ??
            DateTime.now().add(const Duration(hours: 1)),
      );

      if (!mounted) return;

      final transactionUuid = await _completeCheckoutWebView(
        checkout.checkoutUrl,
      );

      if (transactionUuid == null) {
        await _showResultDialog(
          isSuccess: false,
          message: 'Checkout dibatalkan.',
        );
        return;
      }

      final transaction = await _waitForCompletedTransaction(transactionUuid);

      if (transaction.status != 'completed') {
        await _showResultDialog(
          isSuccess: false,
          message: 'Pembayaran belum selesai. Status: ${transaction.status}.',
        );
        return;
      }

      await _openChatRoomAfterCompletedTransaction();
    } on ApiClientException catch (error) {
      await _showResultDialog(isSuccess: false, message: error.message);
    } catch (error) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Terjadi kesalahan: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String get _expertUuid {
    final widgetExpertUuid = (widget.expertUuid ?? '').trim();
    if (widgetExpertUuid.isNotEmpty) return widgetExpertUuid;
    return (widget.expertId ?? '').trim();
  }

  Future<String?> _completeCheckoutWebView(String checkoutUrl) async {
    if (!mounted) return null;

    final result = await Navigator.push<ConsultationCheckoutResult>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ConsultationCheckoutWebviewPage(checkoutUrl: checkoutUrl),
      ),
    );

    if (result == null || !result.isCompleted) return null;
    return result.transactionUuid;
  }

  Future<AppTransaction> _waitForCompletedTransaction(String uuid) async {
    const maxAttempts = 10;
    var transaction = await _foundationService.getTransactionDetail(uuid);

    for (
      var attempt = 1;
      attempt < maxAttempts && transaction.status != 'completed';
      attempt++
    ) {
      await Future<void>.delayed(const Duration(seconds: 2));
      transaction = await _foundationService.getTransactionDetail(uuid);
    }

    return transaction;
  }

  Future<void> _openChatRoomAfterCompletedTransaction() async {
    final childUuid = (await SecureStorageService.getSelectedChildUuid() ?? '')
        .trim();

    if (childUuid.isEmpty) {
      await _showResultDialog(
        isSuccess: false,
        message: 'Pembayaran berhasil, tetapi profil anak belum dipilih.',
      );
      return;
    }

    final room = await _chatRoomService.getOrCreateConsultationRoom(
      expertUserUuid: _expertUuid,
      childUuid: childUuid,
    );

    await _showResultDialog(
      isSuccess: true,
      message: 'Pembayaran berhasil. Chat konsultasi sudah siap.',
      onOk: () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatingPageParent(
              roomUuid: room.uuid,
              doctorName: room.expertName,
            ),
          ),
        );
      },
    );
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
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('Pembayar', style: AppTextStyles.heading1SemiBold()),
            ],
          ),
        ),
      ),
      body: PaymentCmp(
        doctorName: (widget.doctorName ?? '').trim().isEmpty
            ? 'Dokter Sporky'
            : widget.doctorName!.trim(),
        specialization: 'Anak',
        price: _priceInThousands(widget.price),
        session: '1',
        isExpertGroup: true,
        paymentMethodLabel: _selectedPaymentMethod ?? 'Pilih metode pembayaran',
        onPaymentMethodSelected: (method) {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        textButton: _isSubmitting ? 'Memproses...' : 'Beli Tiket',
        onPressedButton: _isSubmitting ? null : _checkoutConsultation,
      ),
    );
  }
}
