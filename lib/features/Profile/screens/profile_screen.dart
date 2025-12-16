import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_colors.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/core/themes/app_text_style.dart';
import 'package:rent2rent/features/Profile/controllers/profile_controller.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';
import 'package:rent2rent/features/home/widgets/custome_appbar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();

    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar
            CustomAppBar(title: AppString.theBrain),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
        
                  // Profile Avatar & Info
                  _buildProfileHeader(ctrl),
                  SizedBox(height: 30.h),
        
                  // Files Section
                  _buildSectionTitle(AppString.files),
                  SizedBox(height: 12.h),
                  _buildMenuItem(
                    verticlepadding: 20,
                    icon: Icons.file_copy_outlined,
                    title: AppString.savedFiles,
                    onTap: () => ctrl.goToSavedFiles(),
                  ),
                  SizedBox(height: 20.h),
        
                  // Settings and Privacy Section
                  _buildSectionTitle(AppString.settingsAndPrivacy),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.whiteBorder,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: AppString.personalInformation,
                          onTap: () => ctrl.goToPersonalInfo(),
                        ),
                        _buildMenuItem(
                          icon: Icons.business_outlined,
                          title: AppString.companyInformation,
                          onTap: () => ctrl.goToCompanyInfo(),
                        ),
                        _buildMenuItem(
                          icon: Icons.tune_outlined,
                          title: AppString.defaultPreferences,
                          onTap: () => ctrl.goToDefaultPreferences(),
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: AppString.helpAndFeedback,
                          onTap: () => ctrl.goToHelpFeedback(),
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: AppString.settings,
                          onTap: () => ctrl.goToSettings(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
        
                  // More Section
                  _buildSectionTitle(AppString.more),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.whiteBorder,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          title: AppString.termsAndCondition,
                          onTap: () => ctrl.goToTermsCondition(),
                        ),
                        _buildMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: AppString.privacyPolicy,
                          onTap: () => ctrl.goToPrivacyPolicy(),
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: AppString.logOut,
                          onTap: () => ctrl.logout(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController ctrl) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 130.w,
            height: 130.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x4D402A0C),
                  blurRadius: 28.6,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: ClipOval(
              child: Obx(
                () => ctrl.userImage.value.isNotEmpty
                    ? Image.network(ctrl.userImage.value, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryLight,
                            child: Icon(
                              Icons.person,
                              size: 50.sp,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Name
          Obx(
            () => Text(
              ctrl.userName.value,
              style: AppTextStyle.s24w5(
                color: AppColors.neutralS,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Email
          Obx(
            () => Text(
              ctrl.userEmail.value,
              style: AppTextStyle.s16w4(color: AppColors.ash, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.s24w5(color: AppColors.neutralS, fontSize: 18),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    double verticlepadding = 14,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticlepadding.h,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(color: AppColors.whiteBorder, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.s16w4(color: AppColors.neutralS),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
