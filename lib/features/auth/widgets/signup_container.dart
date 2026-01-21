import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/auth_controller.dart';
import 'package:rent2rent/features/auth/widgets/build_tab_widget.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';

class SignUpContainer extends StatelessWidget {
  final AuthController controller;
  const SignUpContainer({super.key, required this.controller});

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
            AppString.wellcomeToRent2Rent,
            textAlign: TextAlign.center,
            style: AppTextStyle.s24w5(),
          ),

          SizedBox(height: 20.h),
          Text(
            AppString.signUpToGetStarted,
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 18),
          ),
          SizedBox(height: 24.h),

          // Toggle Buttons
          _buildToggleTabs(),
          SizedBox(height: 20.h),

          // Full Name Field
          CustomeTextfield(
            controller: controller.fullNameController,
            hintText: AppString.fullName,
          ),
          SizedBox(height: 20.h),

          // Email/Phone Field
          CustomeTextfield(
            controller: controller.emailPhoneController,
            hintText: AppString.emailPhoneNumber,
          ),
          SizedBox(height: 20.h),

          // Password Field
          Obx(
            () => CustomeTextfield(
              controller: controller.passwordController,
              hintText: AppString.password,
              isPassword: true,
              obscureText: controller.obscurePassword.value,
              onToggleVisibility: () => controller.obscurePassword.toggle(),
            ),
          ),
          SizedBox(height: 24.h),

          // Sign Up Button
          Obx(
            () => CustomButton(
              buttonName: AppString.signup,
              isloading: controller.isLoading.value,
              onTap: () => controller.signUp(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12..r,
            spreadRadius: 2.45,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            BuildTabWidget(
              title: AppString.individuals,
              isActive: controller.isIndividual.value,
              onTap: () => controller.isIndividual.value = true,
            ),
            BuildTabWidget(
              title: AppString.company,
              isActive: !controller.isIndividual.value,
              onTap: () => controller.isIndividual.value = false,
            ),
          ],
        ),
      ),
    );
  }
}
