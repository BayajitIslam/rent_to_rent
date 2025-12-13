import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class BuildTabWidget extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const BuildTabWidget({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? const Color(0XffF6F9FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: isActive ? Border.all(color: AppColors.ash) : null,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.s16w4(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.neutralS : AppColors.ash,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
