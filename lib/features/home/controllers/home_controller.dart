import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/home/controllers/navigation_controller.dart';
import 'package:template/routes/routes_name.dart';

class HomeController extends GetxController {
  // User Info
  final RxString userName = 'Nairobi'.obs;
  final RxString userImage = ''.obs;

  // Filter
  final RxString selectedFilter = 'ALL'.obs;
  final List<String> filterOptions = ['ALL', 'OK', 'Draft', 'Pending'];

  // Recent Activities
  final RxList<ActivityModel> recentActivities = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadRecentActivities();
  }

  // Load User Data
  void loadUserData() {
    // TODO: Load from API or SharedPreferences
    userName.value = 'Nairobi';
  }

  // Load Recent Activities
  void loadRecentActivities() {
    // TODO: Replace with API call
    recentActivities.value = [
      ActivityModel(
        id: '1',
        title: 'Riverside Apartments',
        address: '123 Thames St, London',
        date: '2h ago',
        status: 'OK',
      ),
      ActivityModel(
        id: '2',
        title: 'Riverside Apartments',
        address: '123 Thames St, London',
        date: '13 December,2022',
        status: 'OK',
      ),
      ActivityModel(
        id: '3',
        title: 'Riverside Apartments',
        address: '123 Thames St, London',
        date: '2 January,2022',
        status: 'OK',
      ),
      ActivityModel(
        id: '4',
        title: 'Riverside Apartments',
        address: '123 Thames St, London',
        date: '13 December,2022',
        status: 'Draft',
      ),
    ];
  }

  // Filter Activities
  void filterActivities(String filter) {
    selectedFilter.value = filter;
    // TODO: Filter logic
  }

  // Show Filter Options
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

  // Navigation Methods
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

// Activity Model
class ActivityModel {
  final String id;
  final String title;
  final String address;
  final String date;
  final String status;

  ActivityModel({
    required this.id,
    required this.title,
    required this.address,
    required this.date,
    required this.status,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'date': date,
      'status': status,
    };
  }
}
