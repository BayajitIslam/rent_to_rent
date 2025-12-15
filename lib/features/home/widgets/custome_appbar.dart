import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';

enum AppBarType {
  simple, // Only back + title (Field Agent Communication)
  withSave, // Back + title + save button (Create Contract)
  withSaveDownload, // Back + title + download + save buttons (Contract Analysis Report)
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final AppBarType type;
  final VoidCallback? onBackTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onDownloadTap;
  final bool showBack;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.type = AppBarType.simple,
    this.onBackTap,
    this.onSaveTap,
    this.onDownloadTap,
    this.showBack = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.10),
            blurRadius: 14,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),

      child: Row(
        children: [
          // Back Button
          if (showBack)
            GestureDetector(
              onTap: onBackTap ?? () => Get.back(),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
              ),
            )
          else
            SizedBox(width: 36.w),

          // Title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.s24w5(
                color: AppColors.neutralS,
                fontSize: 20,
              ),
            ),
          ),

          // Action Buttons based on type
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (type) {
      case AppBarType.simple:
        // Empty space to balance the back button
        return SizedBox(width: 36.w);

      case AppBarType.withSave:
        // Only Save button
        return GestureDetector(
          onTap: onSaveTap,
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                Icons.save_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
        );

      case AppBarType.withSaveDownload:
        // Download + Save buttons
        return Row(
          children: [
            // Download Button
            GestureDetector(
              onTap: onDownloadTap,
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.file_download_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Save Button
            GestureDetector(
              onTap: onSaveTap,
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.save_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}

// ==================== Usage Examples ====================
/*

// 1. Simple AppBar (Field Agent Communication)
CustomAppBar(
  title: 'Field Agent Communication',
  type: AppBarType.simple,
)

// 2. AppBar with Save button (Create Contract)
CustomAppBar(
  title: 'Create Contract',
  type: AppBarType.withSave,
  onSaveTap: () {
    // Save logic
    Console.green('Save tapped');
  },
)

// 3. AppBar with Download + Save buttons (Contract Analysis Report)
CustomAppBar(
  title: 'Contract Analysis Report',
  type: AppBarType.withSaveDownload,
  onDownloadTap: () {
    // Download logic
    Console.blue('Download tapped');
  },
  onSaveTap: () {
    // Save logic
    Console.green('Save tapped');
  },
)

// 4. Without back button
CustomAppBar(
  title: 'Dashboard',
  type: AppBarType.simple,
  showBack: false,
)

// 5. Custom back action
CustomAppBar(
  title: 'Create Contract',
  type: AppBarType.withSave,
  onBackTap: () {
    // Custom back logic
    Get.offAllNamed(RoutesName.home);
  },
  onSaveTap: () {},
)

*/
