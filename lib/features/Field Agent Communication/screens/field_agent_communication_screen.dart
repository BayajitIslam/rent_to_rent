import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/controllers/field_agent_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/admin_recommendation.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class FieldAgentCommunicationScreen extends StatelessWidget {
  FieldAgentCommunicationScreen({super.key});

  final FieldAgentController controller = Get.find<FieldAgentController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar Section
            CustomAppBar(title: AppString.fieldAgentCommunicationTitle),

            // Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppString.createAProfessionalMessage,
                      style: AppTextStyle.s16w4(
                        color: AppColors.ash,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Create Agent Inquiry Section
                  _buildCreateAgentInquiry(),
                  SizedBox(height: 16.h),

                  // Admin Recommendations Section
                  AdminRecommendation(controller: controller),
                  SizedBox(height: 100.h), // Bottom padding for navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Create Agent Inquiry ====================
  Widget _buildCreateAgentInquiry() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            AppString.replyToTenant,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),

          // Property Link Field
          _buildLabel(AppString.incomingEmail),
          SizedBox(height: 8.h),
          CustomeTextfield(
            radius: 8,
            height: 160.h,
            maxLines: 5,
            controller: controller.incomingEmailController,
            hintText: AppString.pasteEmail,
          ),
          SizedBox(height: 4.h),

          SizedBox(height: 12.h),

          // Notes Field
          _buildLabel(AppString.replyInstructions),
          SizedBox(height: 8.h),
          CustomeTextfield(
            radius: 8,
            height: 160.h,
            maxLines: 5,
            controller: controller.notesController,
            hintText: AppString.enterYourText,
          ),
          SizedBox(height: 16.h),

          // Ask AI Button
          Obx(
            () => CustomButton(
              buttonHeight: 39,
              buttonName: AppString.generateReply,
              isloading: controller.isGenerateReplyLoading.value,
              onTap: () => controller.generateReply(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
    );
  }
}
