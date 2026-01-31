// 1️⃣ Enum penanda jenis tooltip
import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../text/text_style.dart';
import 'info_tooltip_icon.dart';

enum TooltipStep { awal, pertama, pasti, hebat, lengkap }

class _TooltipData {
  final String asset; // path gambar/icon
  final String bold; // teks tebal (descTooltip1)
  final String regular; // teks biasa (descTooltip2)

  const _TooltipData({
    required this.asset,
    required this.bold,
    required this.regular,
  });
}

// 3️⃣ Master-map ► tinggal update di sini kalau ada revisi copy/icon
const Map<TooltipStep, _TooltipData> _tooltips = {
  TooltipStep.awal: _TooltipData(
    asset: 'assets/svg/ic_ foot - langkah awal.svg',
    bold: 'Paket gratis',
    regular:
        'dengan fitur dasar, akses ke 1 meal plan, pantauan kalori, dan akses '
        'konten edukasi. Ideal untuk coba-coba dulu.',
  ),
  TooltipStep.pertama: _TooltipData(
    asset: 'assets/svg/ic_ plant - langkah pertama.svg',
    bold: 'Paket bulanan',
    regular:
        'untuk mulai rutinitas sehat anak. Dapat semua meal plan dan 1× konsultasi '
        'ahli gizi pilihan Sporky Maxi.',
  ),
  TooltipStep.pasti: _TooltipData(
    asset: 'assets/svg/ic_ shield - langkah pasti.svg',
    bold: 'Lebih hemat dari langganan bulanan.',
    regular:
        'Dapat 3x konsultasi dan edukasi premium untuk bantu optimalkan tumbuh '
        'kembang anak.',
  ),
  TooltipStep.hebat: _TooltipData(
    asset: 'assets/svg/ic_ rocket.svg',
    bold: 'Dapat fitur lengkap',
    regular:
        'dan 6 bulan pendampingan intensif. Termasuk 1× Zoom dengan dokter gizi '
        'pilihan Sporky Maxi.',
  ),
  TooltipStep.lengkap: _TooltipData(
    asset: 'assets/svg/sun.svg',
    bold: 'Paket tahunan paling lengkap!',
    regular:
        'Konsultasi rutin, bonus edukasi, dan akses ke para expert untuk dukung '
        'tumbuh kembang maksimal.',
  ),
};

extension TooltipStepExt on TooltipStep {
  String get asset => _tooltips[this]!.asset;
}

// 4️⃣ Widget utama – tinggal pakai
class BadgeTooltip extends StatelessWidget {
  final TooltipStep step;
  final double imageSize;
  final bool useImageTrigger;
  final double stepIconSize;

  const BadgeTooltip(
    this.step, {
    super.key,
    this.imageSize = 56,
    this.useImageTrigger = true,
    this.stepIconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final data = _tooltips[step]!;

    return InfoTooltipIcon(
      image: data.asset,
      imageSize: imageSize,
      useImageTrigger: useImageTrigger,
      stepIconSize: stepIconSize,
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${data.bold} ',
                  style: AppTextStyles.list1Bold(AppColors.base1),
                ),
                TextSpan(
                  text: data.regular,
                  style: AppTextStyles.list1Regular(AppColors.base1),
                ),
              ],
            ),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
