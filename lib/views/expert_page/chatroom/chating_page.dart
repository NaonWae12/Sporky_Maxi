import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/chat/chat_buble.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_parent_in_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/dialog_content_cmp/content2.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../../components/globals/chat/chat_input_bar.dart';
import 'package:intl/intl.dart';

import '../../../components/globals/dialog/dialog_alert.dart'; // pastikan tambahin intl di pubspec.yaml

class ChatingPage extends StatefulWidget {
  const ChatingPage({super.key});

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final TextEditingController _messageController = TextEditingController();

  // List untuk menampung chat
  final List<Map<String, dynamic>> _messages = [
    {
      "message": "Halo bre 👋",
      "time": "09:45",
      "isMe": false,
    },
    {
      "message": "Yo bre! Lagi ngapain nih?",
      "time": "09:46",
      "isMe": true,
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);

    setState(() {
      _messages.add({
        "message": text,
        "time": formattedTime,
        "isMe": true,
      });
    });

    _messageController.clear();
  }

  void _attachFile() {
    debugPrint("Lampiran dibuka");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            TopBarParentInExpertCmp(
              parentName: 'Alicia Azzahra',
              childName: 'Thalia Amara',
              isActive: true,
              isAsset: true,
              photoUrl: 'assets/temp_img/parent.png',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tag informasi di atas chat
          CmpTagAttention(
            lineColor: AppColors.base1,
            imageColor: AppColors.base1,
            imageAsset: 'assets/svg/ic_warn.svg',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Durasi Chat Tersisa: 10 menit',
                    style: AppTextStyles.list1Bold()),
                Text(
                  'Diskusikan dengan tenang dan mendalam. Pastikan semua kebutuhan Bunda Thalia terpenuhi.',
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
                )
              ],
            ),
          ),

          // Daftar chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(
                  message: msg["message"],
                  time: msg["time"],
                  isMe: msg["isMe"],
                );
              },
            ),
          ),

          // Input bar di bawah
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
