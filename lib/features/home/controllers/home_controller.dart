import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/services/local_storage/storage_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/controllers/navigation_controller.dart';
import 'package:rent2rent/routes/routes_name.dart';

class HomeController extends GetxController {
  // loading state
  final RxBool isLoading = false.obs;

  // user info
  final RxString userName = ''.obs;
  final RxString userImage = ''.obs;

  // filter
  final RxString selectedFilter = 'ALL'.obs;
  final List<String> filterOptions = [
    'ALL',
    'Contract',
    'Analysis',
    'Location',
    'Email',
  ];

  // recent activities
  final RxList<ActivityModel> recentActivities = <ActivityModel>[].obs;
  final RxList<ActivityModel> allActivities = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    loadRecentActivities();
    Console.green('HomeController initialized');
  }

  // load user data
  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    userName.value = name.isNotEmpty ? name : 'User';
  }

  // load recent activities from api
  Future<void> loadRecentActivities() async {
    try {
      isLoading.value = true;
      Console.blue('Loading recent activities...');

      final response = await ApiService.getAuth(ApiEndpoints.recentActivities);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Console.green('Recent activities loaded');

        final List<ActivityModel> activities = [];

        // parse contract creation
        if (data['contact_creation_file'] != null) {
          final contract = data['contact_creation_file'];
          activities.add(
            ActivityModel(
              id: '${contract['id']}',
              title: _truncateTitle(contract['title'] ?? 'Contract'),
              address: contract['file'] ?? '',
              date: _formatDate(contract['created_at']),
              status: 'OK',
              type: 'contract',
            ),
          );
        }

        // parse email reply draft
        if (data['email_reply_draft'] != null) {
          final email = data['email_reply_draft'];
          activities.add(
            ActivityModel(
              id: '${email['id']}',
              title: email['generated_email_subject'] ?? 'Email Draft',
              address: _truncateText(email['generated_email_body'] ?? '', 50),
              date: _formatDate(email['created_at']),
              status: 'Draft',
              type: 'email',
            ),
          );
        }

        // parse contract analysis
        if (data['contract_analysis'] != null) {
          final analysis = data['contract_analysis'];
          final result = analysis['contract_analysis_result'];
          activities.add(
            ActivityModel(
              id: '${analysis['id']}',
              title: 'Contract Analysis',
              address: result != null ? (result['contract_summary'] ?? '') : '',
              date: _formatDate(analysis['created_at']),
              status: _getAnalysisStatus(result),
              type: 'analysis',
            ),
          );
        }

        // parse location suitability
        if (data['location_suitability'] != null) {
          final location = data['location_suitability'];
          final summary = location['analysis_summary'];
          final analysisResult = summary != null
              ? summary['analysis_result']
              : null;

          activities.add(
            ActivityModel(
              id: '${location['id']}',
              title: 'Location: ${location['city_size'] ?? ''}',
              address:
                  '${location['district_type'] ?? ''}, ${location['demand_profile'] ?? ''}',
              date: _formatDate(location['created_at']),
              status: _getLocationStatus(analysisResult),
              type: 'location',
            ),
          );
        }

        allActivities.value = activities;
        recentActivities.value = activities;

        Console.green('Parsed ${activities.length} activities');
      } else {
        Console.red('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      Console.red('Error loading activities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // filter activities
  void filterActivities(String filter) {
    selectedFilter.value = filter;

    if (filter == 'ALL') {
      recentActivities.value = allActivities;
    } else {
      final typeMap = {
        'Contract': 'contract',
        'Analysis': 'analysis',
        'Location': 'location',
        'Email': 'email',
      };

      final filterType = typeMap[filter] ?? '';
      recentActivities.value = allActivities
          .where((a) => a.type == filterType)
          .toList();
    }

    Console.cyan('Filtered by: $filter (${recentActivities.length} items)');
  }

  // show filter options
  void showFilterOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: filterOptions.map((option) {
            return ListTile(
              title: Text(option),
              trailing: selectedFilter.value == option
                  ? Icon(Icons.check, color: Get.theme.primaryColor)
                  : null,
              onTap: () {
                filterActivities(option);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // helper: format date
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else {
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
      }
    } catch (e) {
      return dateStr;
    }
  }

  // helper: truncate title
  String _truncateTitle(String text) {
    if (text.length > 25) {
      return '${text.substring(0, 25)}...';
    }
    return text;
  }

  // helper: truncate text
  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  // helper: get analysis status from result
  String _getAnalysisStatus(Map<String, dynamic>? result) {
    if (result == null) return 'Pending';
    final rating = result['overall_rating']?.toString().toLowerCase() ?? '';
    if (rating == 'green') return 'OK';
    if (rating == 'red') return 'Risk';
    return 'Review';
  }

  // helper: get location status from result
  String _getLocationStatus(Map<String, dynamic>? result) {
    if (result == null) return 'Pending';
    final score = result['overall_rating']?['score'] ?? 0;
    if (score >= 4.0) return 'OK';
    if (score >= 3.0) return 'Good';
    return 'Review';
  }

  // navigation methods
  void goToNotifications() {
    Get.toNamed(RoutesName.splash);
  }

  void goToContractCreation() {
    NavigationController controller = Get.find<NavigationController>();
    controller.setCurrentPage(1);
    Get.toNamed(RoutesName.createContractScreen);
  }

  void goToCheckIncoming() {
    NavigationController controller = Get.find<NavigationController>();
    controller.setCurrentPage(2);
    Get.toNamed(RoutesName.contractAnalysisScreen);
  }

  void goToLocationSuitability() {
    NavigationController controller = Get.find<NavigationController>();
    controller.setCurrentPage(3);
    Get.toNamed(RoutesName.locationSuitabilityScreen);
  }

  void goToFieldAgent() {
    NavigationController controller = Get.find<NavigationController>();
    controller.setCurrentPage(-1);
    Get.toNamed(RoutesName.fieldAgentScreen);
  }
}

// activity model
class ActivityModel {
  final String id;
  final String title;
  final String address;
  final String date;
  final String status;
  final String type;

  ActivityModel({
    required this.id,
    required this.title,
    required this.address,
    required this.date,
    required this.status,
    this.type = '',
  });
}
