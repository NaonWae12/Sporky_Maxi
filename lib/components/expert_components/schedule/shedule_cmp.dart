import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';

import '../../globals/colors/colors.dart';

class SheduleCmp extends StatefulWidget {
  const SheduleCmp({super.key});

  @override
  State<SheduleCmp> createState() => _SheduleCmpState();
}

class _SheduleCmpState extends State<SheduleCmp> {
  bool isOnline = true;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday % 7));
    List<DateTime> weekDates =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return GlobalsCard(
      padding: EdgeInsets.all(8),
      hasShadow: false,
      backgroundColor: AppColors.base4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header Row =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/ic_ calendar - schedule.svg', // pastiin nama file benar
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${_formatDay(selectedDate)}, ${selectedDate.day} ${_formatMonth(selectedDate)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (isOnline) ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: (isOnline) ? AppColors.success1 : AppColors.base2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GFToggle(
                    duration: const Duration(milliseconds: 120),
                    onChanged: (bool? value) {
                      setState(() {
                        isOnline = value ?? false;
                      });
                    },
                    value: isOnline,
                    type: GFToggleType.ios,
                    enabledTrackColor: AppColors.success1,
                    disabledTrackColor: AppColors.base3,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===== Calendar Row (1 week) =====
          GlobalsCard(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(0),
            hasShadow: false,
            backgroundColor: AppColors.base5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDates.map((date) {
                bool isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        _shortDay(date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.indigo : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  // helper buat format teks hari
  String _formatDay(DateTime date) {
    const days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    return days[date.weekday % 7];
  }

  // helper buat format bulan
  String _formatMonth(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[date.month - 1];
  }

  // helper buat singkatan hari
  String _shortDay(DateTime date) {
    const shortDays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
    return shortDays[date.weekday % 7];
  }
}
