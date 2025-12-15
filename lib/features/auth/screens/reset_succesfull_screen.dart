import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/screens/auth_background_screen.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';
import 'package:rent2rent/routes/routes_name.dart';

class ResetSuccesfullScreen extends StatelessWidget {
  const ResetSuccesfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      child: Container(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 30.h,
          bottom: 43.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
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
            // Success Icon
            Container(
              width: 78.w,
              height: 78.h,
              decoration: BoxDecoration(
                color: AppColors.greencheck,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: AppColors.white, size: 44.sp),
            ),
            SizedBox(height: 30.h),

            // Title
            Text(
              AppString.passwordResetSuccess,
              textAlign: TextAlign.center,
              style: AppTextStyle.s24w5(),
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              AppString.passwordResetSuccessSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
            ),
            SizedBox(height: 30.h),

            // Sign In Button
            CustomButton(
              buttonName: AppString.signIn,
              isloading: false,
              onTap: () => Get.offAllNamed(RoutesName.login),
            ),
          ],
        ),
      ),
    );
  }
}
