import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/controllers/agent_reply_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

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
                  SizedBox(height: 100.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(
                      // () => CustomButton(
                      //   buttonHeight: 39,
                      //   buttonName: ,
                      //   isloading: controller.isRegenerateLoading.value,
                      //   onTap: () {},
                      // ),
                      () => SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(AppString.generateFirstContract),
                        ),
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
          // Section Title
          Text(
            'Ai Generated Reply',
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),

          // Description
          Text(
            """Hello [Agent Name],

I hope you’re doing well.

My name is [User Name], and I represent a professional Rent2Rent operation. 
We work with property owners to manage long-term and special-purpose rentals 
with full compliance and reliable monthly payments.

I came across your listing and would be happy to discuss whether this property 
could be a good fit for our model.

Looking forward to your reply.

Kind regards,
[User Name""",
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
          ),
          SizedBox(height: 16.h),

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
}
