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
                        childAspectRatio: 0.58,
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
        decoration: BoxDecoration(
          // color: AppColors.white,
          // boxShadow: [BoxShadow(color: const Color(0XffE4E4E4), blurRadius: 8)],
        ),
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Contract Preview Image Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2.5)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        contractType.previewImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Contract Type Name
                Text(
                  contractType.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s16w4(
                    color: AppColors.neutralS,

                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
      return Container(
        // width: 24.w,
        // height: 24.h,
        // decoration: BoxDecoration(
        //   color: AppColors.white,
        //   shape: BoxShape.circle,
        //   border: Border.all(color: AppColors.primary, width: 2),
        // ),
      );
    }
  }
}
