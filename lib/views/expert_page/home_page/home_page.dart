import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/home_page/page_agenda_consultations.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../../components/expert_components/schedule/shedule_cmp.dart';
import '../../../components/globals/card/card_agenda_cmp.dart';
import '../../profile/page_setting_profile/page_setting_expert/page_setting_expert_profile.dart';
// import 'package:sporky_maxi/components/globals/card/globals_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _expertName = 'Dokter';

  @override
  void initState() {
    super.initState();
    _loadExpertName();
  }

  Future<void> _loadExpertName() async {
    final name = await SecureStorageService.getUserName();
    if (!mounted) return;
    setState(() {
      _expertName = (name == null || name.trim().isEmpty) ? 'Dokter' : name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: TopBarExpertCmp(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageSettingExpertProfile(),
                  ));
            },
            name: _expertName,
            title: 'Ahli Gizi, Spesialis Rehabilitas Nutrisi'),
      ),
      body: Column(
        children: [
          SheduleCmp(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/user-doctor.svg',
                      colorFilter:
                          ColorFilter.mode(AppColors.base1, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Agenda Hari ini',
                      style: AppTextStyles.heading3SemiBold(),
                    )
                  ],
                ),
                GlobalsCard(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(5),
                    hasShadow: false,
                    backgroundColor: AppColors.base4,
                    child: Text(
                      '2/5 Sesi Tersisa',
                      style: AppTextStyles.list1Bold(AppColors.base3),
                    ))
              ],
            ),
          ),
          CardAgendaCmp(
            isOnline: true,
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.video,
          ),
          CardAgendaCmp(
            isScheduled: true,
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.chat,
          ),
          CardAgendaCmp(
            nameChild: 'alicia',
            nameParrent: 'azzahra',
            chat:
                'Anak saya susah makan sayur, bahkan saat disajikan dalam bentuk menarik. Saya khawatir asupan nutrisinya jadi kurang',
            category: AgendaCategory.video,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageAgendaConsultations(),
                    ));
              },
              child: Text(
                'lihat semua agenda',
                style: AppTextStyles.list1Regular(
                    AppColors.secondary1, TextDecoration.underline),
              ))
        ],
      ),
    );
  }
}
