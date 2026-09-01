import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_chat_parent_with_xprt_cmp.dart';
import 'package:sporky_maxi/components/globals/chat/chat_buble.dart';
import 'package:sporky_maxi/components/globals/chat/chat_input_bar.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/qontak/qontak_mobile_chat_service.dart';

class QontakMobileChatPage extends StatefulWidget {
  const QontakMobileChatPage({super.key});

  @override
  State<QontakMobileChatPage> createState() => _QontakMobileChatPageState();
}

class _QontakMobileChatPageState extends State<QontakMobileChatPage> {
  static const Duration _pollingInterval = Duration(seconds: 4);

  final TextEditingController _messageController = TextEditingController();
  final QontakMobileChatService _service = const QontakMobileChatService();
  final List<QontakMobileChatMessage> _messages = [];
  final Set<String> _messageIds = <String>{};

  Timer? _pollingTimer;
  QontakMobileChatSession? _session;
  bool _isInitialLoading = true;
  bool _isFetchingMessages = false;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await _loadSession();
    await _loadMessages();
    _startPolling();
  }

  Future<void> _loadSession() async {
    try {
      final session = await _service.createSession();
      if (!mounted) return;

      setState(() {
        _session = session;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString().trim().isEmpty
            ? 'Chatbot belum bisa dibuka. Coba lagi beberapa saat.'
            : error.toString().trim();
        _isInitialLoading = false;
      });
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      _pollingInterval,
      (_) => _loadMessages(silent: true),
    );
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (_isFetchingMessages) return;

    setStateIfMounted(() {
      _isFetchingMessages = true;
      if (!silent) {
        _isInitialLoading = true;
        _errorMessage = null;
      }
    });

    try {
      final result = await _service.getMessages();

      if (!mounted) return;
      setState(() {
        _replaceMessages(result.messages);
        _isInitialLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted || silent) return;
      setState(() {
        _isInitialLoading = false;
        _errorMessage = error.toString().trim().isEmpty
            ? 'Gagal memuat pesan. Coba lagi.'
            : error.toString().trim();
      });
    } finally {
      _isFetchingMessages = false;
    }
  }

  Future<void> _retry() async {
    setStateIfMounted(() {
      _errorMessage = null;
      _isInitialLoading = true;
    });

    if (_session == null) {
      await _loadSession();
    }

    await _loadMessages();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setStateIfMounted(() {
      _isSending = true;
    });

    try {
      final message = await _service.sendMessage(text);

      if (!mounted) return;
      setState(() {
        _addMessage(message);
        _messageController.clear();
      });
      await _loadMessages(silent: true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim pesan: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _replaceMessages(List<QontakMobileChatMessage> messages) {
    _messages
      ..clear()
      ..addAll(messages);
    _messageIds
      ..clear()
      ..addAll(messages.map((message) => message.id).where((id) => id != ''));
  }

  void _addMessage(QontakMobileChatMessage message) {
    if (message.id.isNotEmpty && _messageIds.contains(message.id)) {
      final index = _messages.indexWhere(
        (item) => item.id.isNotEmpty && item.id == message.id,
      );
      if (index >= 0) {
        _messages[index] = message;
        return;
      }
    }

    _messages.add(message);
    if (message.id.isNotEmpty) {
      _messageIds.add(message.id);
    }
  }

  void setStateIfMounted(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return DateFormat('HH:mm').format(dateTime.toLocal());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _session?.title ?? 'Chatbot Sporky';
    final description = _session?.description.trim();

    return Scaffold(
      backgroundColor: AppColors.base5,
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
            TopBarChatParentWithXprtCmp(
              doctorName: title,
              childName: 'Asisten',
              isActive: true,
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (description != null && description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: AppTextStyles.list1Regular(AppColors.base2),
                ),
              ),
            ),
          Expanded(
            child: _errorMessage != null
                ? _QontakChatError(message: _errorMessage!, onRetry: _retry)
                : _isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text('Belum ada pesan'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatBubble(
                        message: message.text,
                        time: _formatTime(message.createdAt),
                        isMe: message.isMe,
                      );
                    },
                  ),
          ),
          ChatInputBar(
            controller: _messageController,
            onSend: _sendMessage,
            enabled: !_isSending,
            hintText: 'Tulis pertanyaan untuk chatbot',
          ),
        ],
      ),
    );
  }
}

class _QontakChatError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QontakChatError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
