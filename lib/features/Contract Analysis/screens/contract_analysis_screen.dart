import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Contract%20Analysis/controllers/contract_analysis_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class ContractAnalysisScreen extends StatelessWidget {
  ContractAnalysisScreen({super.key});

  final ContractAnalysisController controller =
      Get.find<ContractAnalysisController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // AppBar
          CustomAppBar(title: AppString.contractAnalysis),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),

                  // Section Title
                  Text(
                    AppString.checkIncomingContractN,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Upload Container
                  _buildUploadContainer(),

                  // Analyze Contract Button
                  Spacer(),
                  Obx(
                    () => CustomButton(
                      buttonHeight: 39,
                      radius: 8,
                      buttonName: AppString.analyzeContract,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.analyzeContract(),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadContainer() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.pickFile(),
        child: Container(
          width: double.infinity,
          height: 209.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: controller.selectedFile.value != null
              ? _buildSelectedFileView()
              : _buildUploadPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Upload Icon
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(AppImage.uploadIcon),
        ),
        SizedBox(height: 16.h),

        // Drag & Drop Text
        Text(
          AppString.dragAndDropOrTap,
          style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 12),
        ),
        SizedBox(height: 8.h),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            AppString.uploadContractDescription,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PDF Icon
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 36.sp),
        ),
        SizedBox(height: 12.h),

        // File Name
        Obx(
          () => Text(
            controller.fileName.value,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // Change File Button
        TextButton(
          onPressed: () => controller.pickFile(),
          child: Text(
            AppString.changeFile,
            style: AppTextStyle.s16w4(color: AppColors.primary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
