// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/dropdown/globals_dropdown.dart';
import 'package:sporky_maxi/views/bottom_navbar/navbar.dart';

import '../../../../components/globals/colors/colors.dart';
import '../../../../components/globals/dialog/dialog_alert.dart';
import '../../../../components/globals/dropdown/date_dropdown_field.dart';
import '../../../../components/globals/form/globals_form.dart';
import '../../../../components/globals/text/text_style.dart';
import '../../../../core/services/child/get_data_child_growth_updates_service.dart';
import '../../../../core/services/child/put_child_growth_updates_service.dart';
import '../../../../models/components/child/child_growth_updates_model.dart';

class PageChildGrowthUpdates extends StatefulWidget {
  const PageChildGrowthUpdates({super.key});

  @override
  State<PageChildGrowthUpdates> createState() => _PageChildGrowthUpdatesState();
}

class _PageChildGrowthUpdatesState extends State<PageChildGrowthUpdates> {
  String? selectedChildUuid;
  DateTime? selectedDate;
  late TextEditingController tinggi;
  late TextEditingController berat;
  late Future<List<ChildGrowthUpdatesModel>> _childrenFuture;

  @override
  void initState() {
    super.initState();
    tinggi = TextEditingController();
    berat = TextEditingController();
    _childrenFuture = ChildDropdownService().getChildren();
  }

  @override
  void dispose() {
    tinggi.dispose();
    berat.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (selectedChildUuid == null ||
        tinggi.text.isEmpty ||
        berat.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua data wajib diisi")),
      );
      return;
    }

    try {
      await PutChildGrowthUpdatesService().updateGrowthData(
        childUuid: selectedChildUuid!,
        height: int.parse(tinggi.text),
        weight: double.parse(berat.text),
      );

      DialogAlert.show(
        context: context,
        customChild: Content1(
          title: 'Data Anak Tersimpan!',
          message:
              'Informasi tumbuh kembang si kecil sudah tercatat. Terima kasih sudah memantau perkembangan buah hati, Bunda! 💛',
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Navbar(),
                ));
          },
          textNav: 'Akses Beranda',
          colorButton: AppColors.secondary1,
          iconAsset: 'assets/svg/ic_ growth.svg',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Update Pertumbuhan Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder<List<ChildGrowthUpdatesModel>>(
              future: _childrenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text("Gagal memuat data anak");
                }

                final children = snapshot.data!;
                if (children.isEmpty) {
                  return const Text("Belum ada data anak");
                }

                return GlobalsDropdown<String>(
                  height: 48,
                  radius: 16,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColors.base4,
                  hintText: "Untuk Siapa?",
                  hinTextColor: AppColors.secondary1,
                  value: selectedChildUuid,
                  items: children.map((e) => e.uuid).toList(),
                  onChanged: (val) => setState(() => selectedChildUuid = val),
                  itemLabelBuilder: (uuid) =>
                      children.firstWhere((e) => e.uuid == uuid).name,
                );
              },
            ),
            const SizedBox(height: 20),
            DateDropdownField(
              label: 'Tanggal',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 15),
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
        child: GlobalsButton(
          onPressed: _submitUpdate,
          color: AppColors.secondary1,
          text: 'Update Data Anak',
        ),
      ),
    );
  }
}
