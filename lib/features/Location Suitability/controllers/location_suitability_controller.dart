import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';

class LocationSuitabilityController extends GetxController {
  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // ==================== STEP 1: Select Preferences ====================

  // Background Image Selection (4 images)
  final RxInt selectedBackgroundIndex = 0.obs;
  final RxList<String> backgroundImages = <String>[
    'assets/images/contract_preview.png',
    'assets/images/contract_preview.png',
    'assets/images/contract_preview.png',
    'assets/images/contract_preview.png',
  ].obs;

  // Category Types
  final RxBool seniorLivingWG = false.obs;
  final RxBool seniorLivingWG2 = false.obs;
  final RxBool students = false.obs;
  final RxBool airbnbOptional = false.obs;
  final RxBool engineerHousing = false.obs;

  // ==================== STEP 2: Landlord Info & Property Details ====================

  // Landlord Info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Property Information
  final TextEditingController addressController = TextEditingController();
  final TextEditingController squareMetersController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();
  final RxBool walkthroughRoom = false.obs;

  // Local Amenities At A Glance
  final RxBool universityWithin10Min = false.obs;
  final RxBool groceryStoreWithin10Min = false.obs;
  final RxBool hospitalWithin10Min = false.obs;
  final RxBool publicTransportWithin10Min = false.obs;

  // Additional Attributes
  final RxBool goodResidentialArea = false.obs;
  final RxBool basicArea = false.obs;
  final RxBool groundFloor = false.obs;
  final RxBool elevatorAvailable = false.obs;
  final RxBool barrierFree = false.obs;

  // Monthly Rent
  final RxBool flatRate = false.obs;
  final RxBool plusUtilities = true.obs;
  final TextEditingController utilitiesAmountController =
      TextEditingController();

  // Contract End Date
  final Rx<DateTime?> contractEndDate = Rx<DateTime?>(null);

  // Reason for Contract Limitation
  final TextEditingController reasonController = TextEditingController();

  // ==================== STEP 4: Results ====================

  // Category Ratings
  final RxList<CategoryRating> categoryRatings = <CategoryRating>[].obs;

  // Location Insights
  final RxList<LocationInsight> locationInsights = <LocationInsight>[].obs;

  // Admin Recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    Console.green('LocationSuitabilityController initialized');
  }

  // ==================== Select Background Image ====================
  void selectBackgroundImage(int index) {
    selectedBackgroundIndex.value = index;
    update();
    Console.cyan('Selected background image: $index');
  }

  // ==================== Navigation ====================

  // Step 1 -> Step 2
  void goToStep2() {
    if (!_validateStep1()) return;
    Get.toNamed(RoutesName.locationPropertyDetailsScreen);
    Console.blue('Navigated to Step 2');
  }

  // Step 2 -> Step 3 (Analyzing)
  Future<void> analyzeLocation() async {
    if (!_validateStep2()) return;

    try {
      isLoading.value = true;

      // Navigate to Analyzing Screen
      Get.toNamed(RoutesName.locationAnalyzingScreen);

      isAnalyzing.value = true;
      Console.blue('Analyzing location...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 3));

      // Load mock results
      _loadMockResults();

      Console.green('Location analysis completed');

      // Navigate to Results Screen
      Get.offNamed(RoutesName.locationResultsScreen);
    } catch (e) {
      Console.red('Error analyzing location: $e');
      Get.back();
    } finally {
      isLoading.value = false;
      isAnalyzing.value = false;
    }
  }

  // Save Analysis
  void saveAnalysis() {
    Console.green('Analysis saved');
    // TODO: Save to database
  }

  // Start New Analysis
  void startNewAnalysis() {
    _clearAllData();
    Get.offAllNamed(RoutesName.locationSuitabilityScreen);
    Console.blue('Starting new analysis');
  }

  // ==================== Validation ====================
  bool _validateStep1() {
    if (!seniorLivingWG.value &&
        !seniorLivingWG2.value &&
        !students.value &&
        !airbnbOptional.value &&
        !engineerHousing.value) {
      Console.red('Error: Please select at least one category');
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (nameController.text.trim().isEmpty) {
      Console.red('Error: Please enter name');
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      Console.red('Error: Please enter property address');
      return false;
    }
    return true;
  }

  // ==================== Date Picker ====================
  Future<void> selectContractEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: contractEndDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );
    if (picked != null) {
      contractEndDate.value = picked;
      Console.cyan('Contract end date selected: $picked');
    }
  }

  // ==================== Load Mock Results ====================
  void _loadMockResults() {
    categoryRatings.value = [
      CategoryRating(name: 'Senior Living WG', rating: 4.0),
      CategoryRating(name: 'Students', rating: 4.0),
      CategoryRating(name: 'Short Stay', rating: 4.0),
      CategoryRating(name: 'Monteurzimmer', rating: 4.0),
      CategoryRating(name: 'Engineer Housing', rating: 4.0),
      CategoryRating(name: 'Airbnb (optional)', rating: 4.0),
    ];

    locationInsights.value = [
      LocationInsight(
        icon: 'university',
        title: 'Distance to Canadian University',
        value: 'Approx. 1.2 km',
        subtitle: 'Very close',
      ),
      LocationInsight(
        icon: 'transport',
        title: 'Distance to Public Transport',
        value: 'Approx. 200m',
        subtitle: 'U-Bahn station',
      ),
      LocationInsight(
        icon: 'employer',
        title: 'Nearby Employers',
        value: 'Within 5 km',
        subtitle: 'Trexa Hub',
      ),
      LocationInsight(
        icon: 'hospital',
        title: 'Nearby Hospitals',
        value: 'Within 5 km',
        subtitle: 'Amboya Hospital',
      ),
      LocationInsight(
        icon: 'hospital',
        title: 'Nearby Hospitals',
        value: '',
        subtitle: '',
      ),
    ];

    recommendations.value = [
      'This area is high demand for engineers.',
      'Avoid short-term rentals in first 12 months.',
      'Make sure contract includes noise clause.',
    ];
  }

  // ==================== Clear Data ====================
  void _clearAllData() {
    // Step 1
    selectedBackgroundIndex.value = 0;
    seniorLivingWG.value = false;
    seniorLivingWG2.value = false;
    students.value = false;
    airbnbOptional.value = false;
    engineerHousing.value = false;

    // Step 2
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    squareMetersController.clear();
    numberOfRoomsController.clear();
    walkthroughRoom.value = false;
    universityWithin10Min.value = false;
    groceryStoreWithin10Min.value = false;
    hospitalWithin10Min.value = false;
    publicTransportWithin10Min.value = false;
    goodResidentialArea.value = false;
    basicArea.value = false;
    groundFloor.value = false;
    elevatorAvailable.value = false;
    barrierFree.value = false;
    flatRate.value = false;
    plusUtilities.value = true;
    utilitiesAmountController.clear();
    contractEndDate.value = null;
    reasonController.clear();

    // Step 4
    categoryRatings.clear();
    locationInsights.clear();

    Console.yellow('All data cleared');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    squareMetersController.dispose();
    numberOfRoomsController.dispose();
    utilitiesAmountController.dispose();
    reasonController.dispose();
    Console.yellow('LocationSuitabilityController disposed');
    super.onClose();
  }
}

// ==================== Models ====================
class CategoryRating {
  final String name;
  final double rating;

  CategoryRating({required this.name, required this.rating});
}

class LocationInsight {
  final String icon;
  final String title;
  final String value;
  final String subtitle;

  LocationInsight({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });
}
