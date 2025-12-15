import 'package:get/get.dart';
import 'package:rent2rent/features/Create%20Contract/controllers/create_contract_controller_.dart';

// Binding for Step 1 - Select Contract Type
class SelectContractTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateContractController>(() => CreateContractController());
  }
}

// Binding for Step 2 - Fill Contract Details
// Controller already exists, just find it
class FillContractDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Controller already put in Step 1, no need to put again
    // If navigating directly, put controller
    if (!Get.isRegistered<CreateContractController>()) {
      Get.lazyPut<CreateContractController>(() => CreateContractController());
    }
  }
}

// Binding for Step 3 - Generate Contract
// Controller already exists, just find it
class GenerateContractBinding extends Bindings {
  @override
  void dependencies() {
    // Controller already put in Step 1, no need to put again
    // If navigating directly, put controller
    if (!Get.isRegistered<CreateContractController>()) {
      Get.lazyPut<CreateContractController>(() => CreateContractController());
    }
  }
}
