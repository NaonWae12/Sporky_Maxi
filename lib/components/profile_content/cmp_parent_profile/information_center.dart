import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../core/utils/secure_storage_service.dart';
import '../../../views/initial_display/login_page.dart';
import '../../../views/payments/transaction_history.dart';

class InformationCenter extends StatelessWidget {
  const InformationCenter({super.key});
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SecureStorageService.clearAll();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(height: 24, width: 24, 'assets/svg/ic_info.svg'),
              Text('Pusat Informasi',
                  style: AppTextStyles.heading3SemiBold(AppColors.secondary1)),
            ],
          ),
        ),
        ListInformations(
            text: 'Informasi Aplikasi',
            iconAsset: 'assets/svg/ic_warn.svg',
            onTap: () {}),
        ListInformations(
            text: 'Syarat dan Ketentuan',
            iconAsset: 'assets/svg/bitcoin-icons_sign-filled.svg',
            onTap: () {}),
        ListInformations(
            text: 'Riwayat Transaksi',
            iconAsset: 'assets/svg/ic_round-history.svg',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionHistory(),
                  ));
            }),
        GestureDetector(
          onTap: () => _confirmLogout(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/logout.svg'),
                Text(
                  'Keluar',
                  style: AppTextStyles.list1Regular(),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}

class ListInformations extends StatelessWidget {
  final String iconAsset;
  final String text;
  final Color color;
  final VoidCallback? onTap;
  const ListInformations({
    super.key,
    required this.text,
    required this.iconAsset,
    this.color = AppColors.base1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                        height: 16,
                        width: 16,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        iconAsset),
                    const SizedBox(width: 5),
                    Text(
                      text,
                      style: AppTextStyles.list1Regular(),
                    )
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 12)
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 1.05,
              color: AppColors.base3,
            )
          ],
        ),
      ),
    );
  }
}
