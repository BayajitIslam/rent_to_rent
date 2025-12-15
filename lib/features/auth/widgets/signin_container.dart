import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/auth_controller..dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';
import 'package:rent2rent/routes/routes_name.dart';

class SigninContainer extends StatelessWidget {
  final AuthController controller;
  const SigninContainer({super.key, required this.controller});

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
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            AppString.buyRentSale,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 18),
          ),
          SizedBox(height: 24.h),

          // Email Field
          CustomeTextfield(
            controller: controller.loginEmailController,
            hintText: AppString.email,
          ),
          SizedBox(height: 20.h),

          // Password Field
          Obx(
            () => CustomeTextfield(
              controller: controller.loginPasswordController,
              hintText: AppString.password,
              isPassword: true,
              obscureText: controller.obscurePassword.value,
              onToggleVisibility: () => controller.obscurePassword.toggle(),
            ),
          ),
          SizedBox(height: 16.h),

          // Remember Me & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember Me Checkbox
              Obx(
                () => GestureDetector(
                  onTap: () => controller.rememberMe.toggle(),
                  child: Row(
                    children: [
                      Container(
                        width: 17.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                          color: controller.rememberMe.value
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(
                            color: controller.rememberMe.value
                                ? AppColors.primary
                                : AppColors.neutralS,
                            width: 1.5,
                          ),
                        ),
                        child: controller.rememberMe.value
                            ? Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 14.sp,
                              )
                            : null,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppString.rememberMe,
                        style: AppTextStyle.s16w4(
                          color: AppColors.neutralS,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Forgot Password
              GestureDetector(
                onTap: () => Get.toNamed(RoutesName.forgotPassword),
                child: Text(
                  AppString.forgotPassword,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontSize: 14,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Sign In Button
          Obx(
            () => CustomButton(
              buttonName: AppString.signIn,
              isloading: controller.isLoading.value,
              onTap: () => controller.signIn(),
            ),
          ),
        ],
      ),
    );
  }
}
