import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ProfileSection {
  final String title;
  final IconData icon;
  final List<ProfileItem> items;

  ProfileSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class ProfileItem {
  final String year;
  final String location;
  final String place;
  final String position;

  ProfileItem({
    required this.year,
    required this.location,
    required this.place,
    required this.position,
  });
}

class CmpTabProfileExpert extends StatelessWidget {
  const CmpTabProfileExpert({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      ProfileSection(
        title: 'Pengalaman Profesional',
        icon: Icons.work,
        items: [
          ProfileItem(
            year: '2022 - Saat Ini',
            location: 'Klinik Sehat Ceria, Jakarta',
            place: '',
            position: 'Dokter Spesialis Anak',
          ),
          ProfileItem(
            year: '2021 - 2022',
            location: 'RSUD Dr. Sutomo, Surabaya',
            place: '',
            position: 'Dokter Internship',
          ),
          ProfileItem(
            year: '2020 - 2021',
            location: 'Puskesmas Kemang, Jakarta Selatan',
            place: '',
            position: 'Asisten Dokter Anak',
          ),
        ],
      ),
      ProfileSection(
        title: 'Pendidikan',
        icon: Icons.school,
        items: [
          ProfileItem(
            year: '2013 - 2020',
            location: 'Universitas Indonesia, Depok',
            place: '',
            position: 'S.Ked & Profesi Dokter',
          ),
        ],
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((section) => _buildSection(section)).toList(),
      ),
    );
  }

  Widget _buildSection(ProfileSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(section.icon, color: AppColors.secondary1),
              const SizedBox(width: 8),
              Text(
                section.title,
                style: AppTextStyles.heading3SemiBold(AppColors.secondary1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.items.map((item) => _buildItem(item)),
        ],
      ),
    );
  }

  Widget _buildItem(ProfileItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary1,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.year, style: AppTextStyles.list1Medium()),
                  const SizedBox(height: 2),
                  Text(
                    '${item.location}${item.place.isNotEmpty ? ', ${item.place}' : ''} | ${item.position}',
                    style: AppTextStyles.list1Regular(AppColors.base2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
