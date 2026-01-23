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
            CustomAppBar(title: AppString.contractAnalysisReport),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // overall rating - always show
                    _buildOverallRating(),
                    SizedBox(height: 16.h),

                    // contract summary
                    if (controller.contractSummary.value.isNotEmpty) ...[
                      _buildContractSummarySection(),
                      SizedBox(height: 14.h),
                    ],

                    // summary insight
                    if (controller.summaryInsightDescription.value.isNotEmpty ||
                        controller.summaryInsightVariations.isNotEmpty) ...[
                      _buildSummaryInsightSection(),
                      SizedBox(height: 14.h),
                    ],

                    // safe clauses
                    if (controller.safeClausesDescription.value.isNotEmpty ||
                        controller.safeClausesVariations.isNotEmpty) ...[
                      _buildSafeClausesSection(),
                      SizedBox(height: 14.h),
                    ],

                    // red flags
                    if (controller.redFlagsDescription.value.isNotEmpty ||
                        controller.redFlagsVariations.isNotEmpty) ...[
                      _buildRedFlagsSection(),
                      SizedBox(height: 14.h),
                    ],

                    // warnings
                    if (controller.warningsDescription.value.isNotEmpty ||
                        controller.warningsItems.isNotEmpty) ...[
                      _buildWarningsSection(),
                      SizedBox(height: 14.h),
                    ],

                    // admin recommendations
                    if (controller.recommendations.isNotEmpty) ...[
                      _buildAdminRecommendations(),
                      SizedBox(height: 24.h),
                    ],

                    // regenerate button
                    CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.regenerateAnalysis,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.analyzeContract(),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  color: _getRatingColor(controller.overallRatingColor.value),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                controller.overallRating.value.isNotEmpty
                    ? controller.overallRating.value
                    : 'N/A',
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(String color) {
    switch (color.toLowerCase()) {
      case 'green':
        return AppColors.greencheck;
      case 'red':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  Widget _buildContractSummarySection() {
    return _buildSectionCard(
      icon: Icons.check_box,
      iconColor: AppColors.greencheck,
      title: AppString.contractSummaryRiskAnalysis,
      child: Text(
        controller.contractSummary.value,
        style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
      ),
    );
  }

  Widget _buildSummaryInsightSection() {
    return _buildSectionCard(
      icon: Icons.lightbulb_outline,
      iconColor: Colors.amber,
      title: AppString.summaryInsight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.summaryInsightDescription.value.isNotEmpty)
            Text(
              controller.summaryInsightDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          if (controller.summaryInsightDescription.value.isNotEmpty &&
              controller.summaryInsightVariations.isNotEmpty)
            SizedBox(height: 12.h),
          if (controller.summaryInsightVariations.isNotEmpty) ...[
            Text(
              AppString.possibleVariations,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ...controller.summaryInsightVariations.map(
              (item) => _buildBulletItem(item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSafeClausesSection() {
    return _buildSectionCard(
      icon: Icons.verified_outlined,
      iconColor: AppColors.greencheck,
      title: AppString.safeClausesSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.safeClausesDescription.value.isNotEmpty)
            Text(
              controller.safeClausesDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          if (controller.safeClausesDescription.value.isNotEmpty &&
              controller.safeClausesVariations.isNotEmpty)
            SizedBox(height: 12.h),
          if (controller.safeClausesVariations.isNotEmpty) ...[
            Text(
              AppString.possibleVariations,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ...controller.safeClausesVariations.map(
              (item) => _buildBulletItem(item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRedFlagsSection() {
    return _buildSectionCard(
      icon: Icons.flag_outlined,
      iconColor: Colors.red,
      title: AppString.redFlagsSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.redFlagsDescription.value.isNotEmpty)
            Text(
              controller.redFlagsDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          if (controller.redFlagsDescription.value.isNotEmpty &&
              controller.redFlagsVariations.isNotEmpty)
            SizedBox(height: 12.h),
          if (controller.redFlagsVariations.isNotEmpty) ...[
            Text(
              AppString.possibleVariations,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ...controller.redFlagsVariations.map(
              (item) => _buildBulletItem(item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWarningsSection() {
    return _buildSectionCard(
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.orange,
      title: AppString.warningsSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.warningsDescription.value.isNotEmpty)
            Text(
              controller.warningsDescription.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
              ),
            ),
          if (controller.warningsDescription.value.isNotEmpty &&
              controller.warningsItems.isNotEmpty)
            SizedBox(height: 12.h),
          if (controller.warningsItems.isNotEmpty) ...[
            Text(
              AppString.exampleItems,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ...controller.warningsItems.map((item) => _buildBulletItem(item)),
          ],
        ],
      ),
    );
  }

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
          ...controller.recommendations.map((rec) => _buildBulletItem(rec)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
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
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
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
