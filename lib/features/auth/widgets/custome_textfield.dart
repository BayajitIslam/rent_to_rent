import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';

class CustomeTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  const CustomeTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.onToggleVisibility,
    this.isPassword = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(48.r),
      ),

      child: Center(
        child: TextField(
          controller: controller,
          obscureText: isPassword && obscureText,
          style: AppTextStyle.s16w4(color: AppColors.ash),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyle.s16w4(color: AppColors.ash),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: obscureText ? AppColors.primary : AppColors.ash,
                      size: 20.sp,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
