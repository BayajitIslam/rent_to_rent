import 'package:get/get.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/controllers/agent_reply_controller.dart';

class AgentReplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AgentReplyController(), fenix: true);
  }
}
