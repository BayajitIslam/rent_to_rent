import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/auth_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';

class ForgotPasswordContainer extends StatelessWidget {
  final AuthController controller;
  const ForgotPasswordContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 30.h,
        bottom: 43.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            AppString.forgotPassword,
            textAlign: TextAlign.center,
            style: AppTextStyle.s24w5(),
          ),
          SizedBox(height: 12.h),

          // Subtitle
          Text(
            AppString.forgotPasswordSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
          ),
          SizedBox(height: 24.h),

          // Email Field
          CustomeTextfield(
            controller: controller.forgotPasswordEmailController,
            hintText: AppString.email,
          ),
          SizedBox(height: 24.h),

          // Send Code Button
          Obx(
            () => CustomButton(
              buttonName: AppString.sendCode,
              isloading: controller.isLoading.value,
              onTap: () => controller.sendPasswordResetEmail(),
            ),
          ),
        ],
      ),
    );
  }
}
