import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/image_const.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/widgets/bottom_curve_clipper_widget.dart';

class AuthBackgroundScreen extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final bool bottomEnable;
  final String bottomTextButton;
  final String bottomText;

  AuthBackgroundScreen({
    super.key,
    required this.child,
    this.onTap,
    this.bottomEnable = false,
    this.bottomText = "",
    this.bottomTextButton = "",
  });

  final canGoBack = Navigator.of(Get.context!).canPop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // keyboard up hole resize na
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // background curve
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                color: AppColors.primary,
                width: double.infinity,
                height: 320.h,
              ),
            ),
          ),

          // back button
          Positioned(
            top: 62.h,
            left: 25.w,
            child: canGoBack
                ? InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColors.lishtGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  )
                : SizedBox(),
          ),

          // logo
          Positioned(
            top: 70.h,
            child: Image.asset(AppImage.rent2rentProLogo, width: 100),
          ),

          // main content - scrollable
          Positioned(
            top: 225.h,
            left: 20.w,
            right: 20.w,
            bottom: bottomEnable ? 100.h : 20.h,
            child: SingleChildScrollView(child: child),
          ),

          // bottom text - fixed position
          if (bottomEnable)
            Positioned(
              left: 0,
              right: 0,
              bottom: 59.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bottomText,
                    style: AppTextStyle.s16w4(color: AppColors.neutralS),
                  ),
                  SizedBox(width: 2),
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      bottomTextButton,
                      style: AppTextStyle.s16w4(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
