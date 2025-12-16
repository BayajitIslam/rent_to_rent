import 'package:get/get.dart';
import 'package:rent2rent/features/Location%20Suitability/controllers/location_suitability_controller.dart';

class LocationSuitabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationSuitabilityController(), fenix: true);
  }
}
