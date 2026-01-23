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
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';

class GetPremiumScreen extends StatefulWidget {
  const GetPremiumScreen({super.key});

  @override
  State<GetPremiumScreen> createState() => _GetPremiumScreenState();
}

class _GetPremiumScreenState extends State<GetPremiumScreen>
    with WidgetsBindingObserver {
  final controller = Get.find<SubscriptionController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.verifySubscriptionStatus();
    }
  }

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
          child: Obx(() {
            if (controller.isPlansLoading.value) {
              return SizedBox(
                height: 400.h,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            return Column(
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
                    price: controller.getMonthlyPrice(),
                    priceSubtext: '',
                    description: AppString.monthlyDescription,
                    isSelected:
                        controller.hasMonthlyPlan &&
                        controller.selectedPlanId.value ==
                            controller.monthlyPlan.value?.id,
                    isBestValue: false,
                    isAvailable: controller.hasMonthlyPlan,
                    onTap: () {
                      if (controller.hasMonthlyPlan) {
                        controller.selectPlan(controller.monthlyPlan.value!.id);
                      } else {
                        CustomeSnackBar.error('Monthly plan coming soon!');
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                // Annual Plan
                Obx(
                  () => _buildPlanCard(
                    title: AppString.annual,
                    price: controller.getAnnualPrice(),
                    priceSubtext: '/month',
                    description: AppString.annualDescription,
                    isSelected:
                        controller.hasAnnualPlan &&
                        controller.selectedPlanId.value ==
                            controller.annualPlan.value?.id,
                    isBestValue: true,
                    isAvailable: controller.hasAnnualPlan,
                    onTap: () {
                      if (controller.hasAnnualPlan) {
                        controller.selectPlan(controller.annualPlan.value!.id);
                      } else {
                        CustomeSnackBar.error('Annual plan coming soon!');
                      }
                    },
                  ),
                ),
                SizedBox(height: 24.h),

                // Start Free Trial Button
                Obx(
                  () => CustomButton(
                    buttonName: AppString.startFreeTrial,
                    isloading: controller.isLoading.value,
                    onTap: () => controller.createSubscription(),
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
            );
          }),
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
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Opacity(
            opacity: isAvailable ? 1.0 : 0.5,
            child: Container(
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
                            if (!isAvailable) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.ash.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Coming Soon',
                                  style: AppTextStyle.s16w4(
                                    color: AppColors.neutralS,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
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
          ),
          if (isBestValue && isAvailable)
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
