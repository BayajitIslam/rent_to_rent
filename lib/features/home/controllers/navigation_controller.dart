// controllers/navigation_controller.dart
import 'package:get/get.dart';
import 'package:template/routes/routes_name.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs; // Default to 0 instead of -1

  // Change Page
  void changePage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed(RoutesName.home);
        break;
      case 1:
        Get.toNamed(RoutesName.createContractScreen);
        break;
      case 2:
        Get.toNamed(RoutesName.contractAnalysisScreen);
        break;
      case 3:
        Get.toNamed(RoutesName.locationSuitabilityScreen);
        break;
      case 4:
        Get.toNamed(RoutesName.profile);
        break;
    }
  }

  // Set current page
  void setCurrentPage(int index) {
    currentIndex.value = index;
  }

  // Clear selection
  void clearSelection() {
    currentIndex.value = -1;
  }
}
