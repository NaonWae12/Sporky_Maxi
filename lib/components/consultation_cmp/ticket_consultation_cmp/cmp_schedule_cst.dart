import 'package:flutter/material.dart';

import '../../globals/button/globals_button.dart';
import '../../globals/colors/colors.dart';
import '../../globals/dropdown/globals_dropdown.dart';
import '../../globals/dropdown/globals_dropdown_animations.dart';
import '../../globals/dropdown/date_dropdown_field.dart';
import '../../globals/form/globals_text_area.dart';

class CmpScheduleCst extends StatefulWidget {
  const CmpScheduleCst({super.key});

  @override
  State<CmpScheduleCst> createState() => _CmpScheduleCstState();
}

class _CmpScheduleCstState extends State<CmpScheduleCst> {
  String? selectedChild;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  TextEditingController topicController = TextEditingController();

  final List<String> childList = ['Anak Pertama', 'Anak Kedua'];
  final List<String> timeSlots = [
    '09.00 - 09.30',
    '10.00 - 10.30',
    '11.00 - 11.30'
  ];

  bool get isFormValid {
    return selectedChild != null &&
        selectedDate != null &&
        selectedTimeSlot != null &&
        topicController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          GlobalsDropdown<String>(
            height: 48,
            radius: 16,
            borderColor: Colors.transparent,
            backgroundColor: AppColors.base4,
            hintText: "Untuk Siapa?",
            hinTextColor: AppColors.secondary1,
            value: selectedChild,
            items: childList,
            onChanged: (val) => setState(() => selectedChild = val),
            itemLabelBuilder: (item) => item,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: DateDropdownField(
              label: 'Tanggal',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          // GlobalsDropdown<String>(
          //   hintText: "Jam Konsultasi",
          //   value: selectedTimeSlot,
          //   items: timeSlots,
          //   onChanged: (val) => setState(() => selectedTimeSlot = val),
          //   itemLabelBuilder: (item) => item,
          // ),
          // const SizedBox(height: 16),
          GlobalsDropdownAnimations<String>(
            hintText: "Pilih Slot Jam",
            value: selectedTimeSlot,
            items: const ['09.00 - 09.30', '10.00 - 10.30'],
            itemLabelBuilder: (slot) => slot,
            onChanged: (val) => setState(() => selectedTimeSlot = val),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          GlobalsTextArea(
            label: "Topik Konsultasi",
            hintText: "Masukkan topik atau keluhan anak",
            controller: topicController,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 32),
          GlobalsButton(
            text: "Ajukan Jadwal Konsultasi",
            onPressed: isFormValid ? () {} : () {},
            color: isFormValid ? AppColors.primary1 : Colors.grey.shade300,
            textColor: isFormValid ? AppColors.base5 : Colors.grey.shade600,
          )
        ],
      ),
    );
  }
}
