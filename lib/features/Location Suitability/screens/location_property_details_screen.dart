import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';
import 'package:rent2rent/features/Location%20Suitability/widgets/location_step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class LocationPropertyDetailsScreen extends StatelessWidget {
  LocationPropertyDetailsScreen({super.key});

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
                  LocationStepIndicator(currentStep: 2),
                  SizedBox(height: 24.h),

                  // Area Section
                  _buildAreaSection(),
                  SizedBox(height: 16.h),

                  // Infrastructure Section
                  _buildInfrastructureSection(),
                  SizedBox(height: 16.h),

                  // Rent2Rent Potential Section
                  _buildRent2RentPotentialSection(),
                  SizedBox(height: 24.h),

                  // Analyze Location Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 50,
                      buttonName: AppString.analyzeLocation,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.analyzeLocation(),
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

  // ==================== Area Section ====================
  Widget _buildAreaSection() {
    return _buildSection(
      title: 'Area',
      children: [
        _buildDropdownField(
          label: 'City size',
          selectedValue: controller.citySize,
          items: ['Major city', 'Medium city', 'Small city', 'Rural area'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'District type',
          selectedValue: controller.districtType,
          items: ['Central', 'Suburban', 'Outskirts', 'Industrial'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'Demand profile',
          selectedValue: controller.demandProfile,
          items: ['Business', 'Tourist', 'Student', 'Residential'],
        ),
      ],
    );
  }

  // ==================== Infrastructure Section ====================
  Widget _buildInfrastructureSection() {
    return _buildSection(
      title: 'Infrastructure',
      children: [
        _buildDropdownField(
          label: 'Public transport within walking distance',
          selectedValue: controller.publicTransport,
          items: ['Yes', 'No'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'Supermarkets / Restaurants nearby',
          selectedValue: controller.supermarketsNearby,
          items: ['Yes', 'No'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label:
              'Universities, hospitals, offices, or tourist attractions nearby',
          selectedValue: controller.attractionsNearby,
          items: ['Yes', 'No'],
        ),
      ],
    );
  }

  // ==================== Rent2Rent Potential Section ====================
  Widget _buildRent2RentPotentialSection() {
    return _buildSection(
      title: 'Rent2Rent Potential',
      children: [
        _buildDropdownField(
          label: 'Local demand',
          selectedValue: controller.localDemand,
          items: ['Low', 'Medium', 'High'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'Competition level',
          selectedValue: controller.competitionLevel,
          items: ['Low', 'Medium', 'High'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'Typical short-term rental prices',
          selectedValue: controller.rentalPrices,
          items: ['Low', 'Medium', 'High'],
        ),
        SizedBox(height: 16.h),
        _buildDropdownField(
          label: 'Regulatory friendliness',
          selectedValue: controller.regulatoryFriendliness,
          items: ['Low', 'Medium', 'High'],
        ),
      ],
    );
  }

  // ==================== Helper Widgets ====================
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE4E4E4),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required RxString selectedValue,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue.value.isEmpty ? null : selectedValue.value,
                hint: Text(
                  items.first,
                  style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.neutralS,
                  size: 24.sp,
                ),
                dropdownColor: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyle.s16w4(
                        color: AppColors.neutralS,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedValue.value = newValue;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
