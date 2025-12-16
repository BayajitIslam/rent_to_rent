import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
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

                  // Background Image Section Title
                  Text(
                    AppString.backgroundImage,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Background Image Grid - 4 images (2x2)
                  GetBuilder<LocationSuitabilityController>(
                    builder: (ctrl) => GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.58,
                      ),
                      itemCount: ctrl.backgroundImages.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            ctrl.selectedBackgroundIndex.value == index;
                        return _buildBackgroundImageCard(index, isSelected);
                      },
                    ),
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
                      buttonName: AppString.analyzeLocation,
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

  Widget _buildBackgroundImageCard(int index, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectBackgroundImage(index),
      child: Container(
        height: 244.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2.5)
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                isSelected
                    ? AppImage.locationBackround
                    : controller.backgroundImages[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Selection Indicator - Top Right
            Positioned(
              top: 12.h,
              right: 12.w,
              child: _buildSelectionIndicator(isSelected),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    if (isSelected) {
      return Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: AppColors.white, size: 16.sp),
      );
    } else {
      return Container();
    }
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
