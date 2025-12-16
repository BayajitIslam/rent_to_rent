import 'package:get/get.dart';
import 'package:rent2rent/features/Contract%20Analysis/controllers/contract_analysis_controller.dart';

class ContractAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContractAnalysisController(), fenix: true);
  }
}
