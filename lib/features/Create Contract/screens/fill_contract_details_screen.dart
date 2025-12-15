import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Create%20Contract/controllers/create_contract_controller_.dart';
import 'package:rent2rent/features/Create%20Contract/widgets/step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/auth/widgets/custome_textfield.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/admin_recommendation.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class FillContractDetailsScreen extends StatelessWidget {
  FillContractDetailsScreen({super.key});

  final CreateContractController controller =
      Get.find<CreateContractController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(
              title: AppString.createContract,
              type: AppBarType.withSave,
              onSaveTap: () => controller.saveAsDraft(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Step Indicator
                  StepIndicator(currentStep: 2),
                  SizedBox(height: 16.h),

                  // Property Type Tabs
                  _buildPropertyTypeTabs(),
                  SizedBox(height: 20.h),

                  // Landlord Info Section
                  _buildLandlordInfoSection(),
                  SizedBox(height: 16.h),

                  // Tenant Info Section
                  _buildTenantInfoSection(),
                  SizedBox(height: 16.h),

                  // Property Details Section
                  _buildPropertyDetailsSection(),
                  SizedBox(height: 16.h),

                  // Rent Terms Section
                  _buildRentTermsSection(),
                  SizedBox(height: 16.h),

                  // Admin Recommendations
                  AdminRecommendation(controller: controller),
                  SizedBox(height: 24.h),

                  // Save & Generate Contract Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.saveAndGenerateContract,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.generateContract(),
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

  // ==================== Property Type Tabs ====================
  Widget _buildPropertyTypeTabs() {
    return Container(
      height: 47.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2.43,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildPropertyTab(AppString.entireApartment, 'entire_apartment'),
            _buildPropertyTab(AppString.singleRoom, 'single_room'),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTab(String title, String value) {
    final isSelected = controller.propertyType.value == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.propertyType.value = value,
        child: Container(
          margin: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFf6f9ff) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: isSelected ? Border.all(color: AppColors.ash) : null,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.s16w4(
                color: isSelected ? AppColors.neutralS : AppColors.ash,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Landlord Info Section ====================
  Widget _buildLandlordInfoSection() {
    return _buildFormSection(
      title: AppString.landlordInfo,
      children: [
        _buildFormField(
          label: AppString.fullName,
          controller: controller.landlordNameController,
          hint: AppString.enterLandlordFullName,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.address,
          controller: controller.landlordAddressController,
          hint: AppString.enterLandlordAddress,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.contactEmail,
          controller: controller.landlordEmailController,
          hint: AppString.exampleEmail,
        ),
      ],
    );
  }

  // ==================== Tenant Info Section ====================
  Widget _buildTenantInfoSection() {
    return _buildFormSection(
      title: AppString.tenantInfo,
      children: [
        _buildFormField(
          label: AppString.fullName,
          controller: controller.tenantNameController,
          hint: AppString.enterTenantFullName,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.address,
          controller: controller.tenantAddressController,
          hint: AppString.enterTenantAddress,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.contactEmail,
          controller: controller.tenantEmailController,
          hint: AppString.exampleEmail,
        ),
      ],
    );
  }

  // ==================== Property Details Section ====================
  Widget _buildPropertyDetailsSection() {
    return _buildFormSection(
      title: AppString.propertyDetails,
      children: [
        _buildFormField(
          label: AppString.propertyAddress,
          controller: controller.propertyAddressController,
          hint: AppString.enterPropertyAddress,
        ),
        SizedBox(height: 12.h),
        _buildDropdownField(
          label: AppString.roomCount,
          value: controller.roomCount,
          items: ['1 Room', '2 Rooms', '3 Rooms', '4 Rooms', '5+ Rooms'],
        ),
        SizedBox(height: 12.h),
        _buildFurnishedField(),
      ],
    );
  }

  // ==================== Rent Terms Section ====================
  Widget _buildRentTermsSection() {
    return _buildFormSection(
      title: AppString.rentTerms,
      children: [
        _buildDropdownField(
          label: AppString.numberOfBeds,
          value: controller.numberOfBeds,
          items: ['1 Bed', '2 Beds', '3 Beds', '4 Beds', '5+ Beds'],
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.monthlyRent,
          controller: controller.monthlyRentController,
          hint: AppString.egRent,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.deposit,
          controller: controller.depositController,
          hint: AppString.egDeposit,
        ),
        SizedBox(height: 12.h),
        _buildFormField(
          label: AppString.contractDuration,
          controller: controller.contractDurationController,
          hint: AppString.exampleEmail,
        ),
        SizedBox(height: 12.h),
        _buildDateField(
          label: AppString.startDate,
          selectedDate: controller.startDate,
        ),
        SizedBox(height: 12.h),
        _buildCheckboxField(),
      ],
    );
  }

  // ==================== Form Section Container ====================
  Widget _buildFormSection({
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  // ==================== Form Field ====================
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

  // ==================== Dropdown Field ====================
  Widget _buildDropdownField({
    required String label,
    required RxString value,
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
              border: Border.all(color: AppColors.primary, width: 0.5),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value.isEmpty ? null : value.value,
                hint: Text(
                  items.first,
                  style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.neutralS,
                  size: 30,
                ),
                items: items.map((item) {
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
                onChanged: (newValue) => value.value = newValue ?? '',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Furnished Field ====================
  Widget _buildFurnishedField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppString.furnished,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Row(
            children: [
              _buildRadioOption(AppString.yes, true),
              SizedBox(width: 24.w),
              _buildRadioOption(AppString.no, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, bool value) {
    final isSelected = controller.isFurnished.value == value;
    return GestureDetector(
      onTap: () => controller.isFurnished.value = value,
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

  // ==================== Date Field ====================
  Widget _buildDateField({
    required String label,
    required Rx<DateTime?> selectedDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => controller.selectStartDate(),
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
                    selectedDate.value != null
                        ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}'
                        : AppString.selectStartDate,
                    style: AppTextStyle.s16w4(
                      color: selectedDate.value != null
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
        ),
      ],
    );
  }

  // ==================== Checkbox Field ====================
  Widget _buildCheckboxField() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.confirmDetails.toggle(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: controller.confirmDetails.value
                    ? AppColors.primary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  width: 2,
                  color: controller.confirmDetails.value
                      ? AppColors.primary
                      : AppColors.ash,
                ),
              ),
              child: controller.confirmDetails.value
                  ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                AppString.confirmContractDetails,
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
}
