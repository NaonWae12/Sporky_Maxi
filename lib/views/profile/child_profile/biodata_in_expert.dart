import 'package:flutter/material.dart';

import '../../../components/expert_components/profile/child_data_cmp/biodata_cmp.dart';

class BiodataInExpert extends StatelessWidget {
  final String childName;
  final String dob;
  final String weight;
  final String height;
  final String medicalHistories;
  final String allergies;
  final String favorites;
  final String avoided;

  const BiodataInExpert({
    super.key,
    required this.childName,
    required this.dob,
    required this.weight,
    required this.height,
    required this.medicalHistories,
    required this.allergies,
    required this.favorites,
    required this.avoided,
  });

  @override
  Widget build(BuildContext context) {
    return BiodataCmp(
      childName: childName,
      calendar: dob,
      weight: weight,
      height: height,
      historyOfIllness: medicalHistories,
      allergies: allergies,
      favoriteFood: favorites,
      foodsToAvoid: avoided,
    );
  }
}
