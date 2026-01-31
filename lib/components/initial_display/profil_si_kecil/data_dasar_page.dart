import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dropdown/date_dropdown_field.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import '../../globals/dropdown/reactive_globals_dropdown.dart';
import '../../globals/form/globals_form.dart';

class DataDasarPage extends StatefulWidget {
  final Map<String, String> data;
  final void Function(String key, String value) onUpdate;
  final VoidCallback onNext;
  final double progressValue;

  const DataDasarPage({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.onNext,
    required this.progressValue,
  });

  @override
  State<DataDasarPage> createState() => _DataDasarPageState();
}

class _DataDasarPageState extends State<DataDasarPage> {
  late TextEditingController nama;
  late TextEditingController tanggalLahir;
  late TextEditingController tinggi;
  late TextEditingController berat;

  String? jenisKelamin;

  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.data["nama"]);
    tanggalLahir = TextEditingController(text: widget.data["tanggalLahir"]);
    tinggi = TextEditingController(text: widget.data["tinggi"]);
    berat = TextEditingController(text: widget.data["berat"]);
  }

  void handleNext() {
    widget.onUpdate("nama", nama.text);
    widget.onUpdate("tanggalLahir", tanggalLahir.text);
    widget.onUpdate("tinggi", tinggi.text);
    widget.onUpdate("berat", berat.text);
    widget.onUpdate("jenisKelamin", jenisKelamin!);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: widget.progressValue,
            color: Colors.orange,
            minHeight: 12,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          const SizedBox(height: 20),
          Text(
            "Yuk isi data dasar si kecil dulu",
            style: AppTextStyles.heading3SemiBold(const Color(0xFFBCBCBC)),
          ),
          const SizedBox(height: 20),
          GlobalsForm(label: "Nama Anak*", controller: nama),
          const SizedBox(height: 16),
          ReactiveGlobalsDropdown<String>(
            label: "Jenis Kelamin*",
            value: jenisKelamin,
            items: ['Perempuan', 'Laki-laki']
                .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                      style: AppTextStyles.heading3Medium(AppColors.base1),
                    )))
                .toList(),
            onChanged: (val) => setState(() => jenisKelamin = val),
          ),
          const SizedBox(height: 16),
          DateDropdownField(
            hint: Text(
              'Masukan Tanggal Lahir',
              style: AppTextStyles.heading3Medium(AppColors.base2),
            ),
            label: "Tanggal Lahir*",
            selectedDate: widget.data["tanggalLahir"]?.isNotEmpty == true
                ? DateFormat('dd/MM/yyyy').parse(widget.data["tanggalLahir"]!)
                : null,
            controller: tanggalLahir,
            onDateSelected: (date) {
              // Kalau mau update state atau validasi bisa di sini
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: GlobalsForm(
                      label: "Tinggi Badan (cm)*",
                      controller: tinggi,
                      keyboardType: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(
                  child: GlobalsForm(
                      label: "Berat Badan (kg)*",
                      controller: berat,
                      keyboardType: TextInputType.number)),
            ],
          ),
          const Spacer(),
          GlobalsButton(text: "Selanjutnya", onPressed: handleNext),
        ],
      ),
    );
  }
}
