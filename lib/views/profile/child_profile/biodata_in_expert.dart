import 'package:flutter/material.dart';

import '../../../components/expert_components/profile/child_data_cmp/biodata_cmp.dart';

class BiodataInExpert extends StatelessWidget {
  const BiodataInExpert({super.key});

  @override
  Widget build(BuildContext context) {
    return BiodataCmp(
      childName: 'childName',
      calendar: '16/10/2023',
      weight: '50',
      height: '50',
      historyOfIllness: 'Sinus',
      allergies: 'Kacang Tanah',
      favoriteFood: 'Bayam, Salmon',
      foodsToAvoid: 'Brokoli',
    );
  }
}
