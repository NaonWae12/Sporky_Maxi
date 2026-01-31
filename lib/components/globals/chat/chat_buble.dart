import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

enum MessageStatus {
  sent, // ✔ satu
  delivered, // ✔✔ abu
  read, // ✔✔ kuning
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final MessageStatus status;
  final Color? color;
  final double maxWidthFactor;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    this.isMe = false,
    this.status = MessageStatus.sent,
    this.color,
    this.maxWidthFactor = 0.7,
  });

  Icon _buildStatusIcon() {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.grey);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: AppColors.primary1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Bubble pesan
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * maxWidthFactor,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: color ?? (isMe ? AppColors.secondary3 : AppColors.base4),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ),

          // Info waktu & status di bawah bubble
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
