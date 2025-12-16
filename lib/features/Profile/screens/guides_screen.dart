import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.guides),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Intro Paragraph
                  Text(
                    _introText,
                    style: AppTextStyle.s16w4(
                      color: AppColors.neutralS,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Numbered List
                  _buildNumberedItem(1, _point1),
                  SizedBox(height: 16.h),
                  _buildNumberedItem(2, _point2),
                  SizedBox(height: 16.h),
                  _buildNumberedItem(3, _point3),
                  SizedBox(height: 16.h),
                  _buildNumberedItem(4, _point4),
                  SizedBox(height: 16.h),
                  _buildNumberedItem(5, _point5),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: AppTextStyle.s16w4(color: AppColors.neutralS, fontSize: 14),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.s16w4(
              color: AppColors.neutralS,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  static const String _introText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.';

  static const String _point1 =
      'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing';

  static const String _point2 =
      'Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  static const String _point3 =
      'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing';

  static const String _point4 =
      'Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  static const String _point5 =
      'Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';
}
