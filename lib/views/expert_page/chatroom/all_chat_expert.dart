import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_cache_service.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_room_cache_item.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_sync_service.dart';
import 'package:sporky_maxi/views/expert_page/chatroom/detail_profile.dart';

import '../../../components/chatroom_cmp/cmp_list_chat.dart';

class AllChatExpert extends StatefulWidget {
  const AllChatExpert({super.key});

  @override
  State<AllChatExpert> createState() => _AllChatExpertState();
}

class _AllChatExpertState extends State<AllChatExpert> {
  static const String _hardcodedMessage =
      'Diskusikan kebutuhan orang tua secara detail untuk hasil konsultasi terbaik.';
  static const String _fallbackParentName = 'Orang Tua';
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
    final cachedRooms = await ChatCacheService.getRooms(scope: 'expert');
    if (!forceRefresh && cachedRooms.isNotEmpty) {
      unawaited(_refreshRoomsInBackground());
      return cachedRooms;
    }

    final freshRooms = await ChatSyncService.fetchRooms(
      roomTypeFilter: 'konsultasi',
      preferParticipantExpertName: false,
    );
    await ChatCacheService.saveRooms(freshRooms, scope: 'expert');
    return freshRooms;
  }

  Future<void> _refreshRoomsInBackground() async {
    try {
      final freshRooms = await ChatSyncService.fetchRooms(
        roomTypeFilter: 'konsultasi',
        preferParticipantExpertName: false,
      );
      await ChatCacheService.saveRooms(freshRooms, scope: 'expert');
      if (!mounted) return;
      setState(() {
        _roomsFuture = Future.value(freshRooms);
      });
    } catch (e) {
      debugPrint('[AllChatExpert] Background refresh error: $e');
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--.--';
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  String _resolveParentName(String rawName) {
    final normalized = rawName.trim();
    if (normalized.isEmpty) return _fallbackParentName;
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatRoomCacheItem>>(
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                ...rooms.map(
                  (room) {
                    final parentName = _resolveParentName(room.displayName);

                    return CmpListChat(
                      name: parentName,
                      message: _hardcodedMessage,
                      time: _formatTime(room.updatedAt),
                      unreadCount: room.unreadCount,
                      isActive: true,
                      photoUrl: _hardcodedPhotoUrl,
                      isAsset: _hardcodedIsAsset,
                      maxLines: 1,
                      onTap: () async {
                        if (room.unreadCount > 0) {
                          final updatedRooms = rooms
                            .map(
                              (item) => item.uuid == room.uuid
                                  ? ChatRoomCacheItem(
                                      uuid: item.uuid,
                                      roomType: item.roomType,
                                      childUuid: item.childUuid,
                                      displayName: item.displayName,
                                      unreadCount: 0,
                                      updatedAt: item.updatedAt,
                                    )
                                  : item,
                              )
                              .toList();

                          setState(() {
                            _roomsFuture = Future.value(updatedRooms);
                          });
                          unawaited(
                            ChatCacheService.saveRooms(
                              updatedRooms,
                              scope: 'expert',
                            ),
                          );
                        }

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProfile(
                              childUuid: room.childUuid,
                              roomUuid: room.uuid,
                              parentName: parentName,
                            ),
                          ),
                        );
                        if (!mounted) return;
                        unawaited(_refreshRoomsInBackground());
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
