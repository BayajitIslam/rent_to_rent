import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class HelpFeedbackScreen extends StatelessWidget {
  HelpFeedbackScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // AppBar
          CustomAppBar(title: AppString.helpAndFeedback),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Submit a Ticket Section
                Text(
                  AppString.submitATicket,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),

                // Description Field
                Container(
                  height: 181.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 0.5),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: TextField(
                    controller: controller.feedbackDescriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: AppString.describeYourIssue,
                      hintStyle: AppTextStyle.s16w4(
                        color: AppColors.ash,
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.all(16.r),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Submit Button
                Obx(
                  () => CustomButton(
                    buttonHeight: 48,
                    buttonName: AppString.submit,
                    isloading: controller.isLoading.value,
                    onTap: () => controller.submitFeedback(),
                  ),
                ),
                SizedBox(height: 30.h),

                // Need More Help Section
                Text(
                  AppString.needMoreHelp,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),

                // Call Us Card
                _buildCallUsCard(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallUsCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.deepBlue),
      ),
      child: Row(
        children: [
          // Phone Icon
          SizedBox(
            width: 46.w,
            height: 46.h,
            child: SvgPicture.asset(AppImage.customerSupport),
          ),
          SizedBox(width: 14.w),

          // Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.callUs,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppString.helpLineActive,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
