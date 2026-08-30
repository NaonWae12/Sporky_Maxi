import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_cache_service.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_room_cache_item.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_sync_service.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/chatroom_cmp/cmp_list_chat.dart';
import '../../../components/globals/button/cmp_floating_button.dart';
import '../../consultation/main_page_consultation.dart';
import '../chating_page_parent.dart';

class AllChat extends StatefulWidget {
  const AllChat({super.key});

  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  static const String _hardcodedName = 'dr. Palomina';
  static const String _hardcodedMessage =
      'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya';
  static const String _hardcodedPhotoUrl = 'assets/temp_img/parent.png';
  static const bool _hardcodedIsAsset = true;

  late Future<List<ChatRoomCacheItem>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms({bool forceRefresh = false}) {
    _roomsFuture = _fetchRooms(forceRefresh: forceRefresh);
  }

  Future<List<ChatRoomCacheItem>> _fetchRooms({
    bool forceRefresh = false,
  }) async {
    final cachedRooms = await ChatCacheService.getRooms(scope: 'parent');
    if (!forceRefresh && cachedRooms.isNotEmpty) {
      unawaited(_refreshRoomsInBackground());
      return cachedRooms;
    }

    final freshRooms = await ChatSyncService.fetchRooms(
      roomTypeFilter: 'konsultasi',
    );
    await ChatCacheService.saveRooms(freshRooms, scope: 'parent');
    return freshRooms;
  }

  Future<void> _refreshRoomsInBackground() async {
    try {
      final freshRooms = await ChatSyncService.fetchRooms(
        roomTypeFilter: 'konsultasi',
      );
      await ChatCacheService.saveRooms(freshRooms, scope: 'parent');
      if (!mounted) return;

      setState(() {
        _roomsFuture = Future<List<ChatRoomCacheItem>>.value(freshRooms);
      });
    } catch (e) {
      debugPrint('[AllChat] Background refresh error: $e');
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--.--';

    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CmpFloatingActionButton(
        imagePath: 'assets/temp_img/parent.png',
      ),
      body: FutureBuilder<List<ChatRoomCacheItem>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => setState(() => _loadRooms(forceRefresh: true)),
                child: const Text('Gagal memuat room chat. Coba lagi'),
              ),
            );
          }

          final rooms = snapshot.data ?? [];
          if (rooms.isEmpty) {
            return const Center(child: Text('Belum ada room chat'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  ...rooms.map(
                    (room) => CmpListChat(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatingPageParent(
                              roomUuid: room.uuid,
                              doctorName: room.displayName.isEmpty
                                  ? _hardcodedName
                                  : room.displayName,
                            ),
                          ),
                        );
                      },
                      name: room.displayName.isEmpty
                          ? _hardcodedName
                          : room.displayName,
                      message: _hardcodedMessage,
                      time: _formatTime(room.updatedAt),
                      unreadCount: room.unreadCount,
                      isActive: true,
                      photoUrl: _hardcodedPhotoUrl,
                      isAsset: _hardcodedIsAsset,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GlobalsButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPageConsultation(),
              ),
            );
          },
          color: AppColors.secondary1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/ic_coupon - ticket.svg'),
              const SizedBox(width: 8),
              Flexible(
                child: GlobalsButtonText(
                  text: 'Beli Tiket Konsultasi',
                  style: AppTextStyles.headList1Bold(AppColors.base5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
