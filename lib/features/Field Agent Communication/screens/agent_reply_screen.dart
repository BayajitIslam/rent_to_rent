import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/Field%20Agent%20Communication/controllers/agent_reply_controller.dart';
import 'package:template/features/auth/widgets/custom_button.dart';
import 'package:template/features/home/screens/main_layout.dart';
import 'package:template/features/home/widgets/custome_appbar.dart';

class AgentReplyScreen extends StatelessWidget {
  AgentReplyScreen({super.key});

  final AgentReplyController controller = Get.find<AgentReplyController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar Section
            CustomAppBar(title: AppString.agentReply),

            // Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Agent Inquiry Response Section
                  _buildAgentInquiryResponse(),
                  SizedBox(height: 100.h), // Bottom padding for navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentInquiryResponse() {
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
          // Section Title
          Text(
            AppString.agentInquiry,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),

          // Description
          Text(
            AppString.agentInquiryDesc,
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
          ),
          SizedBox(height: 16.h),

          // AI Says Title
          Text(
            AppString.aiSays,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),

          // AI Response
          Obx(
            () => Text(
              controller.aiResponse.value,
              style: AppTextStyle.s16w4(
                color: AppColors.neutralS,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Key Highlights Section
          Text(
            AppString.keyHighlights,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),

          // Highlights List
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.keyHighlights
                  .map((highlight) => _buildHighlightItem(highlight))
                  .toList(),
            ),
          ),
          SizedBox(height: 24.h),

          // Regenerate Button
          Obx(
            () => CustomButton(
              buttonHeight: 39,
              buttonName: AppString.regenerate,
              isloading: controller.isRegenerateLoading.value,
              onTap: () => controller.regenerate(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 8.w),
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
}
