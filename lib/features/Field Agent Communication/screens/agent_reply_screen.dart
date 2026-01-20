import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/controllers/agent_reply_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';

class AgentReplyScreen extends StatelessWidget {
  AgentReplyScreen({super.key});

  // safe controller access
  AgentReplyController get controller {
    if (Get.isRegistered<AgentReplyController>()) {
      return Get.find<AgentReplyController>();
    }
    return Get.put(AgentReplyController());
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // appbar section
            CustomAppBar(title: AppString.agentReply),

            // content section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // agent inquiry response section
                  _buildAgentInquiryResponse(),
                  SizedBox(height: 100.h),

                  // generate first contract button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(AppString.generateFirstContract),
                      ),
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
          // section title with copy button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.subject.value,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // copy button
              GestureDetector(
                onTap: () => _copyToClipboard(),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.copy,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // description with obx wrapper
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

          // regenerate button
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

  // copy message to clipboard
  void _copyToClipboard() {
    if (controller.aiResponse.value.isEmpty) {
      CustomeSnackBar.error('Nothing to copy');
      return;
    }

    Clipboard.setData(ClipboardData(text: controller.aiResponse.value));
    CustomeSnackBar.success('Copied to clipboard');
  }
}
