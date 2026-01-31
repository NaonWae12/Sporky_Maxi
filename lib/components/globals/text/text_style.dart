import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Heading
  static TextStyle heading1SemiBold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );

  static TextStyle heading2SemiBold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );

  static TextStyle heading3Regular([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      );
  static TextStyle heading3SemiBold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color, // kalau null, TextStyle gak set warna
        ),
      );

  static TextStyle heading3Medium([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
  //Upper Display
  static TextStyle upperDisplay1SemiBold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );
  // Display
  static TextStyle display1Bold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  static TextStyle display1SemiBold([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );

  static TextStyle display1Regular([Color? color]) => GoogleFonts.baloo2(
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      );

  // Description
  static TextStyle desc1Regular([Color? color]) => GoogleFonts.baloo2(
        textStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color),
      );

  // Lable
  static TextStyle lable2Regular([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ));
  static TextStyle lable2Medium([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ));
  static TextStyle lable3Regular([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      ));
  static TextStyle lable3Medium([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ));
  static TextStyle lable3SemiBold([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ));
  static TextStyle lable4Regular([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: color,
      ));
  static TextStyle lable4SemiRegular([Color? color]) => GoogleFonts.baloo2(
          textStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: color,
      ));

  // List
  static TextStyle list1Regular([Color? color, TextDecoration? decoration]) =>
      GoogleFonts.roboto(
          textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
              decoration: decoration));
  static TextStyle list1Medium([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ));
  static TextStyle list1SemiBold([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ));
  static TextStyle list1Bold([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
      ));
  static TextStyle list1_1Bold([Color? color, FontStyle? fontStyle]) =>
      GoogleFonts.roboto(
          textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              fontStyle: fontStyle));
  static TextStyle list3SemiBold([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: color,
      ));
  static TextStyle list3Regular([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: color,
      ));
  static TextStyle list3Bold([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w700,
        color: color,
      ));

  // HeadList
  static TextStyle headList1Regular([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      ));
  static TextStyle headList1Medium([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ));
  static TextStyle headList1Bold([Color? color]) => GoogleFonts.roboto(
          textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      ));
  // khusus calendar
  static TextStyle calendar1Medium([Color? color]) => GoogleFonts.lato(
          textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ));
}
