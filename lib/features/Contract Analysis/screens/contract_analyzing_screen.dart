import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Contract%20Analysis/controllers/contract_analysis_controller.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class ContractAnalyzingScreen extends StatefulWidget {
  const ContractAnalyzingScreen({super.key});

  @override
  State<ContractAnalyzingScreen> createState() =>
      _ContractAnalyzingScreenState();
}

class _ContractAnalyzingScreenState extends State<ContractAnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ContractAnalysisController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ContractAnalysisController>();
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
          CustomAppBar(title: AppString.contractAnalysis, showBack: false),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    AppString.analyzingYourContract,
                    style: AppTextStyle.s24w7(
                      color: AppColors.neutralS,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Description
                  Text(
                    AppString.analyzingDescription,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.s24w5(
                      color: AppColors.ash,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // PDF Icon
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: SvgPicture.asset(AppImage.pdf),
                  ),
                  SizedBox(height: 8.h),

                  // File Name
                  Obx(
                    () => Text(
                      controller.fileName.value,
                      style: AppTextStyle.s24w5(
                        color: AppColors.neutralS,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Loading Spinner
                  RotationTransition(
                    turns: _animationController,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ash, width: 3),
                      ),
                      padding: EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 40.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.primary,
                                    width: 3,
                                  ),
                                  left: BorderSide(
                                    color: AppColors.primary,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: AppColors.primary,
                                    width: 3,
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
          ),
        ],
      ),
    );
  }
}
