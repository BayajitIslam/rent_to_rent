import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Create%20Contract/controllers/create_contract_controller_.dart';
import 'package:rent2rent/features/Create%20Contract/models/contract_type_model.dart';
import 'package:rent2rent/features/Create%20Contract/widgets/step_indicator.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class SelectContractTypeScreen extends StatelessWidget {
  SelectContractTypeScreen({super.key});

  final CreateContractController controller =
      Get.find<CreateContractController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.createContract),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Step Indicator
                  StepIndicator(currentStep: 1),
                  SizedBox(height: 24.h),

                  // Section Title
                  Text(
                    AppString.selectContractType,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Contract Type Grid - Using GetBuilder
                  GetBuilder<CreateContractController>(
                    builder: (ctrl) => GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 3.9,
                      ),
                      itemCount: ctrl.contractTypes.length,
                      itemBuilder: (context, index) {
                        final contractType = ctrl.contractTypes[index];
                        final isSelected =
                            ctrl.selectedContractType.value == contractType.id;
                        return _buildContractTypeCard(contractType, isSelected);
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Save & Next Button
                  Obx(
                    () => CustomButton(
                      buttonHeight: 48,
                      buttonName: AppString.saveAndNext,
                      isloading: controller.isLoading.value,
                      onTap: () => controller.goToFillContractDetails(),
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

  Widget _buildContractTypeCard(
    ContractTypeModel contractType,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => controller.selectContractType(contractType.id),
      child: Container(
        // Padding and margin to match the spacing in the screenshot
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          // Adding the border around the entire card
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.whiteBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Radio-style selection indicator
            _buildSelectionIndicator(isSelected),

            SizedBox(width: 12.w),

            // Contract Type Name
            Expanded(
              child: Text(
                contractType.name,
                style: AppTextStyle.s16w4(
                  color: AppColors.neutralS,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return Container(
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.neutralS,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
