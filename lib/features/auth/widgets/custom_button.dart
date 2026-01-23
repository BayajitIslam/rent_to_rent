import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonName;
  final Color textColors;
  final Color bgColor;
  final bool isloading;
  final double buttonHeight;
  final double radius;
  const CustomButton({
    super.key,
    this.onTap,
    required this.buttonName,
    this.textColors = AppColors.white,
    this.bgColor = AppColors.deepBlue,
    this.isloading = false,
    this.buttonHeight = 50,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
        child: isloading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                buttonName,
                style: AppTextStyle.s16w4(
                  fontWeight: FontWeight.w600,
                  color: textColors,
                ),
              ),
      ),
    );
  }
}
