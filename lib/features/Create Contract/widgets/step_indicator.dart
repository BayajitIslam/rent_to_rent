import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStepItem(1, 'Select Contract Type', currentStep >= 1),
        _buildDashedLine(currentStep >= 2),
        _buildStepItem(2, 'Fill Contract\nDetails', currentStep >= 2),
        _buildDashedLine(currentStep >= 3),
        _buildStepItem(3, 'Generate\nContract', currentStep >= 3),
      ],
    );
  }

  Widget _buildStepItem(int step, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          // Step Circle with number
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.white,
              shape: BoxShape.circle,
              // border: Border.all(
              //   color: isActive ? AppColors.primary : AppColors.ash,
              //   width: 1.5,
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0$step',
                  style: AppTextStyle.s16w4(
                    color: isActive ? AppColors.white : AppColors.neutralS,

                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'STEP',
                  style: AppTextStyle.s24w7(
                    color: isActive ? AppColors.white : AppColors.neutralS,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Step Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.s16w4(
              color: isActive ? AppColors.neutralS : AppColors.ash,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine(bool isActive) {
    return Container(
      width: 50.w,
      margin: EdgeInsets.only(bottom: 40.h),
      child: CustomPaint(
        painter: DashedLinePainter(
          color: isActive ? AppColors.primary : AppColors.ash,
        ),
        size: Size(50.w, 2.h),
      ),
    );
  }
}

// Custom Dashed Line Painter
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
