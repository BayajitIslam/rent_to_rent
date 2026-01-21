import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/auth_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';

class ResetPasswordContainer extends StatelessWidget {
  final AuthController controller;
  const ResetPasswordContainer({super.key, required this.controller});

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
            AppString.setNewPassword,
            textAlign: TextAlign.center,
            style: AppTextStyle.s24w5(),
          ),
          SizedBox(height: 12.h),

          // Subtitle
          Text(
            AppString.setNewPasswordSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
          ),
          SizedBox(height: 24.h),

          // New Password Field
          Obx(
            () => CustomeTextfield(
              controller: controller.newPasswordController,
              hintText: AppString.newPassword,
              isPassword: true,
              obscureText: !controller.isNewPasswordVisible.value,
              onToggleVisibility: () =>
                  controller.toggleNewPasswordVisibility(),
            ),
          ),
          SizedBox(height: 20.h),

          // Retype New Password Field
          Obx(
            () => CustomeTextfield(
              controller: controller.confirmNewPasswordController,
              hintText: AppString.retypeNewPassword,
              isPassword: true,
              obscureText: !controller.isConfirmNewPasswordVisible.value,
              onToggleVisibility: () =>
                  controller.toggleConfirmNewPasswordVisibility(),
            ),
          ),
          SizedBox(height: 24.h),

          // Reset Password Button
          Obx(
            () => CustomButton(
              buttonName: AppString.resetPassword,
              isloading: controller.isLoading.value,
              onTap: () => controller.resetPassword(),
            ),
          ),
        ],
      ),
    );
  }
}
