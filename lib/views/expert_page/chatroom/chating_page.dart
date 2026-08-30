import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_in_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/chat/chat_buble.dart';
import 'package:sporky_maxi/components/globals/chat/chat_input_bar.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_cache_service.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_message_cache_item.dart';
import 'package:sporky_maxi/components/globals/chat_cache/chat_sync_service.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/dialog/dialog_alert.dart';
import 'package:sporky_maxi/components/globals/dialog/dialog_content_cmp/content2.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class ChatingPage extends StatefulWidget {
  final String roomUuid;
  final String parentName;
  final String childName;

  const ChatingPage({
    super.key,
    required this.roomUuid,
    this.parentName = 'Orang Tua',
    this.childName = 'Thalia Amara',
  });

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessageUi> _messages = [];

  Timer? _pollingTimer;
  String? _currentUserUuid;
  final Set<String> _readInFlight = <String>{};
  bool _isLoadingMessages = true;
  bool _isFetchingMessages = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    _currentUserUuid = await SecureStorageService.getUserUuid();
    await _loadCachedMessages();
    await _loadMessages();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _loadMessages(silent: true),
    );
  }

  Future<void> _loadCachedMessages() async {
    if (widget.roomUuid.trim().isEmpty) return;

    final cached = await ChatCacheService.getMessages(widget.roomUuid);
    if (!mounted || cached.isEmpty) return;

    final cachedUi = cached.map(_ChatMessageUi.fromCache).toList()
      ..sort((a, b) {
        final aMillis = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bMillis = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return aMillis.compareTo(bMillis);
      });

    setState(() {
      _messages
        ..clear()
        ..addAll(cachedUi);
      _isLoadingMessages = false;
    });
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (widget.roomUuid.trim().isEmpty || _isFetchingMessages) return;

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token tidak ditemukan. Silakan login ulang'),
          ),
        );
      }
      if (!silent && mounted) {
        setState(() {
          _isLoadingMessages = false;
        });
      }
      return;
    }

    _isFetchingMessages = true;
    if (!silent && mounted) {
      setState(() {
        _isLoadingMessages = true;
      });
    }

    try {
      final fetchedCache = await ChatSyncService.fetchMessages(
        roomUuid: widget.roomUuid,
        currentUserUuid: _currentUserUuid,
        viewerIsExpert: true,
      );

      final fetched = fetchedCache.map(_ChatMessageUi.fromCache).toList()
        ..sort((a, b) {
          final aMillis = a.createdAt?.millisecondsSinceEpoch ?? 0;
          final bMillis = b.createdAt?.millisecondsSinceEpoch ?? 0;
          return aMillis.compareTo(bMillis);
        });

      if (silent && fetched.isEmpty && _messages.isNotEmpty) {
        return;
      }

      if (mounted) {
        setState(() {
          _messages
            ..clear()
            ..addAll(fetched);
        });
      }

      await ChatCacheService.saveMessages(
        widget.roomUuid,
        fetched
            .map((message) => message.toCache(roomUuid: widget.roomUuid))
            .toList(),
      );

      unawaited(_markIncomingMessagesAsRead(fetched, token));
    } catch (e) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      _isFetchingMessages = false;
      if (!silent && mounted) {
        setState(() {
          _isLoadingMessages = false;
        });
      }
    }
  }

  Future<void> _markIncomingMessagesAsRead(
    List<_ChatMessageUi> messages,
    String token,
  ) async {
    final pending = messages
        .where(
          (msg) =>
              !msg.isMe &&
              msg.uuid.isNotEmpty &&
              msg.readAt == null &&
              !_readInFlight.contains(msg.uuid),
        )
        .toList();

    if (pending.isEmpty) return;

    for (final msg in pending) {
      _readInFlight.add(msg.uuid);
    }

    try {
      await Future.wait(
        pending.map(
          (msg) => _markMessageAsRead(token: token, messageUuid: msg.uuid),
        ),
      );
    } finally {
      for (final msg in pending) {
        _readInFlight.remove(msg.uuid);
      }
    }
  }

  Future<void> _markMessageAsRead({
    required String token,
    required String messageUuid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          ApiEndpoints.chatRoomMessageRead(widget.roomUuid, messageUuid),
        ),
        headers: {'Authorization': token, 'Accept': 'application/json'},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('Gagal mark read $messageUuid (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error mark read $messageUuid: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    if (widget.roomUuid.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room UUID tidak ditemukan')),
      );
      return;
    }

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token tidak ditemukan. Silakan login ulang'),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.chatRoomMessages(widget.roomUuid)),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final now = DateTime.now();
        final optimisticMessage = _ChatMessageUi(
          uuid: '',
          message: text,
          time: DateFormat('HH:mm').format(now),
          isMe: true,
          createdAt: now,
          sentAt: null,
          readAt: null,
          status: MessageStatus.sent,
        );

        if (mounted) {
          setState(() {
            _messages.add(optimisticMessage);
          });
        }

        await ChatCacheService.appendMessage(
          widget.roomUuid,
          optimisticMessage.toCache(roomUuid: widget.roomUuid),
        );

        _messageController.clear();
        await _loadMessages(silent: true);
        return;
      }

      String errorMessage = 'Gagal mengirim pesan (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final apiMessage = body['message']?.toString().trim();
        if (apiMessage != null && apiMessage.isNotEmpty) {
          errorMessage = apiMessage;
        }
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _attachFile() {
    debugPrint('Lampiran dibuka');
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            TopBarParentInExpertCmp(
              parentName: widget.parentName,
              childName: widget.childName,
              isActive: true,
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            lineColor: AppColors.base1,
            imageColor: AppColors.base1,
            imageAsset: 'assets/svg/ic_warn.svg',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durasi Chat Tersisa: 10 menit',
                  style: AppTextStyles.list1Bold(),
                ),
                Text(
                  'Diskusikan dengan tenang dan mendalam. Pastikan semua kebutuhan Bunda terpenuhi.',
                  style: AppTextStyles.list1Regular(),
                ),
                const SizedBox(height: 8),
                GlobalsButton(
                  elevation: 0,
                  onPressed: () {
                    DialogAlert.show(
                      context: context,
                      customChild: Content2(
                        title: 'Akhiri Sesi Sekarang?',
                        message:
                            'Pastikan Anda sudah memberikan arahan terbaik sebelum mengakhiri sesi ini.',
                        onPressedLeft: () {
                          Navigator.pop(context);
                        },
                        onPressedRight: () {
                          Navigator.pop(context);
                        },
                        textNavLeft: 'Batal',
                        textNavRight: 'Akhiri Sesi',
                      ),
                    );
                  },
                  height: 24,
                  color: AppColors.warn1,
                  text: 'Akhiri Sesi',
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingMessages && _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text('Belum ada pesan'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return ChatBubble(
                        message: msg.message,
                        time: msg.time,
                        isMe: msg.isMe,
                        status: msg.status,
                      );
                    },
                  ),
          ),
          ChatInputBar(
            controller: _messageController,
            onSend: _sendMessage,
            onAttach: _attachFile,
            enabled: !_isSending,
          ),
        ],
      ),
    );
  }
}

class _ChatMessageUi {
  final String uuid;
  final String message;
  final String time;
  final bool isMe;
  final DateTime? createdAt;
  final DateTime? sentAt;
  final DateTime? readAt;
  final MessageStatus status;

  const _ChatMessageUi({
    required this.uuid,
    required this.message,
    required this.time,
    required this.isMe,
    required this.createdAt,
    required this.sentAt,
    required this.readAt,
    required this.status,
  });

  factory _ChatMessageUi.fromCache(ChatMessageCacheItem item) {
    final createdAt = item.createdAt;
    final time = createdAt == null
        ? '--:--'
        : DateFormat('HH:mm').format(createdAt.toLocal());

    return _ChatMessageUi(
      uuid: item.uuid,
      message: item.message,
      time: time,
      isMe: item.isMe,
      createdAt: item.createdAt,
      sentAt: item.sentAt,
      readAt: item.readAt,
      status: _statusFromString(item.status),
    );
  }

  ChatMessageCacheItem toCache({required String roomUuid}) {
    return ChatMessageCacheItem(
      uuid: uuid,
      roomUuid: roomUuid,
      message: message,
      isMe: isMe,
      createdAt: createdAt,
      sentAt: sentAt,
      readAt: readAt,
      status: _statusToString(status),
    );
  }

  static MessageStatus _statusFromString(String rawStatus) {
    switch (rawStatus.trim().toLowerCase()) {
      case 'read':
        return MessageStatus.read;
      case 'delivered':
        return MessageStatus.delivered;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }

  static String _statusToString(MessageStatus status) {
    switch (status) {
      case MessageStatus.read:
        return 'read';
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.sent:
        return 'sent';
    }
  }
}
