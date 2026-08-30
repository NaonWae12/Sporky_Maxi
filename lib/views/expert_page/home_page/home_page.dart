import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/bar/top_bar/top_bar_expert_cmp.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/home_page/page_agenda_consultations.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../../components/expert_components/schedule/shedule_cmp.dart';
import '../../../components/expert_components/schedule/expert_agenda_list.dart';
import '../../profile/page_setting_profile/page_setting_expert/page_setting_expert_profile.dart';

// import 'package:sporky_maxi/components/globals/card/globals_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _expertName = 'Dokter';
  String? _expertPhoto;
  int _agendaRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    _loadExpertProfileCache();
  }

  Future<void> _loadExpertProfileCache() async {
    final name = await SecureStorageService.getUserName();
    final photo = await SecureStorageService.getUserPhoto();
    if (!mounted) return;
    setState(() {
      _expertName = (name == null || name.trim().isEmpty) ? 'Dokter' : name;
      _expertPhoto = photo;
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
              ),
            ).then((_) => _loadExpertProfileCache());
          },
          name: _expertName,
          photoUrl: _expertPhoto,
          title: 'Ahli Gizi, Spesialis Rehabilitas Nutrisi',
        ),
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
                      colorFilter: ColorFilter.mode(
                        AppColors.base1,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Agenda Hari ini',
                      style: AppTextStyles.heading3SemiBold(),
                    ),
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
                  ),
                ),
              ],
            ),
          ),
          ExpertAgendaList(
            key: ValueKey('expert-agenda-$_agendaRefreshKey'),
            limit: 3,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageAgendaConsultations(),
                ),
              ).then((_) {
                if (mounted) {
                  setState(() {
                    _agendaRefreshKey++;
                  });
                }
              });
            },
            child: Text(
              'lihat semua agenda',
              style: AppTextStyles.list1Regular(
                AppColors.secondary1,
                TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
