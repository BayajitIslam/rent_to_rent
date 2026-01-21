// controllers/navigation_controller.dart
import 'package:get/get.dart';
import 'package:rent2rent/routes/routes_name.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // Change Page
  void changePage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offAndToNamed(RoutesName.home);
        break;
      case 1:
        Get.offAndToNamed(RoutesName.createContractScreen);
        break;
      case 2:
        Get.offAndToNamed(RoutesName.contractAnalysisScreen);
        break;
      case 3:
        Get.offAndToNamed(RoutesName.locationSuitabilityScreen);
        break;
      case 4:
        Get.offAndToNamed(RoutesName.profile);
        break;
    }
  }

  // Set current page
  void setCurrentPage(int index) {
    currentIndex.value = index;
  }

  // Clear selection
  void clearSelection() {
    currentIndex.value = currentIndex.value;
  }
}
