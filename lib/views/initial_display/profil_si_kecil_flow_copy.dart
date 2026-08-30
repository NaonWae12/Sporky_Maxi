// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';
import '../../components/globals/constants/api_endpoints.dart';
import '../../components/globals/dialog/dialog_alert.dart';
import '../../components/initial_display/profil_si_kecil/data_dasar_page.dart';
import '../../components/initial_display/profil_si_kecil/kegiatan_anak.dart';
import '../../components/initial_display/profil_si_kecil/makanan_page.dart';
import '../../components/initial_display/profil_si_kecil/riwayat_kesehatan_page.dart';
import '../../core/utils/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ProfilSiKecilFlow extends StatefulWidget {
  const ProfilSiKecilFlow({super.key});

  @override
  State<ProfilSiKecilFlow> createState() => _ProfilSiKecilFlowState();
}

class _ProfilSiKecilFlowState extends State<ProfilSiKecilFlow> {
  final data = {
    "childId": "",
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

  String mapGender(String? value) {
    if (value == "Laki-laki") return "L";
    if (value == "Perempuan") return "P";
    return "";
  }

  Future<void> submitData() async {
    debugPrint("🚀 submitData() kepanggil...");
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        debugPrint("Token tidak ditemukan");
        return;
      }

      final url = Uri.parse(ApiEndpoints.screeningChildProfile);

      // mapping ke format API
      final payload = {
        "child_id": data["childId"] ?? "",
        "child": {
          "name": data["nama"],
          "gender": mapGender(data["jenisKelamin"]),
          "dob": () {
            try {
              final parsed = DateFormat(
                "dd/MM/yyyy",
              ).parse(data["tanggalLahir"] ?? "");
              return DateFormat("yyyy-MM-dd").format(parsed);
            } catch (_) {
              return "";
            }
          }(),
          "height": double.tryParse(data["tinggi"] ?? "0") ?? 0,
          "weight": double.tryParse(data["berat"] ?? "0") ?? 0,
        },
        "activity_id": int.tryParse(data["kegiatanAnak"] ?? "0") ?? 0,
        "medical_histories": data["riwayatPenyakitAnak"]
            ?.split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        "allergies": data["alergiAnak"]
            ?.split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        "favorite_foods": data["makananFavorit"]
            ?.split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        "foods_avoided": data["makananDihindari"]
            ?.split(",")
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      };

      debugPrint("📦 Payload: ${jsonEncode(payload)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode(payload),
      );

      debugPrint("📡 Status Code: ${response.statusCode}");
      debugPrint("📡 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        DialogAlert.show(
          context: context,
          customChild: Content1(
            title: 'Data Anak Tersimpan!',
            message:
                'Data si kecil berhasil dicatat. Informasi ini akan membantu rekomendasi nutrisi lebih tepat.',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Navbar()),
              );
            },
            textNav: 'Akses Beranda',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal simpan data: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error submit data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    }
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
        onFinish: submitData, // ✅ langsung submit
        onBack: previousStep,
        progressValue: progressValue,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('Profil si kecil', style: AppTextStyles.heading1SemiBold()),
      ),
      body: pages[currentStep],
    );
  }
}
