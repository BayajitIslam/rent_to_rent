import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';
import 'package:rent2rent/features/Create%20Contract/widgets/step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class LocationSuitabilityScreen extends StatelessWidget {
  LocationSuitabilityScreen({super.key});

  final LocationSuitabilityController controller =
      Get.find<LocationSuitabilityController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.locationSuitability),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Step Indicator
                  StepIndicator(
                    currentStep: 1,
                    titles: [
                      'Select Your\nPreferences',
                      'Landlord info & property details',
                      'Result Page',
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Category Types Section
                  Text(
                    AppString.categoryTypes,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppString.selectCategories,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Category Checkboxes
                  _buildCategoryCheckboxes(),
                  SizedBox(height: 24.h),

                  // Analyze Location Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 50,
                      buttonName: AppString.next,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.goToStep2(),
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

  Widget _buildCategoryCheckboxes() {
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            Expanded(
              child: _buildCategoryCheckbox(
                AppString.seniorLivingWG,
                controller.seniorLivingWG,
              ),
            ),
            Expanded(
              child: _buildCategoryCheckbox(
                AppString.seniorLivingWG,
                controller.seniorLivingWG2,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Row 2
        Row(
          children: [
            Expanded(
              child: _buildCategoryCheckbox(
                AppString.students,
                controller.students,
              ),
            ),
            Expanded(
              child: _buildCategoryCheckbox(
                AppString.airbnbOptional,
                controller.airbnbOptional,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Row 3
        Row(
          children: [
            Expanded(
              child: _buildCategoryCheckbox(
                AppString.engineerHousing,
                controller.engineerHousing,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCheckbox(String label, RxBool value) {
    return Obx(
      () => GestureDetector(
        onTap: () => value.toggle(),
        child: Row(
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: value.value ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(
                  color: value.value ? AppColors.primary : AppColors.neutralS,
                  width: 2,
                ),
              ),
              child: value.value
                  ? Icon(Icons.check, color: AppColors.white, size: 12.sp)
                  : null,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
