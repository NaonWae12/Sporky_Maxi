import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/card_doctor_cmp.dart';

import '../../views/consultation/more_page_consultation.dart';

class RowRekomendation extends StatefulWidget {
  const RowRekomendation({super.key});

  @override
  State<RowRekomendation> createState() => _RowRekomendationState();
}

class _RowRekomendationState extends State<RowRekomendation> {
  @override
  Widget build(BuildContext context) {
    final List<CardDoctorCmp> doctor = [
      CardDoctorCmp(
          imagePath: 'assets/temp_img/dr.palomina1.jpg',
          buyTicket: () {},
          categoryType: 'Dokter',
          doctorName: 'dr. Palomina',
          starCount: '5',
          skill: 'Spesialis Anak, Tumbuh Kembang'),
      CardDoctorCmp(
          isFullSchedule: true,
          hasBadge: true,
          imagePath: 'assets/temp_img/dr.nutritionist.jpg',
          buyTicket: () {},
          categoryType: 'Ahli Gizi',
          doctorName: 'dr. Palomina',
          starCount: '5',
          skill: 'Spesialis Anak, Tumbuh Kembang'),
      CardDoctorCmp(
          imagePath: 'assets/temp_img/dr.palomina1.jpg',
          buyTicket: () {},
          categoryType: 'Dokter',
          doctorName: 'dr. Palomina',
          starCount: '5',
          skill: 'Spesialis Anak, Tumbuh Kembang'),
      CardDoctorCmp(
          isFullSchedule: true,
          hasBadge: true,
          imagePath: 'assets/temp_img/dr.palomina1.jpg',
          buyTicket: () {},
          categoryType: 'Dokter',
          doctorName: 'dr. Palomina',
          starCount: '5',
          skill: 'Spesialis Anak, Tumbuh Kembang'),
    ];
    final int totalCardDoctorCmp = doctor.length;

    List<Widget> displayedCardDoctor =
        totalCardDoctorCmp > 3 ? doctor.take(4).toList() : doctor;
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...displayedCardDoctor,
            if (totalCardDoctorCmp > 3)
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MorePageConsultation()),
                    );
                  },
                  child: const Text('Lihat Semua'),
                ),
              ),
            const SizedBox(width: 10)
          ],
        ));
  }
}
