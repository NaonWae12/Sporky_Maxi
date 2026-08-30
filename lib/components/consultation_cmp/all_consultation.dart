import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/cmp_list_doctor.dart';
import 'package:sporky_maxi/components/consultation_cmp/profile_expert.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/core/services/consultation/consultation_service.dart';
import 'package:sporky_maxi/models/components/consultation/expert_model.dart';

import '../globals/card/globals_card_outlined.dart';
import '../globals/colors/colors.dart';
import '../globals/filter/filter_content_button.dart';
import '../globals/text/text_style.dart';

class AllConsultation extends StatefulWidget {
  const AllConsultation({super.key});

  @override
  State<AllConsultation> createState() => _AllConsultationState();
}

class _AllConsultationState extends State<AllConsultation> {
  static const ConsultationService _service = ConsultationService();

  List<String> _selectedFiltersFromBottomSheet = [];
  late Future<List<ExpertItem>> _expertsFuture;

  @override
  void initState() {
    super.initState();
    _loadExperts();
  }

  void _loadExperts() {
    _expertsFuture = _service.getExperts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _selectedFiltersFromBottomSheet.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedFiltersFromBottomSheet.map((
                            filter,
                          ) {
                            return GlobalsCardOutlined(
                              height: 24,
                              borderColor: Colors.transparent,
                              backgroundColor: AppColors.secondary2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    filter,
                                    style: AppTextStyles.list1Regular(
                                      AppColors.base5,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 15,
                                      color: AppColors.base5,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      setState(() {
                                        _selectedFiltersFromBottomSheet.remove(
                                          filter,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(width: 8),
                FilterContentButton(
                  categories: const ['Dokter', 'Ahli Gizi'],
                  title: 'Urutkan Berdasarkan',
                  onFilterApplied: (selected) {
                    setState(() {
                      _selectedFiltersFromBottomSheet = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<List<ExpertItem>>(
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
                      child: const Text('Gagal memuat expert. Coba lagi'),
                    ),
                  ),
                );
              }

              final experts = snapshot.data ?? [];
              if (experts.isEmpty) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: Text('Belum ada expert')),
                );
              }

              return Column(
                children: experts.map((expert) {
                  return CmpListDoctor(
                    onTap: () {
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
                    imageAsset: _normalizeImage(expert.photo),
                    isAvailable: true,
                    role: _roleLabel(expert.role),
                    doctorName: expert.name,
                    specialization: expert.specialization,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
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
