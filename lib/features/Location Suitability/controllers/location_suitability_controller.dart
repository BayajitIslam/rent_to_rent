import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class LocationSuitabilityController extends GetxController {
  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // ==================== STEP 1: Select Preferences ====================

  // Category Types (Checkboxes)
  final RxBool seniorLivingWG = false.obs;
  final RxBool seniorLivingWG2 = false.obs;
  final RxBool students = false.obs;
  final RxBool airbnbOptional = false.obs;
  final RxBool engineerHousing = false.obs;

  // ==================== STEP 2: Property Details (Dropdowns) ====================

  // Area Section
  final RxString citySize = ''.obs;
  final RxString districtType = ''.obs;
  final RxString demandProfile = ''.obs;

  // Dropdown Options for Area
  final List<String> citySizeOptions = [
    'Major city',
    'Medium city',
    'Small city',
    'Rural area',
  ];

  final List<String> districtTypeOptions = [
    'Central',
    'Suburban',
    'Outskirts',
    'Industrial',
  ];

  final List<String> demandProfileOptions = [
    'Business',
    'Tourist',
    'Student',
    'Residential',
  ];

  // Infrastructure Section
  final RxString publicTransport = ''.obs;
  final RxString supermarketsNearby = ''.obs;
  final RxString attractionsNearby = ''.obs;

  // Dropdown Options for Infrastructure
  final List<String> yesNoOptions = ['Yes', 'No'];

  // Rent2Rent Potential Section
  final RxString localDemand = ''.obs;
  final RxString competitionLevel = ''.obs;
  final RxString rentalPrices = ''.obs;
  final RxString regulatoryFriendliness = ''.obs;

  // Dropdown Options for Rent2Rent Potential
  final List<String> levelOptions = ['Low', 'Medium', 'High'];

  // ==================== STEP 3: Results ====================

  // Category Ratings
  final RxList<CategoryRating> categoryRatings = <CategoryRating>[].obs;

  // Location Insights
  final RxList<LocationInsight> locationInsights = <LocationInsight>[].obs;

  // Admin Recommendations
  final RxList<String> recommendations = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    Console.green('LocationSuitabilityController initialized');
  }

  // ==================== Navigation ====================

  // Step 1 -> Step 2
  void goToStep2() {
    if (!_validateStep1()) return;
    Get.toNamed(RoutesName.locationPropertyDetailsScreen);
    Console.blue('Navigated to Step 2');
  }

  // Step 2 -> Step 3 (Analyzing -> Results)
  Future<void> analyzeLocation() async {
    if (!_validateStep2()) return;

    try {
      isLoading.value = true;

      // Navigate to Analyzing Screen
      Get.toNamed(RoutesName.locationAnalyzingScreen);

      isAnalyzing.value = true;
      Console.blue('Analyzing location...');

      // TODO: Replace with actual API call
      // final response = await _apiService.analyzeLocation(_buildRequestData());
      await Future.delayed(const Duration(seconds: 3));

      // Load results (replace with API response)
      _loadResults();

      Console.green('Location analysis completed');

      // Navigate to Results Screen
      Get.offNamed(RoutesName.locationResultsScreen);
    } catch (e) {
      Console.red('Error analyzing location: $e');
      _showError('Failed to analyze location. Please try again.');
      Get.back();
    } finally {
      isLoading.value = false;
      isAnalyzing.value = false;
    }
  }

  // Build request data for API
  Map<String, dynamic> buildRequestData() {
    return {
      // Step 1: Categories
      'categories': {
        'senior_living_wg': seniorLivingWG.value,
        'senior_living_wg_2': seniorLivingWG2.value,
        'students': students.value,
        'airbnb_optional': airbnbOptional.value,
        'engineer_housing': engineerHousing.value,
      },
      // Step 2: Area
      'area': {
        'city_size': citySize.value,
        'district_type': districtType.value,
        'demand_profile': demandProfile.value,
      },
      // Step 2: Infrastructure
      'infrastructure': {
        'public_transport': publicTransport.value,
        'supermarkets_nearby': supermarketsNearby.value,
        'attractions_nearby': attractionsNearby.value,
      },
      // Step 2: Rent2Rent Potential
      'rent2rent_potential': {
        'local_demand': localDemand.value,
        'competition_level': competitionLevel.value,
        'rental_prices': rentalPrices.value,
        'regulatory_friendliness': regulatoryFriendliness.value,
      },
    };
  }

  // Save Analysis
  void saveAnalysis() {
    // TODO: Save to database/API
    Console.green('Analysis saved');
    _showSuccess('Analysis saved successfully!');
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
      _showError('Please select at least one category');
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    // Area validation
    if (citySize.value.isEmpty) {
      _showError('Please select city size');
      return false;
    }
    if (districtType.value.isEmpty) {
      _showError('Please select district type');
      return false;
    }
    if (demandProfile.value.isEmpty) {
      _showError('Please select demand profile');
      return false;
    }

    // Infrastructure validation
    if (publicTransport.value.isEmpty) {
      _showError('Please select public transport option');
      return false;
    }
    if (supermarketsNearby.value.isEmpty) {
      _showError('Please select supermarkets/restaurants option');
      return false;
    }
    if (attractionsNearby.value.isEmpty) {
      _showError('Please select attractions nearby option');
      return false;
    }

    // Rent2Rent Potential validation
    if (localDemand.value.isEmpty) {
      _showError('Please select local demand');
      return false;
    }
    if (competitionLevel.value.isEmpty) {
      _showError('Please select competition level');
      return false;
    }
    if (rentalPrices.value.isEmpty) {
      _showError('Please select rental prices');
      return false;
    }
    if (regulatoryFriendliness.value.isEmpty) {
      _showError('Please select regulatory friendliness');
      return false;
    }

    return true;
  }

  // ==================== Load Results ====================

  void _loadResults() {
    // TODO: Replace with actual API response parsing
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
    ];

    recommendations.value = [
      'This area is high demand for engineers.',
      'Avoid short-term rentals in first 12 months.',
      'Make sure contract includes noise clause.',
    ];
  }

  // Parse API response (call this when you have real API)
  void parseApiResponse(Map<String, dynamic> response) {
    try {
      // Parse category ratings
      if (response['category_ratings'] != null) {
        categoryRatings.value = (response['category_ratings'] as List)
            .map(
              (e) => CategoryRating(
                name: e['name'] ?? '',
                rating: (e['rating'] ?? 0).toDouble(),
              ),
            )
            .toList();
      }

      // Parse location insights
      if (response['location_insights'] != null) {
        locationInsights.value = (response['location_insights'] as List)
            .map(
              (e) => LocationInsight(
                icon: e['icon'] ?? '',
                title: e['title'] ?? '',
                value: e['value'] ?? '',
                subtitle: e['subtitle'] ?? '',
              ),
            )
            .toList();
      }

      // Parse recommendations
      if (response['recommendations'] != null) {
        recommendations.value = List<String>.from(response['recommendations']);
      }
    } catch (e) {
      Console.red('Error parsing API response: $e');
    }
  }

  // ==================== Helper Methods ====================

  void _showError(String message) {
    CustomeSnackBar.error(message);
  }

  void _showSuccess(String message) {
    CustomeSnackBar.success(message);
  }

  // ==================== Clear Data ====================

  void _clearAllData() {
    // Step 1: Categories
    seniorLivingWG.value = false;
    seniorLivingWG2.value = false;
    students.value = false;
    airbnbOptional.value = false;
    engineerHousing.value = false;

    // Step 2: Area
    citySize.value = '';
    districtType.value = '';
    demandProfile.value = '';

    // Step 2: Infrastructure
    publicTransport.value = '';
    supermarketsNearby.value = '';
    attractionsNearby.value = '';

    // Step 2: Rent2Rent Potential
    localDemand.value = '';
    competitionLevel.value = '';
    rentalPrices.value = '';
    regulatoryFriendliness.value = '';

    // Step 3: Results
    categoryRatings.clear();
    locationInsights.clear();
    recommendations.clear();

    Console.yellow('All data cleared');
  }

  // Get selected categories as list (useful for API)
  List<String> getSelectedCategories() {
    List<String> selected = [];
    if (seniorLivingWG.value) selected.add('Senior Living WG');
    if (seniorLivingWG2.value) selected.add('Senior Living WG 2');
    if (students.value) selected.add('Students');
    if (airbnbOptional.value) selected.add('Airbnb (optional)');
    if (engineerHousing.value) selected.add('Engineer Housing');
    return selected;
  }

  @override
  void onClose() {
    Console.yellow('LocationSuitabilityController disposed');
    super.onClose();
  }
}

// ==================== Models ====================

class CategoryRating {
  final String name;
  final double rating;

  CategoryRating({required this.name, required this.rating});

  factory CategoryRating.fromJson(Map<String, dynamic> json) {
    return CategoryRating(
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'rating': rating};
  }
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

  factory LocationInsight.fromJson(Map<String, dynamic> json) {
    return LocationInsight(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      value: json['value'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'icon': icon, 'title': title, 'value': value, 'subtitle': subtitle};
  }
}
