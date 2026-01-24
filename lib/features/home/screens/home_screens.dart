import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/home/controllers/home_controller.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 13.h),

                  // Feature Cards Grid
                  _buildFeatureCardsGrid(),
                  SizedBox(height: 22.h),

                  // Recent Activity Section
                  _buildRecentActivitySection(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: ClipOval(
              child: Obx(
                () => _buildProfileImage(profileController.userImage.value),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.welcomeBack,
                  style: AppTextStyle.s16w4(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: AppTextStyle.s24w7(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // profile image widget
  Widget _buildProfileImage(String imagePath) {
    // local file path
    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      final file = File(imagePath);
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }

    // network url
    if (imagePath.isNotEmpty && imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          );
        },
      );
    }

    // default
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Image.asset(
      AppImage.profilePlaceholder,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.primaryLight,
          child: Icon(Icons.person, color: AppColors.white, size: 24.sp),
        );
      },
    );
  }

  Widget _buildFeatureCardsGrid() {
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: AppImage.contractCreation,
                title: AppString.contractCreation,
                subtitle: AppString.contractCreationDesc,
                onTap: () => controller.goToContractCreation(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFeatureCard(
                icon: AppImage.checkIncoming,
                title: AppString.checkIncomingContract,
                subtitle: AppString.checkIncomingContractDesc,
                onTap: () => controller.goToCheckIncoming(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Second Row
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: AppImage.locationSuitability,
                title: AppString.locationSuitability,
                subtitle: AppString.locationSuitabilityDesc,
                onTap: () => controller.goToLocationSuitability(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFeatureCard(
                icon: AppImage.fieldAgent,
                title: AppString.fieldAgentCommunication,
                subtitle: AppString.fieldAgentCommunicationDesc,
                onTap: () => controller.goToFieldAgent(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 196.h,
        padding: EdgeInsets.all(11.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 52.w,
              height: 52.h,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                icon,
                width: 36.w,
                height: 36.h,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Title
            Text(
              title,
              style: AppTextStyle.s24w7(
                color: AppColors.neutralS,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4.h),

            // Subtitle
            Text(
              subtitle,
              style: AppTextStyle.s16w4(
                color: AppColors.ash,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.recentActivity,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Filter Dropdown
            GestureDetector(
              onTap: () => controller.showFilterOptions(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.selectedFilter.value,
                        style: AppTextStyle.s16w4(
                          color: AppColors.neutralS,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 30.sp,
                      color: AppColors.neutralS,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Activity Cards Grid
        Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : controller.recentActivities.isEmpty
              ? Center(
                  child: Text(
                    AppString.noRecentActivity,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 12,
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: controller.recentActivities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.recentActivities[index];
                    return _buildActivityCard(activity);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(ActivityModel activity) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border(
          left: BorderSide(
            color: activity.status == 'OK'
                ? AppColors.primary
                : activity.status == 'Draft'
                ? AppColors.ash
                : AppColors.greencheck,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                activity.title,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Address
              SizedBox(height: 4),
              Text(
                activity.address,
                style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Date & Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activity.date,
                style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 11),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: activity.status == 'OK'
                      ? const Color(0XffECF9F3)
                      : activity.status == 'Draft'
                      ? const Color(0XffF3F4F6)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  activity.status,
                  style: AppTextStyle.s16w4(
                    color: activity.status == 'OK'
                        ? AppColors.greencheck
                        : activity.status == 'Draft'
                        ? AppColors.ash
                        : AppColors.primary,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
