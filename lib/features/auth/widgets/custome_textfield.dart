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
  final int maxLines;
  final double? height;
  final double? radius;

  const CustomeTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.onToggleVisibility,
    this.isPassword = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(radius ?? 48.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: maxLines,
              controller: controller,
              obscureText: isPassword && obscureText,
              style: AppTextStyle.s16w4(color: AppColors.neutralS),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyle.s16w4(color: AppColors.ash),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              onPressed: onToggleVisibility,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: obscureText ? AppColors.primary : AppColors.ash,
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }
}
