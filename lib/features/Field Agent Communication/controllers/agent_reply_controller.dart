import 'package:get/get.dart';
import 'package:template/core/utils/log.dart';

class AgentReplyController extends GetxController {
  // Loading State
  final RxBool isRegenerateLoading = false.obs;

  // Response Type (agent_inquiry, friendly_message, tenant_reply)
  final RxString responseType = ''.obs;

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

    responseType.value = args['type'] ?? '';
    aiResponse.value = args['aiResponse'] ?? '';
    keyHighlights.value = List<String>.from(args['keyHighlights'] ?? []);

    // Store original data for regeneration
    propertyLink = args['propertyLink'];
    notes = args['notes'];
    originalMessage = args['originalMessage'];
    incomingEmail = args['incomingEmail'];

    Console.green('AgentReplyScreen loaded with type: ${responseType.value}');
    Console.cyan('AI Response: ${aiResponse.value}');
    Console.cyan('Highlights: ${keyHighlights.length} items');
  }

  // Regenerate Response based on type
  Future<void> regenerate() async {
    try {
      isRegenerateLoading.value = true;
      Console.blue('Regenerating ${responseType.value}...');

      // TODO: Replace with actual API call based on type
      await Future.delayed(Duration(seconds: 2));

      switch (responseType.value) {
        case 'agent_inquiry':
          await _regenerateAgentInquiry();
          break;
        case 'friendly_message':
          await _regenerateFriendlyMessage();
          break;
        case 'tenant_reply':
          await _regenerateTenantReply();
          break;
        default:
          Console.red('Unknown response type: ${responseType.value}');
      }

      Console.green('Response regenerated successfully');
    } catch (e) {
      Console.red('Error: Failed to regenerate - $e');
    } finally {
      isRegenerateLoading.value = false;
    }
  }

  Future<void> _regenerateAgentInquiry() async {
    // TODO: API call with propertyLink and notes
    Console.cyan('Regenerating with propertyLink: $propertyLink');

    aiResponse.value =
        'Here is an updated analysis based on the listing. This property offers excellent value with modern amenities and prime location advantages.';

    keyHighlights.value = [
      'Updated neighborhood insights',
      'Revised property strengths',
      'New buyer considerations',
      'Target demographic profile',
      'Pricing recommendations',
    ];
  }

  Future<void> _regenerateFriendlyMessage() async {
    // TODO: API call with originalMessage
    Console.cyan('Regenerating friendly message');

    aiResponse.value =
        'Here is an alternative friendly response with a different approach. This version is more casual while still maintaining professionalism.';

    keyHighlights.value = [
      'Warm introduction',
      'Empathetic response',
      'Clear action items',
      'Open-ended closing',
    ];
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
