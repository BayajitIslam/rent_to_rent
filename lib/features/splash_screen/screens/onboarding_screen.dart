import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/splash_screen/controllers/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // PageView (NO SWIPING)
          Flexible(
            flex: 5,
            child: PageView.builder(
              controller: controller.pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (context, index) {
                return _buildPageContent(
                  controller.pages[index],
                  controller,
                  context,
                );
              },
            ),
          ),

          Stack(
            alignment: AlignmentGeometry.center,
            clipBehavior: Clip.none,
            children: [
              // Next Button
              SizedBox(
                height: 208.h,
                child: Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 49.h),
                    child: Obx(
                      () => Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            controller.currentPage.value ==
                                    controller.pages.length - 1
                                ? AppString.start
                                : AppString.next,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: -80,
                child: Padding(
                  padding: EdgeInsets.only(top: 28.h),
                  // Smooth Page Indicator
                  child: SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.pages.length,
                    effect: ScaleEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.ash,
                      scale: 1.6,
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      spacing: 9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(
    OnboardingData page,
    OnboardingController controller,
    BuildContext context,
  ) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.s32w7(),
          ),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(),
          ),

          SizedBox(height: 85.h),
        ],
      ),
    );
  }
}
