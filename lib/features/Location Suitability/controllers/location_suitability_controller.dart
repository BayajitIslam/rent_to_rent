import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class LocationSuitabilityController extends GetxController {
  // loading states
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // polling
  Timer? _pollingTimer;
  int _pollingAttempts = 0;
  static const int _maxPollingAttempts = 30;

  // step 1: category checkboxes
  final RxBool seniorLivingWG = false.obs;
  final RxBool seniorLivingWG2 = false.obs;
  final RxBool students = false.obs;
  final RxBool airbnbOptional = false.obs;
  final RxBool engineerHousing = false.obs;

  // step 2: text controllers for area
  late final TextEditingController citySizeController;
  late final TextEditingController districtTypeController;
  late final TextEditingController demandProfileController;

  // step 2: text controllers for infrastructure
  late final TextEditingController publicTransportController;
  late final TextEditingController supermarketsNearbyController;
  late final TextEditingController attractionsNearbyController;

  // step 2: text controllers for rent2rent potential
  late final TextEditingController localDemandController;
  late final TextEditingController competitionLevelController;
  late final TextEditingController rentalPricesController;
  late final TextEditingController regulatoryFriendlinessController;

  // step 3: results
  final RxList<CategoryRating> categoryRatings = <CategoryRating>[].obs;
  final RxList<LocationInsight> locationInsights = <LocationInsight>[].obs;
  final RxList<String> recommendations = <String>[].obs;
  final RxList<String> riskFactors = <String>[].obs;
  final Rx<OverallRating?> overallRating = Rx<OverallRating?>(null);
  final RxString bestUseCase = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    Console.green('LocationSuitabilityController initialized');
  }

  @override
  void onClose() {
    _cancelPolling();
    _disposeControllers();
    Console.yellow('LocationSuitabilityController disposed');
    super.onClose();
  }

  // initialize all text controllers
  void _initControllers() {
    citySizeController = TextEditingController();
    districtTypeController = TextEditingController();
    demandProfileController = TextEditingController();
    publicTransportController = TextEditingController();
    supermarketsNearbyController = TextEditingController();
    attractionsNearbyController = TextEditingController();
    localDemandController = TextEditingController();
    competitionLevelController = TextEditingController();
    rentalPricesController = TextEditingController();
    regulatoryFriendlinessController = TextEditingController();
  }

  // dispose all text controllers
  void _disposeControllers() {
    citySizeController.dispose();
    districtTypeController.dispose();
    demandProfileController.dispose();
    publicTransportController.dispose();
    supermarketsNearbyController.dispose();
    attractionsNearbyController.dispose();
    localDemandController.dispose();
    competitionLevelController.dispose();
    rentalPricesController.dispose();
    regulatoryFriendlinessController.dispose();
  }

  // navigation: step 1 -> step 2
  void goToStep2() {
    if (!_validateStep1()) return;
    Get.toNamed(RoutesName.locationPropertyDetailsScreen);
    Console.blue('Navigated to Step 2');
  }

  // step 2 -> step 3 (analyzing -> results)
  Future<void> analyzeLocation() async {
    if (!_validateStep2()) return;

    final requestData = _buildRequestData();

    try {
      isLoading.value = true;

      Get.toNamed(RoutesName.locationAnalyzingScreen);

      final response = await ApiService.postAuth(
        ApiEndpoints.locationSuitability,
        body: requestData,
      );

      if (response.statusCode == 201 && response.data != null) {
        final analysisId = response.data['id'];
        Console.green('Analysis created with id: $analysisId');
        _startPolling(analysisId);
      } else {
        _handleAnalysisError(response);
      }
    } catch (e) {
      Console.red('Error analyzing location: $e');
      CustomeSnackBar.error('Failed to analyze location. Please try again.');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // build request data from text controllers
  Map<String, dynamic> _buildRequestData() {
    return {
      'city_size': citySizeController.text.trim(),
      'district_type': districtTypeController.text.trim(),
      'demand_profile': demandProfileController.text.trim(),
      'public_transport': publicTransportController.text.trim(),
      'supermarkets_restaurants': supermarketsNearbyController.text.trim(),
      'universities_hospitals_offices': attractionsNearbyController.text.trim(),
      'local_demand': localDemandController.text.trim(),
      'competition_level': competitionLevelController.text.trim(),
      'short_term_prices': rentalPricesController.text.trim(),
      'regulatory_friendliness': regulatoryFriendlinessController.text.trim(),
    };
  }

  // start polling for analysis result
  void _startPolling(int analysisId) {
    _pollingAttempts = 0;
    isAnalyzing.value = true;

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      _pollingAttempts++;

      if (_pollingAttempts > _maxPollingAttempts) {
        _cancelPolling();
        CustomeSnackBar.error('Analysis is taking too long. Please try again.');
        Get.back();
        return;
      }

      await _checkAnalysisResult(analysisId);
    });
  }

  // check analysis result from api
  Future<void> _checkAnalysisResult(int analysisId) async {
    try {
      final response = await ApiService.getAuth(
        "${ApiEndpoints.locationSuitability}$analysisId/",
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['analysis_summary'] != null &&
            data['analysis_summary'] is Map &&
            (data['analysis_summary'] as Map).isNotEmpty) {
          _cancelPolling();
          _parseAnalysisResult(data['analysis_summary']);
          Get.offNamed(RoutesName.locationResultsScreen);
        }
      }
    } catch (e) {
      Console.red('Error checking analysis result: $e');
    }
  }

  // cancel polling timer
  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isAnalyzing.value = false;
  }

  // parse analysis result from api response
  void _parseAnalysisResult(Map<String, dynamic> summary) {
    try {
      final analysisResult = summary['analysis_result'];
      if (analysisResult == null) {
        Console.red('No analysis result found');
        return;
      }

      _parseSuitabilityScores(analysisResult['suitability_scores']);
      _parseLocationInsights(analysisResult['location_insights']);
      _parseRecommendations(analysisResult['admin_recommendations']);
      _parseRiskFactors(analysisResult['risk_factors']);
      _parseOverallRating(analysisResult['overall_rating']);

      bestUseCase.value = analysisResult['best_use_case'] ?? '';

      Console.green('Analysis result parsed successfully');
    } catch (e) {
      Console.red('Error parsing analysis result: $e');
    }
  }

  // parse suitability scores
  void _parseSuitabilityScores(Map<String, dynamic>? scores) {
    if (scores == null) return;

    final List<CategoryRating> ratings = [];

    final scoreMapping = {
      'senior_living_wg': 'Senior Living WG',
      'students': 'Students',
      'short_stay': 'Short Stay',
      'monteurzimmer': 'Monteurzimmer',
      'engineer_housing': 'Engineer Housing',
      'airbnb': 'Airbnb (optional)',
    };

    scoreMapping.forEach((key, name) {
      if (scores[key] != null) {
        final scoreData = scores[key];
        ratings.add(
          CategoryRating(
            name: name,
            rating: _parseDouble(scoreData['score']),
            reasoning: scoreData['reasoning'] ?? '',
          ),
        );
      }
    });

    categoryRatings.value = ratings;
  }

  // parse location insights
  void _parseLocationInsights(Map<String, dynamic>? insights) {
    if (insights == null) return;

    final List<LocationInsight> insightsList = [];

    if (insights['university_distance'] != null) {
      final data = insights['university_distance'];
      insightsList.add(
        LocationInsight(
          icon: 'university',
          title: 'Distance to University',
          value: data['estimate'] ?? '',
          subtitle: data['category'] ?? '',
        ),
      );
    }

    if (insights['public_transport_distance'] != null) {
      final data = insights['public_transport_distance'];
      final subtitle = [
        data['category'] ?? '',
        data['type'] ?? '',
      ].where((s) => s.isNotEmpty).join(' - ');

      insightsList.add(
        LocationInsight(
          icon: 'transport',
          title: 'Distance to Public Transport',
          value: data['estimate'] ?? '',
          subtitle: subtitle,
        ),
      );
    }

    if (insights['employers_nearby'] != null) {
      final data = insights['employers_nearby'];
      insightsList.add(
        LocationInsight(
          icon: 'employer',
          title: 'Nearby Employers',
          value: data['estimate'] ?? '',
          subtitle: data['typical_types'] ?? '',
        ),
      );
    }

    if (insights['hospitals_nearby'] != null) {
      final data = insights['hospitals_nearby'];
      insightsList.add(
        LocationInsight(
          icon: 'hospital',
          title: 'Nearby Hospitals',
          value: data['estimate'] ?? '',
          subtitle: data['availability'] ?? '',
        ),
      );
    }

    locationInsights.value = insightsList;
  }

  // parse recommendations
  void _parseRecommendations(List<dynamic>? recs) {
    if (recs == null) return;
    recommendations.value = recs.map((e) => e.toString()).toList();
  }

  // parse risk factors
  void _parseRiskFactors(List<dynamic>? risks) {
    if (risks == null) return;
    riskFactors.value = risks.map((e) => e.toString()).toList();
  }

  // parse overall rating
  void _parseOverallRating(Map<String, dynamic>? rating) {
    if (rating == null) return;
    overallRating.value = OverallRating(
      score: _parseDouble(rating['score']),
      summary: rating['summary'] ?? '',
    );
  }

  // safe double parsing
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // handle analysis error
  void _handleAnalysisError(ApiResponse response) {
    Console.red('Analysis failed: ${response.statusCode}');
    CustomeSnackBar.error(response.message ?? 'Failed to analyze location');
    Get.back();
  }

  // save analysis
  void saveAnalysis() {
    Console.green('Analysis saved');
    CustomeSnackBar.success('Analysis saved successfully!');
  }

  // start new analysis
  void startNewAnalysis() {
    _clearAllData();
    Get.offAllNamed(RoutesName.locationSuitabilityScreen);
    Console.blue('Starting new analysis');
  }

  // validation: step 1
  bool _validateStep1() {
    if (!seniorLivingWG.value &&
        !seniorLivingWG2.value &&
        !students.value &&
        !airbnbOptional.value &&
        !engineerHousing.value) {
      CustomeSnackBar.error('Please select at least one category');
      return false;
    }
    return true;
  }

  // validation: step 2
  bool _validateStep2() {
    final validations = [
      _ValidationItem(citySizeController.text, 'Please enter city size'),
      _ValidationItem(
        districtTypeController.text,
        'Please enter district type',
      ),
      _ValidationItem(
        demandProfileController.text,
        'Please enter demand profile',
      ),
      _ValidationItem(
        publicTransportController.text,
        'Please enter public transport info',
      ),
      _ValidationItem(
        supermarketsNearbyController.text,
        'Please enter supermarkets/restaurants info',
      ),
      _ValidationItem(
        attractionsNearbyController.text,
        'Please enter nearby attractions info',
      ),
      _ValidationItem(localDemandController.text, 'Please enter local demand'),
      _ValidationItem(
        competitionLevelController.text,
        'Please enter competition level',
      ),
      _ValidationItem(
        rentalPricesController.text,
        'Please enter rental prices',
      ),
      _ValidationItem(
        regulatoryFriendlinessController.text,
        'Please enter regulatory friendliness',
      ),
    ];

    for (var item in validations) {
      if (item.value.trim().isEmpty) {
        CustomeSnackBar.error(item.errorMessage);
        return false;
      }
    }

    return true;
  }

  // clear all data
  void _clearAllData() {
    // step 1
    seniorLivingWG.value = false;
    seniorLivingWG2.value = false;
    students.value = false;
    airbnbOptional.value = false;
    engineerHousing.value = false;

    // step 2: clear text controllers
    citySizeController.clear();
    districtTypeController.clear();
    demandProfileController.clear();
    publicTransportController.clear();
    supermarketsNearbyController.clear();
    attractionsNearbyController.clear();
    localDemandController.clear();
    competitionLevelController.clear();
    rentalPricesController.clear();
    regulatoryFriendlinessController.clear();

    // step 3: results
    categoryRatings.clear();
    locationInsights.clear();
    recommendations.clear();
    riskFactors.clear();
    overallRating.value = null;
    bestUseCase.value = '';

    Console.yellow('All data cleared');
  }

  // get selected categories as list
  List<String> getSelectedCategories() {
    List<String> selected = [];
    if (seniorLivingWG.value) selected.add('Senior Living WG');
    if (seniorLivingWG2.value) selected.add('Senior Living WG 2');
    if (students.value) selected.add('Students');
    if (airbnbOptional.value) selected.add('Airbnb (optional)');
    if (engineerHousing.value) selected.add('Engineer Housing');
    return selected;
  }
}

// models

class CategoryRating {
  final String name;
  final double rating;
  final String reasoning;

  CategoryRating({
    required this.name,
    required this.rating,
    this.reasoning = '',
  });
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

class OverallRating {
  final double score;
  final String summary;

  OverallRating({required this.score, required this.summary});
}

class _ValidationItem {
  final String value;
  final String errorMessage;

  _ValidationItem(this.value, this.errorMessage);
}
