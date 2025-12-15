// widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/home/controllers/navigation_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller;

    try {
      controller = Get.find<NavigationController>();
    } catch (e) {
      controller = Get.put(NavigationController(), permanent: true);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNavItem(
              isSvg: true,
              imagePath: AppImage.home,
              label: 'Dashboard',
              index: 0,
              isActive: controller.currentIndex.value == 0,
              onTap: () => controller.changePage(0),
            ),
            _buildNavItem(
              isSvg: true,
              imagePath: AppImage.contract,
              label: 'Contracts',
              index: 1,
              isActive: controller.currentIndex.value == 1,
              onTap: () => controller.changePage(1),
            ),
            _buildNavItem(
              imagePath: AppImage.contractCheck,
              label: 'Contract\nCheck',
              index: 2,
              isActive: controller.currentIndex.value == 2,
              onTap: () => controller.changePage(2),
            ),
            _buildNavItem(
              imagePath: AppImage.location,
              label: 'Location\nAnalysis',
              index: 3,
              isActive: controller.currentIndex.value == 3,
              onTap: () => controller.changePage(3),
            ),
            _buildNavItem(
              isSvg: true,
              imagePath: AppImage.profile,
              label: 'Profile',
              index: 4,
              isActive: controller.currentIndex.value == 4,
              onTap: () => controller.changePage(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    bool isSvg = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          isSvg
              ? SvgPicture.asset(
                  imagePath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isActive ? AppColors.primary : AppColors.ash,
                    BlendMode.srcIn,
                  ),
                )
              : ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isActive ? AppColors.primary : AppColors.ash,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(imagePath, width: 24.w, height: 24.h),
                ),
          SizedBox(height: 6.h),

          // Label
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.ash,
            ),
          ),
        ],
      ),
    );
  }
}
