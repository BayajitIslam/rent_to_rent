import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';
import 'package:rent2rent/features/Location%20Suitability/widgets/location_step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';
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
            // appbar
            CustomAppBar(title: AppString.locationSuitability),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // step indicator
                  LocationStepIndicator(currentStep: 2),
                  SizedBox(height: 24.h),

                  // area section
                  _buildAreaSection(),
                  SizedBox(height: 16.h),

                  // infrastructure section
                  _buildInfrastructureSection(),
                  SizedBox(height: 16.h),

                  // rent2rent potential section
                  _buildRent2RentPotentialSection(),
                  SizedBox(height: 24.h),

                  // analyze location button
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

  // area section
  Widget _buildAreaSection() {
    return _buildSection(
      title: 'Area',
      children: [
        Text(
          'City size',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Large city (500k+)',
          controller: controller.citySizeController,
        ),
        SizedBox(height: 16.h),
        Text(
          'District type',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Central / well connected',
          controller: controller.districtTypeController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Demand profile',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. High demand from students and young professionals',
          controller: controller.demandProfileController,
        ),
      ],
    );
  }

  // infrastructure section
  Widget _buildInfrastructureSection() {
    return _buildSection(
      title: 'Infrastructure',
      children: [
        Text(
          'Public transport within walking distance',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. U-Bahn within 5 minutes',
          controller: controller.publicTransportController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Supermarkets / Restaurants nearby',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Many nearby',
          controller: controller.supermarketsNearbyController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Universities, hospitals, offices nearby',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. University and hospital within 15 minutes',
          controller: controller.attractionsNearbyController,
        ),
      ],
    );
  }

  // rent2rent potential section
  Widget _buildRent2RentPotentialSection() {
    return _buildSection(
      title: 'Rent2Rent Potential',
      children: [
        Text(
          'Local demand',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Strong year-round',
          controller: controller.localDemandController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Competition level',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Medium',
          controller: controller.competitionLevelController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Typical short-term rental prices',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. 90-140 EUR/night',
          controller: controller.rentalPricesController,
        ),
        SizedBox(height: 16.h),
        Text(
          'Regulatory friendliness',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          hintText: 'e.g. Moderate',
          controller: controller.regulatoryFriendlinessController,
        ),
      ],
    );
  }

  // section container
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
}
