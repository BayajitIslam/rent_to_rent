import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class SavedFilesScreen extends StatelessWidget {
  SavedFilesScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.savedFiles),

            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Contracts Section
                  _buildSectionTitle(AppString.contracts),
                  SizedBox(height: 12.h),
                  Obx(
                    () => _buildHorizontalFileList(
                      controller.contracts,
                      'contracts',
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Inquiries Section
                  _buildSectionTitle(AppString.inquiries),
                  SizedBox(height: 12.h),
                  Obx(
                    () => _buildHorizontalFileList(
                      controller.inquiries,
                      'inquiries',
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Uploaded Documents Section
                  _buildSectionTitle(AppString.uploadedDocuments),
                  SizedBox(height: 12.h),
                  Obx(
                    () => _buildHorizontalFileList(
                      controller.uploadedDocuments,
                      'documents',
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.s16w4(
        color: AppColors.neutralS,

        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildHorizontalFileList(List<SavedFile> files, String category) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: _buildFileCard(files[index], category, index),
          );
        },
      ),
    );
  }

  Widget _buildFileCard(SavedFile file, String category, int index) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDF Icon with Delete Button
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // PDF Icon Container
                  SizedBox(
                    // width: 50.w,
                    // height: 55.h,
                    // decoration: BoxDecoration(
                    //   color: AppColors.primaryLight,
                    //   borderRadius: BorderRadius.circular(6.r),
                    // ),
                    child: Stack(
                      children: [
                        // Document Icon
                        Center(
                          child: Icon(
                            Icons.description_outlined,
                            color: AppColors.neutralS,
                            size: 44.sp,
                          ),
                        ),
                        // PDF Badge
                        Positioned(
                          bottom: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),

                            child: Text(
                              'PDF',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // File Name
              Text(
                file.name,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),

              // Download Button
              GestureDetector(
                onTap: () => controller.downloadFile(file),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.deepblue,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, color: AppColors.white, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        AppString.download,
                        style: AppTextStyle.s16w4(
                          color: AppColors.cloudWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Delete Button - Top Right
        Positioned(
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: () => controller.deleteFile(category, index),

            child: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
          ),
        ),
      ],
    );
  }
}
