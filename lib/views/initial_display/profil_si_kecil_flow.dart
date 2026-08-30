import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';
import '../../components/globals/dialog/dialog_alert.dart';
import '../../components/initial_display/profil_si_kecil/data_dasar_page.dart';
import '../../components/initial_display/profil_si_kecil/kegiatan_anak.dart';
import '../../components/initial_display/profil_si_kecil/makanan_page.dart';
import '../../components/initial_display/profil_si_kecil/riwayat_kesehatan_page.dart';

class ProfilSiKecilFlow extends StatefulWidget {
  const ProfilSiKecilFlow({super.key});

  @override
  State<ProfilSiKecilFlow> createState() => _ProfilSiKecilFlowState();
}

class _ProfilSiKecilFlowState extends State<ProfilSiKecilFlow> {
  // Semua data dikumpulkan di sini
  final data = {
    "nama": "",
    "jenisKelamin": "",
    "tanggalLahir": "",
    "tinggi": "",
    "berat": "",
    "riwayatPenyakitAnak": "",
    "hasDiseaseHistory": "false",
    "alergiAnak": "",
    "hasAllergy": "false",
    "makananFavorit": "",
    "makananDihindari": "",
    "kegiatanAnak": "",
  };

  int currentStep = 0;

  void nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    } else if (currentStep == 3) {
      submitData();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void updateData(String key, String value) {
    data[key] = value;
  }

  void submitData() {
    // Integrasi ke backend
    debugPrint("Data Terkumpul: $data");
    // contoh: await ApiService.submitProfil(data);
    DialogAlert.show(
      context: context,
      customChild: Content1(
        title: 'Data Anak Tersimpan!',
        message:
            'Data si kecil sudah berhasil dicatat. Informasi ini akan membantu kami menyesuaikan saran nutrisi dan rekomendasi yang lebih tepat untuk anak Bunda.',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Navbar()),
          );
        },
        textNav: 'Akses Beranda',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = 4;
    final progressValue = (currentStep + 1) / totalPages;
    final pages = [
      DataDasarPage(
        data: data,
        onUpdate: updateData,
        onNext: nextStep,
        progressValue: progressValue,
      ),
      RiwayatKesehatanPage(
        data: data,
        onUpdate: updateData,
        onNext: nextStep,
        onBack: previousStep,
        progressValue: progressValue,
      ),
      MakananPage(
        data: data,
        onUpdate: updateData,
        onNext: nextStep,
        onBack: previousStep,
        progressValue: progressValue,
      ),
      KegiatanAnak(
        data: data,
        onUpdate: updateData,
        onFinish: submitData,
        onBack: previousStep,
        progressValue: progressValue,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('Profil si kecil', style: AppTextStyles.heading1SemiBold()),
      ),
      body: pages[currentStep],
    );
  }
}
