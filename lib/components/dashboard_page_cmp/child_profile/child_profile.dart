import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../core/services/child/eer_service.dart';
import '../../../core/services/child/screening_service.dart';
import '../../../core/utils/age_helper.dart';
import '../../../models/components/child/child_latest_screening_model.dart';
import '../../globals/profile_cmp/child_profile_section.dart';

class ChildProfile extends StatelessWidget {
  final List<String> childUuids;
  final ValueChanged<String>? onChildSelected;

  /// ➕ Opsional: tampilkan card tambah anak
  final bool showAddChildCard;
  final VoidCallback? onAddChildTap;

  const ChildProfile({
    super.key,
    required this.childUuids,
    this.onChildSelected,
    this.showAddChildCard = false,
    this.onAddChildTap,
  });

  @override
  Widget build(BuildContext context) {
    final screeningService = ScreeningService();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // ================= EXISTING CHILD CARDS =================
          ...childUuids.map((childUuid) {
            return FutureBuilder<ChildLatestScreening>(
              future: screeningService.getLatestByChildUuid(childUuid),
              builder: (context, snapshot) {
                // ⏳ Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 372,
                      height: 140,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                // ❌ Error
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 372,
                      height: 140,
                      child: Center(
                        child: Text("Gagal memuat data anak"),
                      ),
                    ),
                  );
                }

                // ✅ Success
                final data = snapshot.data!;
                final age = calculateAge(data.child.dob);

                debugPrint(
                  '[ChildProfile] ${data.child.name} '
                  '(UUID: ${data.child.uuid}) '
                  'nutritionStatus: ${data.screening.nutritionStatus}',
                );

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => onChildSelected?.call(data.child.uuid),
                    child: ChildProfileSection(
                      childName: data.child.name,
                      ageYear: age['year'] ?? 0,
                      ageMonth: age['month'] ?? 0,
                      tb: data.screening.height?.round() ?? 0,
                      bb: data.screening.weight?.round() ?? 0,
                      status: data.screening.nutritionStatus ?? '-',
                      score: EERService.roundToClosest(data.screening.eer ?? 0),
                    ),
                  ),
                );
              },
            );
          }),

          // ================= ADD CHILD CARD (OPTIONAL) =================
          if (showAddChildCard)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: onAddChildTap,
                child: SizedBox(
                  width: 372,
                  height: 140,
                  child: Card(
                    color: AppColors.primary3,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 36,
                          ),
                          SizedBox(height: 8),
                          Text("Tambah Anak",
                              style: AppTextStyles.lable2Regular()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
