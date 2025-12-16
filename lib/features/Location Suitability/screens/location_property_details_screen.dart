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

                  // Landlord Info Section
                  _buildLandlordInfoSection(),
                  SizedBox(height: 16.h),

                  // Property Information Section
                  _buildPropertyInformationSection(),
                  SizedBox(height: 16.h),

                  // Local Amenities Section
                  _buildLocalAmenitiesSection(),
                  SizedBox(height: 16.h),

                  // Additional Attributes Section
                  _buildAdditionalAttributesSection(),
                  SizedBox(height: 16.h),

                  // Monthly Rent Section
                  _buildMonthlyRentSection(),
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

  // ==================== Landlord Info Section ====================
  Widget _buildLandlordInfoSection() {
    return _buildSection(
      title: AppString.landlordInfo,
      children: [
        _buildFormField(
          label: AppString.name,
          controller: controller.nameController,
          hint: 'Enter your name ',
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.phone,
          controller: controller.phoneController,
          hint: 'Enter Phone Number',
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.email,
          controller: controller.emailController,
          hint: 'example@gmail.com',
        ),
      ],
    );
  }

  // ==================== Property Information Section ====================
  Widget _buildPropertyInformationSection() {
    return _buildSection(
      title: AppString.propertyInformation,
      children: [
        _buildFormField(
          label: AppString.address,
          controller: controller.addressController,
          hint: AppString.enterPropertyAddress,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.approxSquareMeters,
          controller: controller.squareMetersController,
          hint: 'e.g. 65',
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.numberOfRooms,
          controller: controller.numberOfRoomsController,
          hint: 'e.g. 3',
        ),
        SizedBox(height: 12.h),
        _buildWalkthroughRoomField(),
      ],
    );
  }

  Widget _buildWalkthroughRoomField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.walkthroughRoom,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Row(
            children: [
              _buildRadioOption(
                AppString.yes,
                true,
                controller.walkthroughRoom,
              ),
              SizedBox(width: 100.w),
              _buildRadioOption(
                AppString.no,
                false,
                controller.walkthroughRoom,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Local Amenities Section ====================
  Widget _buildLocalAmenitiesSection() {
    return _buildSection(
      title: AppString.localAmenitiesAtAGlance,
      children: [
        _buildCheckboxItem(
          AppString.universityWithin10Minutes,
          controller.universityWithin10Min,
        ),
        SizedBox(height: 8.h),
        _buildCheckboxItem(
          AppString.groceryStoreWithin10Minutes,
          controller.groceryStoreWithin10Min,
        ),
        SizedBox(height: 8.h),
        _buildCheckboxItem(
          AppString.hospitalWithin10Minutes,
          controller.hospitalWithin10Min,
        ),
        SizedBox(height: 8.h),
        _buildCheckboxItem(
          AppString.publicTransportWithin10Minutes,
          controller.publicTransportWithin10Min,
        ),
      ],
    );
  }

  // ==================== Additional Attributes Section ====================
  Widget _buildAdditionalAttributesSection() {
    return _buildSection(
      title: AppString.additionalAttributes,
      children: [
        _buildCheckboxItem(
          AppString.goodResidentialArea,
          controller.goodResidentialArea,
        ),
        SizedBox(height: 8.h),
        _buildCheckboxItem(AppString.basicArea, controller.basicArea),
        SizedBox(height: 8.h),
        _buildCheckboxItem(AppString.groundFloor, controller.groundFloor),
        SizedBox(height: 8.h),
        _buildCheckboxItem(
          AppString.elevatorAvailable,
          controller.elevatorAvailable,
        ),
        SizedBox(height: 8.h),
        _buildCheckboxItem(AppString.barrierFree, controller.barrierFree),
      ],
    );
  }

  // ==================== Monthly Rent Section ====================
  Widget _buildMonthlyRentSection() {
    return _buildSection(
      title: AppString.monthlyRent,
      children: [
        // Flat Rate Radio
        Obx(
          () => _buildRadioCheckItem(
            AppString.flatRate,
            controller.flatRate.value,
            () {
              controller.flatRate.value = true;
              controller.plusUtilities.value = false;
            },
          ),
        ),
        SizedBox(height: 8.h),

        // Plus Utilities Radio
        Obx(
          () => _buildRadioCheckItem(
            AppString.plusUtilities,
            controller.plusUtilities.value,
            () {
              controller.plusUtilities.value = true;
              controller.flatRate.value = false;
            },
          ),
        ),
        SizedBox(height: 12.h),

        // Utilities Amount Field
        Obx(
          () => controller.plusUtilities.value
              ? CustomeTextfield(
                  controller: controller.utilitiesAmountController,
                  hintText: AppString.enterUtilitiesAmount,
                )
              : SizedBox.shrink(),
        ),
        SizedBox(height: 16.h),

        // Contract End Date
        Text(
          AppString.contractEndDate,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        _buildDateField(),
        SizedBox(height: 16.h),

        // Reason for Contract Limitation
        Text(
          AppString.reasonForContractLimitation,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(
          controller: controller.reasonController,
          hintText: AppString.typeHere,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => controller.selectContractEndDate(),
      child: Obx(
        () => Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 0.5),
            borderRadius: BorderRadius.circular(44.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.contractEndDate.value != null
                    ? '${controller.contractEndDate.value!.day}/${controller.contractEndDate.value!.month}/${controller.contractEndDate.value!.year}'
                    : AppString.pickTheDate,
                style: AppTextStyle.s16w4(
                  color: controller.contractEndDate.value != null
                      ? AppColors.neutralS
                      : AppColors.ash,
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.neutralS,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
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
        boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 16)],
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        CustomeTextfield(controller: controller, hintText: hint),
      ],
    );
  }

  Widget _buildCheckboxItem(String label, RxBool value) {
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
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label, bool value, RxBool selectedValue) {
    final isSelected = selectedValue.value == value;
    return GestureDetector(
      onTap: () => selectedValue.value = value,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.ash,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioCheckItem(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.ash,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 10.w),
          Text(
            label,
            style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
