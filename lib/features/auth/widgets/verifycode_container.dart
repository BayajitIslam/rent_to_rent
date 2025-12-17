import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/auth/controllers/otp_controller.dart';
import 'package:rent2rent/features/auth/widgets/custom_button.dart';

class VerifyCodeContainer extends StatelessWidget {
  final OTPController controller;
  final String? email;

  const VerifyCodeContainer({super.key, required this.controller, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Title
          Text(
            AppString.checkYourEmail,
            textAlign: TextAlign.center,
            style: AppTextStyle.s24w5(),
          ),
          SizedBox(height: 12.h),

          // Subtitle with email
          Text(
            '${AppString.weSentResetLink} ${email ?? controller.email ?? 'contact@gmail.com'} ${AppString.pleaseEnterCode}',
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
          ),
          SizedBox(height: 24.h),

          // OTP Input Fields
          _buildOtpFields(),
          SizedBox(height: 16.h),

          // Resend OTP
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => GestureDetector(
                onTap: controller.canResend.value
                    ? () => controller.resendOTP()
                    : null,
                child: Text(
                  controller.canResend.value
                      ? AppString.resendOtp
                      : '${AppString.resendOtp} (${controller.formatTime(controller.remainingTime.value)})',
                  style:
                      AppTextStyle.s16w4(
                        color: AppColors.neutralS,
                        fontSize: 14,
                      ).copyWith(
                        decoration: controller.canResend.value
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: AppColors.primary,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Verify Code Button
          Obx(
            () => CustomButton(
              buttonName: AppString.verifyCode,
              isloading: controller.isLoading.value,
              onTap: () => controller.verifyOTP(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildOtpBox(index)),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 54.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyle.s24w5(color: AppColors.neutralS),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            // Move to next field
            controller.focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field on backspace
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
