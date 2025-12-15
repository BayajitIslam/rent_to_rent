import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/subscription_controller.dart';
import 'package:rent2rent/features/auth/screens/auth_background_screen.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';

class GetPremiumScreen extends GetView<SubscriptionController> {
  const GetPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                AppString.getPremium,
                style: AppTextStyle.s32w7(color: AppColors.neutralS),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                AppString.getPremiumSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 16),
              ),
              SizedBox(height: 24.h),

              // Premium Image
              Image.asset(AppImage.premiumBox, fit: BoxFit.cover),
              SizedBox(height: 24.h),

              // Monthly Plan
              Obx(
                () => _buildPlanCard(
                  title: AppString.monthly,
                  price: '\$9.00',
                  priceSubtext: '',
                  description: AppString.monthlyDescription,
                  isSelected: controller.selectedPlan.value == 'monthly',
                  isBestValue: false,
                  onTap: () => controller.selectedPlan.value = 'monthly',
                ),
              ),
              SizedBox(height: 12.h),

              // Annual Plan
              Obx(
                () => _buildPlanCard(
                  title: AppString.annual,
                  price: '\$7.99',
                  priceSubtext: '/month',
                  description: AppString.annualDescription,
                  isSelected: controller.selectedPlan.value == 'annual',
                  isBestValue: true,
                  onTap: () => controller.selectedPlan.value = 'annual',
                ),
              ),
              SizedBox(height: 24.h),

              // Start Free Trial Button
              Obx(
                () => CustomButton(
                  buttonName: AppString.startFreeTrial,
                  isloading: controller.isLoading.value,
                  onTap: () => controller.startFreeTrial(),
                ),
              ),
              SizedBox(height: 16.h),

              // Terms and Privacy Policy
              Text(
                AppString.subscriptionTerms,
                textAlign: TextAlign.center,
                style: AppTextStyle.s16w4p(
                  color: AppColors.lighmode,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String priceSubtext,
    required String description,
    required bool isSelected,
    required bool isBestValue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.ash,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: AppTextStyle.s16w4(
                              color: AppColors.neutralS,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: AppTextStyle.s16w4(
                          color: AppColors.neutralS,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: AppTextStyle.s16w4(
                          color: AppColors.neutralS,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      if (priceSubtext.isNotEmpty)
                        TextSpan(
                          text: priceSubtext,
                          style: AppTextStyle.s16w4(
                            color: AppColors.neutralS,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -10,
              right: 13,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  AppString.bestValue,
                  style: AppTextStyle.s16w4(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
