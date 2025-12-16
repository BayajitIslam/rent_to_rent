import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/admin_recommendation.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class LocationResultsScreen extends StatelessWidget {
  LocationResultsScreen({super.key});

  final LocationSuitabilityController controller =
      Get.find<LocationSuitabilityController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.locationSuitability, showBack: true),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Category Ratings Section
                  _buildCategoryRatingsSection(),
                  SizedBox(height: 24.h),

                  // Location Insights Section
                  _buildLocationInsightsSection(),
                  SizedBox(height: 20.h),

                  // Admin Recommendations Section
                  AdminRecommendation(controller: controller),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  _buildActionButtons(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Category Ratings Section ====================
  Widget _buildCategoryRatingsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        // color: AppColors.white,
        // borderRadius: BorderRadius.circular(12.r),
        // boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 10)],
      ),
      child: Obx(
        () => Column(
          children: [
            // Row 1: Senior Living WG & Students
            Row(
              children: [
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.isNotEmpty
                        ? controller.categoryRatings[0].name
                        : 'Senior Living WG',
                    controller.categoryRatings.isNotEmpty
                        ? controller.categoryRatings[0].rating
                        : 4.0,
                  ),
                ),
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.length > 1
                        ? controller.categoryRatings[1].name
                        : 'Students',
                    controller.categoryRatings.length > 1
                        ? controller.categoryRatings[1].rating
                        : 4.0,
                    isRightAlign: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Row 2: Short Stay & Monteurzimmer
            Row(
              children: [
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.length > 2
                        ? controller.categoryRatings[2].name
                        : 'Short Stay',
                    controller.categoryRatings.length > 2
                        ? controller.categoryRatings[2].rating
                        : 4.0,
                  ),
                ),
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.length > 3
                        ? controller.categoryRatings[3].name
                        : 'Monteurzimmer',
                    controller.categoryRatings.length > 3
                        ? controller.categoryRatings[3].rating
                        : 4.0,
                    isRightAlign: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Row 3: Engineer Housing & Airbnb (optional)
            Row(
              children: [
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.length > 4
                        ? controller.categoryRatings[4].name
                        : 'Engineer Housing',
                    controller.categoryRatings.length > 4
                        ? controller.categoryRatings[4].rating
                        : 4.0,
                  ),
                ),
                Expanded(
                  child: _buildRatingItem(
                    controller.categoryRatings.length > 5
                        ? controller.categoryRatings[5].name
                        : 'Airbnb (optional)',
                    controller.categoryRatings.length > 5
                        ? controller.categoryRatings[5].rating
                        : 4.0,
                    isRightAlign: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(
    String name,
    double rating, {
    bool isRightAlign = false,
  }) {
    return Column(
      crossAxisAlignment: isRightAlign
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Category Name
        Text(
          name,
          style: AppTextStyle.s16w4(
            color: AppColors.neutralS,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        // Rating with Stars
        Row(
          mainAxisAlignment: isRightAlign
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              '${rating.toStringAsFixed(1)}/5',
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4.w),
            _buildStarRating(rating),
          ],
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: 20.sp);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: 20.sp);
        } else {
          return Icon(
            Icons.star_border,
            color: AppColors.neutralS,
            size: 16.sp,
          );
        }
      }),
    );
  }

  // ==================== Location Insights Section ====================
  Widget _buildLocationInsightsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 22.sp),
              SizedBox(width: 6.w),
              Text(
                AppString.locationInsights,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Insights List
          Obx(
            () => Column(
              children: controller.locationInsights
                  .map((insight) => _buildInsightItem(insight))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(LocationInsight insight) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          // Icon
          SizedBox(
            width: 24.w,
            child: Icon(
              _getInsightIcon(insight.icon),
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 10.w),

          // Title
          Expanded(
            child: Text(
              insight.title,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 14,
              ),
            ),
          ),

          // Value & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (insight.value.isNotEmpty)
                Text(
                  insight.value,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (insight.subtitle.isNotEmpty)
                Text(
                  insight.subtitle,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getInsightIcon(String icon) {
    switch (icon) {
      case 'university':
        return Icons.school_outlined;
      case 'transport':
        return Icons.directions_subway_outlined;
      case 'employer':
        return Icons.people_outline;
      case 'hospital':
        return Icons.local_hospital_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  // ==================== Action Buttons ====================
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Save Analysis Button (Outline)
        Expanded(
          child: GestureDetector(
            onTap: () => controller.saveAnalysis(),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.deepBlue, width: 1.5),
              ),
              child: Center(
                child: Text(
                  AppString.saveAnalysis,
                  style: AppTextStyle.s16w4(
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Start New Analysis Button (Filled)
        Expanded(
          child: GestureDetector(
            onTap: () => controller.startNewAnalysis(),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Center(
                child: Text(
                  AppString.startNewAnalysis,
                  style: AppTextStyle.s16w4(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
