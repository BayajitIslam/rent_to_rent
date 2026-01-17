import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // Loading State
  final RxBool isLoading = false.obs;

  // User Info
  final RxString userName = 'Eleanor Pena'.obs;
  final RxString userEmail = 'eleanorpena34@gmail.com'.obs;
  final RxString userImage = ''.obs;

  // ==================== Personal Information ====================
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final Rx<File?> profilePhoto = Rx<File?>(null);
  final RxBool agreeToTerms = false.obs;

  // ==================== Company Information ====================
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController vatNumberController = TextEditingController();

  // ==================== Change Password ====================
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureRetypePassword = true.obs;

  // ==================== Help & Feedback ====================
  final TextEditingController feedbackEmailController = TextEditingController();
  final TextEditingController feedbackPhoneController = TextEditingController();
  final TextEditingController feedbackDescriptionController =
      TextEditingController();

  // ==================== Saved Files ====================
  final RxList<SavedFile> contracts = <SavedFile>[].obs;
  final RxList<SavedFile> inquiries = <SavedFile>[].obs;
  final RxList<SavedFile> uploadedDocuments = <SavedFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadSavedFiles();
    Console.green('ProfileController initialized');
  }

  // ==================== Load User Data ====================
  void _loadUserData() {
    // TODO: Load from API/Storage
    fullNameController.text = userName.value;
    emailController.text = userEmail.value;
    userImage.value =
        'https://dreamz-wordpress.technowebstore.com/wp-content/uploads/2024/07/t-2-1.png';
  }

  // Delete File
  void deleteFile(String category, int index) {
    switch (category) {
      case 'contracts':
        if (index < contracts.length) {
          contracts.removeAt(index);
          Console.green('Contract deleted');
        }
        break;
      case 'inquiries':
        if (index < inquiries.length) {
          inquiries.removeAt(index);
          Console.green('Inquiry deleted');
        }
        break;
      case 'documents':
        if (index < uploadedDocuments.length) {
          uploadedDocuments.removeAt(index);
          Console.green('Document deleted');
        }
        break;
    }
  }

  // ==================== Load Saved Files ====================
  void _loadSavedFiles() {
    // Mock data - unlimited items
    contracts.value = [
      SavedFile(name: 'contrats1.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats2.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats3.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats4.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats5.pdf', date: "21 May, 2023", type: 'pdf'),
    ];

    inquiries.value = [
      SavedFile(name: 'contrats1.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats2.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats3.pdf', date: "21 May, 2023", type: 'pdf'),
    ];

    uploadedDocuments.value = [
      SavedFile(name: 'contrats1.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats2.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats3.pdf', date: "21 May, 2023", type: 'pdf'),
      SavedFile(name: 'contrats4.pdf', date: "21 May, 2023", type: 'pdf'),
    ];
  }

  // ==================== Navigation ====================
  void goToSavedFiles() => Get.toNamed(RoutesName.savedFilesScreen);
  void goToPersonalInfo() => Get.toNamed(RoutesName.personalInfoScreen);
  void goToCompanyInfo() => Get.toNamed(RoutesName.companyInfoScreen);
  void goToDefaultPreferences() =>
      Get.toNamed(RoutesName.defaultPreferencesScreen);
  void goToHelpFeedback() => Get.toNamed(RoutesName.helpFeedbackScreen);
  void goToSettings() => Get.toNamed(RoutesName.settingsScreen);
  void goToTermsCondition() => Get.toNamed(RoutesName.termsConditionScreen);
  void goToPrivacyPolicy() => Get.toNamed(RoutesName.privacyPolicyScreen);
  void goToChangePassword() => Get.toNamed(RoutesName.changePasswordScreen);
  void goToGuides() => Get.toNamed(RoutesName.guidesScreen);
  void goToAboutUs() => Get.toNamed(RoutesName.aboutUsScreen);

  // ==================== Personal Information ====================
  Future<void> pickProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profilePhoto.value = File(image.path);
        Console.green('Profile photo selected');
      }
    } catch (e) {
      Console.red('Error picking photo: $e');
    }
  }

  Future<void> savePersonalInfo() async {
    if (!agreeToTerms.value) {
      Console.red('Error: Please agree to terms');
      return;
    }

    try {
      isLoading.value = true;
      Console.blue('Saving personal info...');

      // TODO: API call
      await Future.delayed(Duration(seconds: 2));

      userName.value = fullNameController.text;
      userEmail.value = emailController.text;

      Console.green('Personal info saved');
      Get.back();
    } catch (e) {
      Console.red('Error saving personal info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Company Information ====================
  Future<void> saveCompanyInfo() async {
    try {
      isLoading.value = true;
      Console.blue('Saving company info...');

      // TODO: API call
      await Future.delayed(Duration(seconds: 2));

      Console.green('Company info saved');
      Get.back();
    } catch (e) {
      Console.red('Error saving company info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Change Password ====================
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleRetypePasswordVisibility() {
    obscureRetypePassword.value = !obscureRetypePassword.value;
  }

  Future<void> changePassword() async {
    if (newPasswordController.text.isEmpty) {
      Console.red('Error: Please enter new password');
      return;
    }
    if (newPasswordController.text != retypePasswordController.text) {
      Console.red('Error: Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      Console.blue('Changing password...');

      // TODO: API call
      await Future.delayed(Duration(seconds: 2));

      Console.green('Password changed successfully');
      newPasswordController.clear();
      retypePasswordController.clear();
      Get.back();
    } catch (e) {
      Console.red('Error changing password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Help & Feedback ====================
  Future<void> submitFeedback() async {
    if (feedbackDescriptionController.text.isEmpty) {
      Console.red('Error: Please describe your issue');
      return;
    }

    try {
      isLoading.value = true;
      Console.blue('Submitting feedback...');

      // TODO: API call
      await Future.delayed(Duration(seconds: 2));

      Console.green('Feedback submitted');
      feedbackEmailController.clear();
      feedbackPhoneController.clear();
      feedbackDescriptionController.clear();
      Get.back();
    } catch (e) {
      Console.red('Error submitting feedback: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Delete Account ====================
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Console.blue('Deleting account...');

      // TODO: API call
      await Future.delayed(Duration(seconds: 2));
      prefs.clear();
      Console.green('Account deleted');
      // Navigate to login
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      Console.red('Error deleting account: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Logout ====================
  Future<void> logout() async {
    try {
      Console.blue('Logging out...');
      // TODO: Clear session
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Get.offAllNamed(RoutesName.login);
      prefs.clear();
    } catch (e) {
      Console.red('Error logging out: $e');
    }
  }

  // ==================== Download File ====================
  void downloadFile(SavedFile file) {
    Console.green('Downloading ${file.name}');
    // TODO: Implement download
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    companyEmailController.dispose();
    vatNumberController.dispose();
    newPasswordController.dispose();
    retypePasswordController.dispose();
    feedbackEmailController.dispose();
    feedbackPhoneController.dispose();
    feedbackDescriptionController.dispose();
    Console.yellow('ProfileController disposed');
    super.onClose();
  }
}

// ==================== Model ====================
class SavedFile {
  final String name;
  final String date;
  final String type;

  SavedFile({required this.name, required this.type, required this.date});
}
