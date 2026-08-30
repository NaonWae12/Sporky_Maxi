import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/consultation/chat_room_service.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';
import 'package:sporky_maxi/views/chatroom/chating_page_parent.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationTicketSessionLauncher {
  const ConsultationTicketSessionLauncher._();

  static const ChatRoomService _chatRoomService = ChatRoomService();

  static bool canOpenSession(AppTransaction transaction) {
    if (!transaction.isCompleted) return false;

    final consultationStatus =
        transaction.consultation?.status.toLowerCase().trim() ?? '';
    return consultationStatus != 'completed' &&
        consultationStatus != 'cancelled';
  }

  static String actionLabel(AppTransaction transaction) {
    if (!canOpenSession(transaction)) return 'Lihat Detail';

    final type = transaction.consultationType.toLowerCase().trim();
    if (type == 'zoom') return 'Join Zoom';
    return 'Masuk Chat';
  }

  static Future<void> openSession(
    BuildContext context,
    AppTransaction transaction,
  ) async {
    if (!transaction.isCompleted) {
      _showMessage(context, 'Pembayaran belum selesai.');
      return;
    }

    final consultationStatus =
        transaction.consultation?.status.toLowerCase().trim() ?? '';
    if (consultationStatus == 'completed') {
      _showMessage(context, 'Sesi konsultasi sudah selesai.');
      return;
    }
    if (consultationStatus == 'cancelled') {
      _showMessage(context, 'Sesi konsultasi dibatalkan.');
      return;
    }

    final type = transaction.consultationType.toLowerCase().trim();
    if (type == 'zoom') {
      await _openZoom(context, transaction);
      return;
    }

    await _openChat(context, transaction);
  }

  static Future<void> _openZoom(
    BuildContext context,
    AppTransaction transaction,
  ) async {
    final zoomLink = transaction.zoomLink?.trim() ?? '';
    final uri = Uri.tryParse(zoomLink);

    if (uri == null || zoomLink.isEmpty || !uri.hasScheme) {
      _showMessage(context, 'Link Zoom belum tersedia.');
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;

    if (!opened) {
      _showMessage(context, 'Tidak bisa membuka link Zoom.');
    }
  }

  static Future<void> _openChat(
    BuildContext context,
    AppTransaction transaction,
  ) async {
    final existingRoomUuid = transaction.chatRoomUuid?.trim() ?? '';
    final doctorName = transaction.expert?.name.trim().isNotEmpty == true
        ? transaction.expert!.name.trim()
        : 'Dokter Sporky';

    if (existingRoomUuid.isNotEmpty) {
      _pushChat(context, roomUuid: existingRoomUuid, doctorName: doctorName);
      return;
    }

    final expertUserUuid = transaction.expert?.userUuid.trim() ?? '';
    if (expertUserUuid.isEmpty) {
      _showMessage(context, 'Data expert untuk chat belum lengkap.');
      return;
    }

    final childUuid =
        (transaction.child?.uuid.trim().isNotEmpty == true
                ? transaction.child!.uuid
                : await SecureStorageService.getSelectedChildUuid())
            ?.trim();

    if (!context.mounted) return;

    if (childUuid == null || childUuid.isEmpty) {
      _showMessage(context, 'Pilih profil anak terlebih dahulu.');
      return;
    }

    try {
      final room = await _chatRoomService.getOrCreateConsultationRoom(
        expertUserUuid: expertUserUuid,
        childUuid: childUuid,
      );

      if (!context.mounted) return;
      _pushChat(
        context,
        roomUuid: room.uuid,
        doctorName: room.expertName.isEmpty ? doctorName : room.expertName,
      );
    } catch (error) {
      if (!context.mounted) return;
      _showMessage(context, 'Gagal membuka chat: $error');
    }
  }

  static void _pushChat(
    BuildContext context, {
    required String roomUuid,
    required String doctorName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatingPageParent(roomUuid: roomUuid, doctorName: doctorName),
      ),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
