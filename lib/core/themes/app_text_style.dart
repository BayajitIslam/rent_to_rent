import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/constants/app_colors.dart';

class AppTextStyle {
  //<============================== App Text ====================================>
  static TextStyle s32w7({
    Color? color = AppColors.white,
    double fontSize = 32,
    FontWeight? fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.3,
    );
  }

  static TextStyle s24w7({
    Color? color = AppColors.white,
    double fontSize = 24,
    FontWeight? fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.3,
    );
  }

  static TextStyle s16w4({
    Color? color = AppColors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.3,
    );
  }

  static TextStyle s24w5({
    Color? color = AppColors.neutralS,
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.5,
    );
  }
}
