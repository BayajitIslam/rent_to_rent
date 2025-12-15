import 'package:get/get.dart';

import 'package:template/features/Field%20Agent%20Communication/controllers/field_agent_controller.dart';

class FieldAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FieldAgentController(), fenix: true);
  }
}
