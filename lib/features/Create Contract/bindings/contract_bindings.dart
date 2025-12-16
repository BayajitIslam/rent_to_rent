import 'package:get/get.dart';
import 'package:rent2rent/features/Create%20Contract/controllers/create_contract_controller_.dart';

class ContractBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateContractController(), fenix: true);
  }
}
