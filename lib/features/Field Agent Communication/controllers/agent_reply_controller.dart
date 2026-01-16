import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';

class AgentReplyController extends GetxController {
  // Loading State
  final RxBool isRegenerateLoading = false.obs;

  // AI Response
  final RxString aiResponse = ''.obs;

  // Key Highlights
  final RxList<String> keyHighlights = <String>[].obs;

  // Original Data (for regeneration)
  String? propertyLink;
  String? notes;
  String? originalMessage;
  String? incomingEmail;

  @override
  void onInit() {
    super.onInit();
    _loadFromArguments();
  }

  // Load data from navigation arguments
  void _loadFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      Console.red('Error: No arguments passed to AgentReplyScreen');
      Get.back(); // Go back if no data
      return;
    }

    aiResponse.value = args['aiResponse'] ?? '';
    keyHighlights.value = List<String>.from(args['keyHighlights'] ?? []);

    notes = args['notes'];
    originalMessage = args['originalMessage'];
    incomingEmail = args['incomingEmail'];

    Console.cyan('AI Response: ${aiResponse.value}');
    Console.cyan('Highlights: ${keyHighlights.length} items');
  }

  // Regenerate Response based on type
  Future<void> regenerate() async {
    try {
      isRegenerateLoading.value = true;
      Console.blue('Regenerating ...');

      // TODO: Replace with actual API call based on type
      await Future.delayed(Duration(seconds: 2));

      _regenerateTenantReply();

      Console.green('Response regenerated successfully');
    } catch (e) {
      Console.red('Error: Failed to regenerate - $e');
    } finally {
      isRegenerateLoading.value = false;
    }
  }

  Future<void> _regenerateTenantReply() async {
    // TODO: API call with incomingEmail
    Console.cyan('Regenerating tenant reply');

    aiResponse.value =
        'Here is an alternative reply to the tenant. This version provides more detailed explanations and additional options.';

    keyHighlights.value = [
      'Detailed acknowledgment',
      'Multiple solutions offered',
      'Timeline expectations',
      'Follow-up commitment',
    ];
  }
}
