import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/Field%20Agent%20Communication/controllers/field_agent_controller.dart';
import 'package:template/features/auth/widgets/custom_button.dart';
import 'package:template/features/auth/widgets/custome_textfield.dart';
import 'package:template/features/home/screens/main_layout.dart';
import 'package:template/features/home/widgets/custome_appbar.dart';

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

                  // Create Agent Inquiry Section
                  _buildCreateAgentInquiry(),
                  SizedBox(height: 16.h),

                  // Agent Reply Assistant Section
                  _buildAgentReplyAssistant(),
                  SizedBox(height: 16.h),

                  // Reply to a Tenant Section
                  _buildReplyToTenant(),
                  SizedBox(height: 16.h),

                  // Admin Recommendations Section
                  _buildAdminRecommendations(),
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
            AppString.createAgentInquiry,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),

          // Property Link Field
          _buildLabel(AppString.propertyLink),
          SizedBox(height: 8.h),
          CustomeTextfield(
            controller: controller.propertyLinkController,
            hintText: AppString.typeHere,
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppString.copiedFromOnlineAd,
              style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
            ),
          ),
          SizedBox(height: 12.h),

          // Notes Field
          _buildLabel(AppString.notes),
          SizedBox(height: 8.h),
          CustomeTextfield(
            controller: controller.notesController,
            hintText: AppString.typeHere,
          ),
          SizedBox(height: 16.h),

          // Ask AI Button
          Obx(
            () => CustomButton(
              buttonHeight: 39,
              buttonName: AppString.askAI,
              isloading: controller.isAskAILoading.value,
              onTap: () => controller.askAI(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Agent Reply Assistant ====================
  Widget _buildAgentReplyAssistant() {
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
            AppString.agentReplyAssistant,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppString.aiCreatesInitialOutreach,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
          ),
          SizedBox(height: 16.h),

          // Paste Agent Message Field
          _buildLabel(AppString.pasteAgentMessage),
          SizedBox(height: 8.h),
          CustomeTextfield(
            controller: controller.agentMessageController,
            hintText: AppString.pasteMessageHere,
          ),
          SizedBox(height: 16.h),

          // Generate Friendly First Message Button
          Obx(
            () => CustomButton(
              buttonHeight: 39,
              buttonName: AppString.generateFriendlyFirstMessage,
              isloading: controller.isGenerateMessageLoading.value,
              onTap: () => controller.generateFriendlyMessage(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Reply to a Tenant ====================
  Widget _buildReplyToTenant() {
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

          // Incoming Email Field
          _buildLabel(AppString.incomingEmail),
          SizedBox(height: 8.h),
          CustomeTextfield(
            controller: controller.incomingEmailController,
            hintText: AppString.pasteEmailHere,
          ),
          SizedBox(height: 16.h),

          // Generate Reply Button
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

  // ==================== Admin Recommendations ====================
  Widget _buildAdminRecommendations() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Icon
          Row(
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 1, color: AppColors.primary),
                ),
                child: Text("🟦", style: AppTextStyle.s24w7(fontSize: 16)),
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

          // Recommendations List
          Obx(
            () => Column(
              children: controller.recommendations
                  .map((rec) => _buildRecommendationItem(rec))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
    );
  }
}
