import 'package:get/get.dart';
import 'package:rent2rent/features/Contract%20Analysis/controllers/contract_analysis_controller.dart';

// ============================================
// Binding
// ============================================
class ContractAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractAnalysisController>(() => ContractAnalysisController());
  }
}

// For screens that need existing controller
class ContractAnalysisChildBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ContractAnalysisController>()) {
      Get.lazyPut<ContractAnalysisController>(
        () => ContractAnalysisController(),
      );
    }
  }
}
