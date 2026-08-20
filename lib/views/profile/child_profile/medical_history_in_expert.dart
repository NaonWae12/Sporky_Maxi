import 'package:flutter/material.dart';
import '../../../components/expert_components/profile/child_data_cmp/medical_history_cmp.dart';

class MedicalHistoryInExpert extends StatelessWidget {
  final String childUuid;
  final String? roomUuid;
  final String parentName;

  const MedicalHistoryInExpert({
    super.key,
    required this.childUuid,
    this.roomUuid,
    required this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    return MedicalHistoryCmp(
      childUuid: childUuid,
      roomUuid: roomUuid,
      parentName: parentName,
    );
  }
}
