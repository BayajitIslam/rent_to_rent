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

class CompanyInfoScreen extends StatelessWidget {
  CompanyInfoScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // AppBar
          CustomAppBar(title: AppString.companyInformation),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Company Name
                  _buildLabel(AppString.companyName),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.companyNameController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Company Address
                  _buildLabel(AppString.companyAddress),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.companyAddressController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // Email
                  _buildLabel(AppString.email),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.companyEmailController,
                    hintText: AppString.enterHere,
                  ),
                  SizedBox(height: 16.h),

                  // VAT Number
                  _buildLabel(AppString.vatNumber),
                  SizedBox(height: 8.h),
                  CustomeTextfield(
                    controller: controller.vatNumberController,
                    hintText: AppString.enterVatNumber,
                  ),

                  Spacer(),

                  // Save Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.save,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.saveCompanyInfo(),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: AppTextStyle.s16w4(color: AppColors.neutralS));
  }
}
