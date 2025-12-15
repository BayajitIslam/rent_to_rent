import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/home/controllers/home_controller.dart';
import 'package:template/features/home/screens/main_layout.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

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
                  SizedBox(height: 100.h), // Bottom padding for navbar
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
              image: DecorationImage(
                image: AssetImage(AppImage.profilePlaceholder),
                fit: BoxFit.cover,
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

          // // Notification Icon
          // GestureDetector(
          //   onTap: () => controller.goToNotifications(),
          //   child: Container(
          //     width: 44.w,
          //     height: 44.h,
          //     decoration: BoxDecoration(
          //       color: AppColors.white,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Stack(
          //       children: [
          //         Center(
          //           child: Icon(
          //             Icons.notifications_outlined,
          //             color: AppColors.primary,
          //             size: 30.sp,
          //           ),
          //         ),
          //         // Notification Badge
          //         Positioned(
          //           top: 8.h,
          //           right: 10.w,
          //           child: Container(
          //             width: 8.w,
          //             height: 8.h,
          //             decoration: BoxDecoration(
          //               color: Colors.red,
          //               shape: BoxShape.circle,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
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
                  // border: Border.all(color: AppColors.ash),
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
          () => GridView.builder(
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
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.04),
        //     blurRadius: 8,
        //     offset: Offset(0, 2),
        //   ),
        // ],
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
