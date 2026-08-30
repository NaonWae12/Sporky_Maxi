import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/form/search_input.dart';

import '../../components/consultation_cmp/all_consultation.dart';
import 'ticket_consultation/main_page_ticket_cst.dart';

class MorePageConsultation extends StatefulWidget {
  const MorePageConsultation({super.key});

  @override
  State<MorePageConsultation> createState() => _MorePageConsultationState();
}

class _MorePageConsultationState extends State<MorePageConsultation> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SearchInput(
                onLeadingPressed: () {
                  Navigator.pop(context);
                },
                showLeadingIcon: true,
                controller: searchController,
                hintText: 'nama dokter',
                showHeartIcon: false,
                showChild: true,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPageTicketCst(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/svg/ic_coupon - ticket.svg',
                        height: 26,
                        width: 26,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPageTicketCst(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/svg/ic_ calendar - schedule.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.base1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FullWidthTabBar(
                tabs: const ['Semua', 'Dokter', 'Ahli Gizi'],
                tabViews: const [
                  AllConsultation(),
                  Center(child: Text('Belum ada dokter')),
                  Center(child: Text('Belum ada ahli gizi')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
