import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';

class AdminRecommendation extends StatelessWidget {
  final dynamic controller;
  const AdminRecommendation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Icon
          Row(
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppString.adminRecommendations,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Recommendations List
          Obx(
            () => Column(
              children: (controller.recommendations as List<String>)
                  .map<Widget>((rec) => _buildRecommendationItem(rec))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
