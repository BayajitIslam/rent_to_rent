import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';
import 'package:rent2rent/features/Location%20Suitability/widgets/location_step_indicator.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class LocationAnalyzingScreen extends StatefulWidget {
  const LocationAnalyzingScreen({super.key});

  @override
  State<LocationAnalyzingScreen> createState() =>
      _LocationAnalyzingScreenState();
}

class _LocationAnalyzingScreenState extends State<LocationAnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late LocationSuitabilityController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LocationSuitabilityController>();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // AppBar
          CustomAppBar(title: AppString.locationSuitability, showBack: false),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                // Step Indicator
                LocationStepIndicator(currentStep: 3),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  AppString.analyzingLocation,
                  style: AppTextStyle.s24w7(
                    color: AppColors.neutralS,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 11.h),

                // Description
                Text(
                  AppString.thisMayTakeFewSeconds,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
                ),
                SizedBox(height: 44.h),

                // Loading Spinner
                RotationTransition(
                  turns: _animationController,
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.ash, width: 4),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: 50.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.r),
                                topRight: Radius.circular(25.r),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primary,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: AppColors.primary,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: AppColors.primary,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
