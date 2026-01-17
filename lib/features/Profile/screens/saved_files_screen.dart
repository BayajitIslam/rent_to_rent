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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Contracts Section
                  _buildSectionTitle(AppString.contracts),
                  SizedBox(height: 12.h),
                  Obx(() => _buildFileGrid(controller.contracts, 'contracts')),
                  SizedBox(height: 24.h),

                  // Inquiries Section
                  _buildSectionTitle(AppString.inquiries),
                  SizedBox(height: 12.h),
                  Obx(() => _buildFileGrid(controller.inquiries, 'inquiries')),
                  SizedBox(height: 24.h),

                  // Uploaded Documents Section
                  _buildSectionTitle(AppString.uploadedDocuments),
                  SizedBox(height: 12.h),
                  Obx(
                    () => _buildFileGrid(
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

  Widget _buildFileGrid(List<SavedFile> files, String category) {
    if (files.isEmpty) {
      return Container(
        height: 100.h,
        alignment: Alignment.center,
        child: Text(
          'No files available',
          style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
        ),
      );
    }

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: List.generate(
        files.length,
        (index) => _buildFileCard(files[index], category, index),
      ),
    );
  }

  Widget _buildFileCard(SavedFile file, String category, int index) {
    return Container(
      width: 125.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDF Icon
              Image.asset(
                'assets/icons/pdf_icon.png',
                width: 36.w,
                height: 36.h,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.description_outlined,
                    color: AppColors.deepblue,
                    size: 36.sp,
                  );
                },
              ),
              SizedBox(height: 8.h),

              // File Name
              Text(
                file.name,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),

              // Date
              Text(
                file.date,
                style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 9),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              // Download Button
              GestureDetector(
                onTap: () => controller.downloadFile(file),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.deepblue,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        color: AppColors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppString.download,
                        style: AppTextStyle.s16w4(
                          color: AppColors.white,
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

          // Delete Button - Top Right
          Positioned(
            top: -4.h,
            right: -2.w,
            child: GestureDetector(
              onTap: () => controller.deleteFile(category, index),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
