import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class PersonalInfoScreen extends StatelessWidget {
  PersonalInfoScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.personalInformation),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Full Name
                  _buildLabel(AppString.fullName),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.fullNameController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Phone Number
                  _buildLabel(AppString.phoneNumber),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.phoneController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Email
                  _buildLabel(AppString.email),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.emailController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Address
                  _buildLabel(AppString.address),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.addressController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Photo
                  _buildLabel(AppString.photo),
                  SizedBox(height: 8.h),
                  _buildPhotoUpload(),
                  SizedBox(height: 20.h),

                  // Terms Checkbox
                  _buildTermsCheckbox(),
                  SizedBox(height: 32.h),

                  // Save Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.save,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.savePersonalInfo(),
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

  Widget _buildLabel(String label) {
    return Text(label, style: AppTextStyle.s16w4(color: AppColors.neutralS));
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () => controller.pickProfilePhoto(),
      child: Container(
        height: 51.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 0.5),
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 6.w),
              Text(
                AppString.upload,
                style: AppTextStyle.s16w4(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.agreeToTerms.toggle(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: controller.agreeToTerms.value
                    ? AppColors.primary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(
                  color: controller.agreeToTerms.value
                      ? AppColors.primary
                      : AppColors.ash,
                  width: 1,
                ),
              ),
              child: controller.agreeToTerms.value
                  ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                AppString.agreeToTerms,
                style: AppTextStyle.s16w4(color: AppColors.neutralS),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
