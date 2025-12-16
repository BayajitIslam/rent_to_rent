import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // AppBar
          CustomAppBar(title: AppString.changePassword),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                // Title
                Text(
                  AppString.setYourNewPassword,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),

                // New Password Field
                _buildPasswordField(
                  controller: controller.newPasswordController,
                  hint: AppString.newPassword,
                  obscureValue: controller.obscureNewPassword,
                  onToggle: controller.toggleNewPasswordVisibility,
                ),
                SizedBox(height: 16.h),

                // Retype Password Field
                _buildPasswordField(
                  controller: controller.retypePasswordController,
                  hint: AppString.retypePassword,
                  obscureValue: controller.obscureRetypePassword,
                  onToggle: controller.toggleRetypePasswordVisibility,
                ),
                SizedBox(height: 32.h),

                // Change Password Button
                Obx(
                  () => CustomButton(
                    buttonHeight: 48,
                    buttonName: AppString.changePassword,
                    isloading: controller.isLoading.value,
                    onTap: () => controller.changePassword(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required RxBool obscureValue,
    required VoidCallback onToggle,
  }) {
    return Obx(
      () => Container(
        height: 52.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 0.5),
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureValue.value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 14.h,
            ),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscureValue.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.ash,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
