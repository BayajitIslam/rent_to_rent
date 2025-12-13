import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonName;
  final Color textColors;
  final Color bgColor;
  final bool isloading;
  const CustomButton({
    super.key,
    this.onTap,
    required this.buttonName,
    this.textColors = AppColors.white,
    this.bgColor = AppColors.primary,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: isloading
            ? CircularProgressIndicator.adaptive()
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
