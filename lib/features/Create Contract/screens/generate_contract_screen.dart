import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Create%20Contract/controllers/create_contract_controller_.dart';
import 'package:rent2rent/features/Create%20Contract/widgets/pdf_viewer.dart';
import 'package:rent2rent/features/Create%20Contract/widgets/step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class GenerateContractScreen extends StatelessWidget {
  GenerateContractScreen({super.key});

  final CreateContractController controller =
      Get.find<CreateContractController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(
              title: AppString.createContract,
              type: AppBarType.withSaveDownload,
              onDownloadTap: () => controller.downloadContract(),
              onSaveTap: () => controller.saveContract(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Step Indicator
                  StepIndicator(currentStep: 3),
                  // Contract Preview
                  PdfViewerWidget(pdfUrl: controller.resultPdfUrl.value),
                  SizedBox(height: 16.h),

                  // Action Buttons
                  _buildActionButtons(),
                  SizedBox(height: 16.h),

                  // Markdown Notes Section
                  _buildMarkdownNotesSection(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Action Buttons ====================
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Analyze This Checkbox
        Obx(
          () => GestureDetector(
            onTap: () => controller.analyzeThis.toggle(),
            child: Row(
              children: [
                Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: controller.analyzeThis.value
                        ? AppColors.primary
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      width: 2,
                      color: controller.analyzeThis.value
                          ? AppColors.primary
                          : AppColors.ash,
                    ),
                  ),
                  child: controller.analyzeThis.value
                      ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                      : null,
                ),
                SizedBox(width: 12.w),
                Text(
                  AppString.analyzeThis,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Download Buttons Row
        Row(
          children: [
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.picture_as_pdf_outlined,
                label: AppString.downloadPdf,
                onTap: () => controller.downloadPdf(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.description_outlined,
                label: AppString.downloadWord,
                onTap: () => controller.downloadWord(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Send for E-Signature Button
        Obx(
          () => CustomButton(
            buttonHeight: 48,
            buttonName: AppString.sendForESignature,
            isloading: controller.isLoading.value,
            onTap: () => controller.sendForESignature(),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.deepBlue),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.deepBlue, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyle.s16w4(
                color: AppColors.deepBlue,

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Markdown Notes Section ====================
  Widget _buildMarkdownNotesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.markdownNotes,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),

          // Notes Input
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD8D8D8)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              controller: controller.markdownNotesController,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: AppString.typeYourNote,
                hintStyle: AppTextStyle.s16w4(
                  color: AppColors.ash,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Add Another Note
          GestureDetector(
            onTap: () => controller.addNote(),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ash),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.ash, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    AppString.addAnotherNote,
                    style: AppTextStyle.s16w4(
                      color: AppColors.ash,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
