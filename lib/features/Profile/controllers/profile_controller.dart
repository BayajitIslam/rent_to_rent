import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/local_storage/storage_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

import '../../../core/services/api_service.dart';

class ProfileController extends GetxController {
  // Loading State
  final RxBool isLoading = false.obs;
  final RxBool isDownloading = false.obs;

  // User Info
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userImage = ''.obs;
  final RxString userType = ''.obs;

  // Personal Information
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final Rx<File?> profilePhoto = Rx<File?>(null);
  final RxBool agreeToTerms = false.obs;

  // Company Information
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController vatNumberController = TextEditingController();

  // Change Password
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final RxBool obscureOldPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureRetypePassword = true.obs;

  // Help & Feedback
  final TextEditingController feedbackDescriptionController =
      TextEditingController();

  // Saved Files
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

  // Load User Data
  void _loadUserData() async {
    final email = await StorageService.getUserEmail();
    userEmail.value = email;
    final name = await StorageService.getUserName();
    userName.value = name;
    try {
      isLoading.value = true;
      final response = await ApiService.getAuth(ApiEndpoints.profile);
      if (response.statusCode == 200) {
        final data = response.data;
        Console.green('$data');
        userName.value = data['full_name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userImage.value = data['profile_image'] ?? '';

        phoneController.text = data['phone_number'] ?? '';
        fullNameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        addressController.text = data['address'] ?? '';
        userType.value = data['user_type'] ?? '';
      } else if (response.statusCode == 400) {
        Console.red('Error loading user data: ${response.data['message']}');
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load Saved Files
  Future<void> _loadSavedFiles() async {
    try {
      isLoading.value = true;
      final response = await ApiService.getAuth(ApiEndpoints.savedFiles);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        Console.green('Saved files loaded: ${data.length}');

        contracts.value = data.map((item) {
          return SavedFile(
            id: item['id'] ?? 0,
            name: item['title'] ?? '',
            fileUrl: item['file'] ?? '',
            date: _formatDate(item['created_at']),
            type: 'pdf',
          );
        }).toList();

        Console.green('Contracts parsed: ${contracts.length}');
      } else if (response.statusCode == 400) {
        Console.red('Error loading saved files: ${response.data['message']}');
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red('Error loading saved files: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Format date from API
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
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

  // Download File
  Future<void> downloadFile(SavedFile file) async {
    if (file.fileUrl.isEmpty) {
      CustomeSnackBar.error('File URL not available');
      return;
    }

    try {
      isDownloading.value = true;
      CustomeSnackBar.info('Downloading...');
      Console.blue('Downloading: ${file.fileUrl}');

      // download file
      final response = await http.get(Uri.parse(file.fileUrl));

      if (response.statusCode == 200) {
        // get directory
        final dir = await getApplicationDocumentsDirectory();
        final fileName = '${file.name.replaceAll(' ', '_')}.pdf';
        final savePath = '${dir.path}/$fileName';

        // write file
        final localFile = File(savePath);
        await localFile.writeAsBytes(response.bodyBytes);

        Console.green('File downloaded: $savePath');
        CustomeSnackBar.success('Download complete');

        // open file
        await OpenFilex.open(savePath);
      } else {
        Console.red('Download failed: ${response.statusCode}');
        CustomeSnackBar.error('Download failed');
      }
    } catch (e) {
      Console.red('Error downloading: $e');
      CustomeSnackBar.error('Failed to download file');
    } finally {
      isDownloading.value = false;
    }
  }

  // Navigation
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

  // Pick Profile Photo
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

  // Save Personal Information
  Future<void> savePersonalInfo() async {
    if (!agreeToTerms.value) {
      CustomeSnackBar.error('Please agree to terms');
      return;
    }

    try {
      isLoading.value = true;

      if (profilePhoto.value != null) {
        final response = await ApiService.uploadMultipart(
          url: ApiEndpoints.updateProfile,
          method: "PATCH",
          fields: {
            'full_name': fullNameController.value.text,
            'phone_number': phoneController.value.text,
            'email': emailController.value.text,
            'address': addressController.value.text,
          },
          files: {'profile_image': profilePhoto.value!},
        );

        if (response.statusCode == 200) {
          Console.green('Personal info saved with photo');
          Console.green('$response');
          _updateLocalUserData(response.data);
          Get.back();
          CustomeSnackBar.success('Profile updated successfully');
        } else if (response.statusCode == 400) {
          Console.red(
            'Error saving personal info: ${response.data['message']}',
          );
          CustomeSnackBar.error(response.data['message']);
        }
      } else {
        final response = await ApiService.patchAuth(
          ApiEndpoints.updateProfile,
          body: {
            'full_name': fullNameController.value.text,
            'phone_number': phoneController.value.text,
            'email': emailController.value.text,
            'address': addressController.value.text,
          },
        );

        if (response.statusCode == 200) {
          Console.green('Personal info saved');
          Console.green('$response');
          _updateLocalUserData(response.data);
          Get.back();
          CustomeSnackBar.success('Profile updated successfully');
        } else if (response.statusCode == 400) {
          Console.red(
            'Error saving personal info: ${response.data['message']}',
          );
          CustomeSnackBar.error(response.data['message']);
        }
      }
    } catch (e) {
      Console.red('Error saving personal info: $e');
      CustomeSnackBar.error('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLocalUserData(dynamic data) {
    if (data != null) {
      userName.value = data['full_name'] ?? userName.value;
      userEmail.value = data['email'] ?? userEmail.value;
      userImage.value = data['profile_image'] ?? userImage.value;
    }
  }

  // Save Company Information
  Future<void> saveCompanyInfo() async {
    try {
      isLoading.value = true;
      Console.blue('Saving company info...');

      final response = await ApiService.patchAuth(
        ApiEndpoints.updateProfile,
        body: {
          'company_name': companyNameController.value.text,
          'company_address': companyAddressController.value.text,
          'company_vat_number': vatNumberController.value.text,
          'email': emailController.value.text,
        },
      );

      if (response.statusCode == 200) {
        Console.green('Company info saved');
        Console.green('$response');
        _updateLocalUserData(response.data);
        Get.back();
        CustomeSnackBar.success('Company information updated successfully');
      } else if (response.statusCode == 400) {
        Console.red('Error saving company info: ${response.data['message']}');
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red('Error saving company info: $e');
      CustomeSnackBar.error('Failed to update company information');
    } finally {
      isLoading.value = false;
    }
  }

  // Change Password
  void toggleOldPasswordVisibility() {
    obscureOldPassword.value = !obscureOldPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleRetypePasswordVisibility() {
    obscureRetypePassword.value = !obscureRetypePassword.value;
  }

  Future<void> changePassword() async {
    if (oldPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter old password');
      return;
    }
    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }
    if (newPasswordController.text != retypePasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiService.postAuth(
        ApiEndpoints.changePassword,
        body: {
          'old_password': oldPasswordController.text,
          'new_password': newPasswordController.text,
          'confirm_new_password': retypePasswordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Console.green('Password changed successfully');
        oldPasswordController.clear();
        newPasswordController.clear();
        retypePasswordController.clear();
        Get.back();
        CustomeSnackBar.success('Password changed successfully');
      } else if (response.statusCode == 400) {
        Console.red('Error changing password: ${response.data['message']}');
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red('Error changing password: $e');
      CustomeSnackBar.error('Failed to change password');
    } finally {
      isLoading.value = false;
    }
  }

  // Help & Feedback
  Future<void> submitFeedback() async {
    if (feedbackDescriptionController.text.isEmpty) {
      CustomeSnackBar.error('Please enter feedback description');
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiService.postAuth(
        ApiEndpoints.feedback,
        body: {'description': feedbackDescriptionController.text},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Console.green('Feedback submitted');
        feedbackDescriptionController.clear();
        Get.back();
        CustomeSnackBar.success('Feedback submitted successfully');
      }
    } catch (e) {
      Console.red('Error submitting feedback: $e');
      CustomeSnackBar.error('Failed to submit feedback');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      final response = await ApiService.deleteAuth(ApiEndpoints.deleteAccount);

      if (response.statusCode == 200 || response.statusCode == 204) {
        StorageService.clearAll();
        Console.green('Account deleted');
        Get.offAllNamed(RoutesName.login);
        CustomeSnackBar.success('Account deleted successfully');
      } else if (response.statusCode == 400) {
        Console.red('Error deleting account: ${response.data['message']}');
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red('Error deleting account: $e');
      CustomeSnackBar.error('Failed to delete account');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      Console.blue('Logging out...');
      StorageService.clearAll();
      StorageService.clearUserSession();
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      Console.red('Error logging out: $e');
    }
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
    oldPasswordController.dispose();
    newPasswordController.dispose();
    retypePasswordController.dispose();
    feedbackDescriptionController.dispose();
    Console.yellow('ProfileController disposed');
    super.onClose();
  }
}

// Model
class SavedFile {
  final int id;
  final String name;
  final String fileUrl;
  final String date;
  final String type;

  SavedFile({
    required this.id,
    required this.name,
    required this.fileUrl,
    required this.date,
    required this.type,
  });
}
