import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle titleStyle() {
  return GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
}

TextStyle drawerMenuStyle() {
  return GoogleFonts.dmSans(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle drawerMenuSelectedStyle() {
  return GoogleFonts.dmSans(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: AppColors.backbackgroundHiddenDrawer,
  );
}

TextStyle normalTextStyle(Color color) {
  return GoogleFonts.dmSans(
    fontSize: 18,
    color: color,
  );
}

TextStyle normalTextStyleDefault(
  Color color,
) {
  return GoogleFonts.dmSans(
    fontSize: 14,
    color: color,
  );
}

TextStyle normalTextStyleBold(Color color) {
  return GoogleFonts.dmSans(
    fontWeight: FontWeight.bold,
    color: color,
  );
}

TextStyle textFieldsLettersTextStyle(Color color) {
  return GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: color,
  );
}

TextStyle biggerTextStyle() {
  return GoogleFonts.dmSans(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
