// tidak digunakan
import 'package:flutter/material.dart';
import 'chat_input_bar.dart';

class StartChating extends StatefulWidget {
  const StartChating({super.key});

  @override
  State<StartChating> createState() => _StartChatingState();
}

class _StartChatingState extends State<StartChating> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    //  logic kirim pesan sesuai role
    debugPrint("Pesan dikirim: $text");
    _messageController.clear();
  }

  void _attachFile() {
    //  logic buka file picker / kamera
    debugPrint("Lampiran dibuka");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Start Chatting"),
      ),
      body: Column(
        children: [
          // area pesan
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text("Belum ada pesan bre 😅"),
            ),
          ),

          // input bar di bawah
          ChatInputBar(
            controller: _messageController,
            onSend: _sendMessage,
            onAttach: _attachFile,
          ),
        ],
      ),
    );
  }
}
