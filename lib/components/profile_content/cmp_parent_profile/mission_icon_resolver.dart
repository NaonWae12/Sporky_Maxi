import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

// ============================================================================
//  MissionIconResolver
//  Utility class untuk menentukan icon & warna berdasarkan kategori / judul /
//  deskripsi misi yang diterima dari API.
//
//  Prioritas pencocokan (urutan dari atas ke bawah):
//    1. Check-in harian
//    2. Konsultasi / Dokter
//    3. Formulir / Record
//    4. Pertumbuhan / Info / Update
//    5. Baca / Artikel
//    6. Video / Play
//    7. Meal plan / Makanan
//    8. Fallback deterministik
// ============================================================================
class MissionIconResolver {
  MissionIconResolver._(); // non-instantiable

  // --------------------------------------------------------------------------
  //  Helper: cek apakah salah satu [sources] mengandung salah satu [keywords]
  // --------------------------------------------------------------------------
  static bool _hits(List<String> sources, List<String> keywords) {
    for (final kw in keywords) {
      for (final src in sources) {
        if (src.contains(kw)) return true;
      }
    }
    return false;
  }

  // --------------------------------------------------------------------------
  //  resolveIcon — kembalikan path asset SVG yang sesuai
  // --------------------------------------------------------------------------
  static String resolveIcon(
      String category, String title, String description) {
    final all = [
      category.toLowerCase(),
      title.toLowerCase(),
      description.toLowerCase(),
    ];

    // 1. Check-in harian ─────────────────────────────────────────────────────
    if (_hits(all, ['check-in', 'check in', 'checkin', 'daily check'])) {
      return 'assets/svg/ic_list.svg';
    }

    // 2. Konsultasi / Dokter ─────────────────────────────────────────────────
    if (_hits(all, [
      'konsultasi', 'consult', 'dokter', 'doctor',
      'ahli gizi', 'nutritionist', 'expert team', 'ahli',
    ])) {
      return 'assets/svg/ic_ doctor.svg';
    }

    // 3. Formulir / Record / Isi data ────────────────────────────────────────
    if (_hits(all, [
      'form', 'formulir', 'isi form', 'record',
      'lengkapi profil', 'update profil', 'input data',
    ])) {
      return 'assets/svg/medical_record.svg';
    }

    // 4. Pertumbuhan / Perkembangan / Update / Peningkatan ───────────────────
    if (_hits(all, [
      'tumbuh', 'kembang', 'growth', 'perkembangan', 'pertumbuhan',
      'update tumbuh', 'peningkatan', 'tinggi', 'berat', 'bmi',
      'informasi', 'info', 'meningkat', 'naik',
    ])) {
      return 'assets/svg/ic_ growth.svg';
    }

    // 5. Baca / Artikel ──────────────────────────────────────────────────────
    if (_hits(all, ['baca', 'read', 'artikel', 'article'])) {
      return 'assets/svg/ic_ read - book.svg';
    }

    // 6. Video / Play / Nonton ───────────────────────────────────────────────
    if (_hits(all, ['play', 'video', 'nonton', 'watch', 'tonton'])) {
      return 'assets/svg/ic_ play.svg';
    }

    // 7. Meal plan / Makanan / Minuman ───────────────────────────────────────
    if (_hits(all, [
      'meal', 'mealplan', 'makan', 'food', 'intake',
      'snack', 'sarapan', 'breakfast', 'lunch', 'dinner',
      'minuman', 'drink', 'nutrisi', 'gizi',
    ])) {
      return 'assets/svg/bento-box-rounded.svg';
    }

    // 8. Fallback — pilih deterministik berdasarkan hash ikon ────────────────
    const fallbacks = [
      'assets/svg/ic_ growth.svg',
      'assets/svg/ic_increase.svg',
      'assets/svg/ic_ calendar - schedule.svg',
      'assets/svg/ic_ plant - langkah pertama.svg',
    ];
    final hash = category.hashCode ^ title.hashCode;
    return fallbacks[hash.abs() % fallbacks.length];
  }

  // --------------------------------------------------------------------------
  //  resolveColor — kembalikan warna ikon berdasarkan asset yang sudah
  //  dipilih oleh [resolveIcon]
  // --------------------------------------------------------------------------
  static Color resolveColor(
      String iconAsset, String category, String title, String description) {
    // Meal plan — warna berbeda per sesi makan
    if (iconAsset == 'assets/svg/bento-box-rounded.svg') {
      return _mealColor(category, title, description);
    }

    // Peta ikon → warna
    const iconColorMap = <String, Color>{
      'assets/svg/ic_list.svg'                      : AppColors.primary1,   // kuning (check-in)
      'assets/svg/ic_ doctor.svg'                   : AppColors.secondary1, // navy (konsultasi)
      'assets/svg/medical_record.svg'               : AppColors.info1,      // biru terang (form)
      'assets/svg/ic_ growth.svg'                   : AppColors.success2,   // hijau (pertumbuhan)
      'assets/svg/ic_increase.svg'                  : AppColors.success2,   // hijau (peningkatan)
      'assets/svg/ic_ read - book.svg'              : AppColors.secondary2, // biru lembut (baca)
      'assets/svg/ic_ play.svg'                     : AppColors.warn1,      // merah muda (video)
      'assets/svg/ic_ calendar - schedule.svg'      : AppColors.primary1,   // kuning
      'assets/svg/ic_ plant - langkah pertama.svg'  : AppColors.success2,   // hijau
    };

    return iconColorMap[iconAsset] ?? AppColors.primary1;
  }

  // --------------------------------------------------------------------------
  //  _mealColor — warna spesifik untuk ikon bento berdasarkan sesi makan
  // --------------------------------------------------------------------------
  static Color _mealColor(
      String category, String title, String description) {
    final all = [
      category.toLowerCase(),
      title.toLowerCase(),
      description.toLowerCase(),
    ];

    if (_hits(all, ['makan pagi', 'sarapan', 'breakfast'])) {
      return AppColors.primary1; // kuning — pagi
    }
    if (_hits(all, ['makan siang', 'siang', 'lunch'])) {
      return AppColors.warn1; // merah muda — siang
    }
    if (_hits(all, ['makan malam', 'malam', 'dinner'])) {
      return AppColors.secondary1; // navy — malam
    }
    if (_hits(all, ['snack'])) {
      return AppColors.info1; // biru terang — snack
    }

    return AppColors.primary1; // default kuning
  }
}
