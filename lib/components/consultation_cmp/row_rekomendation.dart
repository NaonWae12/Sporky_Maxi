import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/card_doctor_cmp.dart';
import 'package:sporky_maxi/components/consultation_cmp/profile_expert.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/core/services/consultation/consultation_service.dart';
import 'package:sporky_maxi/models/components/consultation/expert_model.dart';

import '../../views/consultation/more_page_consultation.dart';

class RowRekomendation extends StatefulWidget {
  const RowRekomendation({super.key});

  @override
  State<RowRekomendation> createState() => _RowRekomendationState();
}

class _RowRekomendationState extends State<RowRekomendation> {
  static const ConsultationService _service = ConsultationService();

  late Future<List<ExpertItem>> _expertsFuture;

  @override
  void initState() {
    super.initState();
    _loadExperts();
  }

  void _loadExperts() {
    _expertsFuture = _service.getExperts(perPage: 10);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpertItem>>(
      future: _expertsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 220,
            child: Center(
              child: TextButton(
                onPressed: () => setState(_loadExperts),
                child: const Text('Gagal memuat rekomendasi. Coba lagi'),
              ),
            ),
          );
        }

        final experts = snapshot.data ?? [];
        if (experts.isEmpty) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text('Belum ada rekomendasi expert')),
          );
        }

        final displayedExperts = experts.take(4).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...displayedExperts.map(
                (expert) => CardDoctorCmp(
                  imagePath: _normalizeImage(expert.photo),
                  buyTicket: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileExpert(
                          expertId: expert.uuid,
                          expertUuid: expert.userUuid,
                          doctorName: expert.name,
                          starCount: expert.rating.toStringAsFixed(1),
                        ),
                      ),
                    );
                  },
                  categoryType: _roleLabel(expert.role),
                  doctorName: expert.name,
                  starCount: expert.rating.toStringAsFixed(1),
                  skill: expert.specialization.isEmpty
                      ? 'Spesialis Anak, Tumbuh Kembang'
                      : expert.specialization,
                ),
              ),
              if (experts.length > 4)
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MorePageConsultation(),
                        ),
                      );
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }

  String _roleLabel(String role) {
    return switch (role.toLowerCase()) {
      'doctor' => 'Dokter',
      'nutritionist' => 'Ahli Gizi',
      _ => 'Expert',
    };
  }

  String _normalizeImage(String photo) {
    if (photo.isEmpty) return 'assets/temp_img/dr.palomina1.jpg';
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return photo;
    }
    if (photo.startsWith('/')) return '${ApiBaseUrl.baseUrl}$photo';
    return '${ApiBaseUrl.baseUrl}/$photo';
  }
}
