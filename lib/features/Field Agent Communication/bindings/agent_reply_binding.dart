import 'package:get/get.dart';
import 'package:template/features/Field%20Agent%20Communication/controllers/agent_reply_controller.dart';

class AgentReplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AgentReplyController(), fenix: true);
  }
}
