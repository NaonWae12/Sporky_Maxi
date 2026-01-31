// ini tidak digunakan
import 'package:flutter/material.dart';
import '../../../globals/dropdown/date_dropdown_field.dart';

class JadwalKonsultasiPage extends StatefulWidget {
  const JadwalKonsultasiPage({super.key});

  @override
  State<JadwalKonsultasiPage> createState() => _JadwalKonsultasiPageState();
}

class _JadwalKonsultasiPageState extends State<JadwalKonsultasiPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Chat Konsultasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DateDropdownField(
              label: 'Tanggal',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            // ...lanjutan input lain
          ],
        ),
      ),
    );
  }
}
