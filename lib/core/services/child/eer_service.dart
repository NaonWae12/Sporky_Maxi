class EERService {
  /// List opsi EER yang ingin dijadikan patokan
  static const List<int> options = [1350, 1400, 1600, 1800, 2000];

  /// Membulatkan nilai EER ke angka terdekat dari daftar options
  static int roundToClosest(double eer) {
    if (options.isEmpty) return eer.toInt();

    // Gunakan reduce untuk cari nilai dengan selisih terkecil
    return options.reduce((a, b) {
      return (eer - a).abs() < (eer - b).abs() ? a : b;
    });
  }
}
