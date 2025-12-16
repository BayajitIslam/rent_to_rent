import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Contract%20Analysis/controllers/contract_analysis_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class ContractAnalysisReportScreen extends StatelessWidget {
  ContractAnalysisReportScreen({super.key});

  final ContractAnalysisController controller =
      Get.find<ContractAnalysisController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(
              title: AppString.contractAnalysisReport,
              type: AppBarType.withSaveDownload,
              onDownloadTap: () => controller.downloadReport(),
              onSaveTap: () => controller.saveReport(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Overall Rating
                  _buildOverallRating(),
                  SizedBox(height: 16.h),

                  // Contract Summary & Risk Analysis
                  _buildContractSummarySection(),
                  SizedBox(height: 14.h),

                  // Summary Insight
                  _buildSummaryInsightSection(),
                  SizedBox(height: 14.h),

                  // Safe Clauses Section
                  _buildSafeClausesSection(),
                  SizedBox(height: 14.h),

                  // Red Flags Section
                  _buildRedFlagsSection(),
                  SizedBox(height: 14.h),

                  // Warnings Section
                  _buildWarningsSection(),
                  SizedBox(height: 14.h),

                  // Admin Recommendations
                  _buildAdminRecommendations(),
                  SizedBox(height: 24.h),

                  // Regenerate Analysis Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.regenerateAnalysis,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.regenerateAnalysis(),
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

  // ==================== Overall Rating ====================
  Widget _buildOverallRating() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.overallRating,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,

              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: AppColors.greencheck,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Obx(
                () => Text(
                  controller.overallRating.value,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== Contract Summary Section ====================
  Widget _buildContractSummarySection() {
    return _buildSectionCard(
      icon: Icons.check_box,
      iconColor: AppColors.greencheck,
      // iconBgColor: AppColors.greencheck.withOpacity(0.1),
      title: AppString.contractSummaryRiskAnalysis,
      child: Obx(
        () => Text(
          controller.contractSummary.value,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
      ),
    );
  }

  // ==================== Summary Insight Section ====================
  Widget _buildSummaryInsightSection() {
    return _buildSectionCard(
      icon: Icons.lightbulb_outline,
      iconColor: Colors.amber,
      // iconBgColor: Colors.amber.withOpacity(0.1),
      title: AppString.summaryInsight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.summaryInsightDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppString.possibleVariations,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: controller.summaryInsightVariations
                  .map((item) => _buildBulletItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Safe Clauses Section ====================
  Widget _buildSafeClausesSection() {
    return _buildSectionCard(
      icon: Icons.verified_outlined,
      iconColor: AppColors.greencheck,
      // iconBgColor: AppColors.greencheck.withOpacity(0.1),
      title: AppString.safeClausesSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.safeClausesDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppString.possibleVariations,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: controller.safeClausesVariations
                  .map((item) => _buildBulletItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Red Flags Section ====================
  Widget _buildRedFlagsSection() {
    return _buildSectionCard(
      icon: Icons.flag_outlined,
      iconColor: Colors.red,
      // iconBgColor: Colors.red.withOpacity(0.1),
      title: AppString.redFlagsSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.redFlagsDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppString.possibleVariations,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: controller.redFlagsVariations
                  .map((item) => _buildBulletItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Warnings Section ====================
  Widget _buildWarningsSection() {
    return _buildSectionCard(
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.orange,
      // iconBgColor: Colors.orange.withOpacity(0.1),
      title: AppString.warningsSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.warningsDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppString.exampleItems,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: controller.warningsItems
                  .map((item) => _buildBulletItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Admin Recommendations ====================
  Widget _buildAdminRecommendations() {
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
          Obx(
            () => Column(
              children: controller.recommendations
                  .map((rec) => _buildBulletItem(rec))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helper Widgets ====================
  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    // required Color iconBgColor,
    required String title,
    required Widget child,
  }) {
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
          // Header
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  // color: iconBgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 15),
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
