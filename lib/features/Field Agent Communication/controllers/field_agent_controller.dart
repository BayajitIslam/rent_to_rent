import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';
class FieldAgentController extends GetxController {
  // Text Controllers
  final TextEditingController propertyLinkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController agentMessageController = TextEditingController();
  final TextEditingController incomingEmailController = TextEditingController();

  // Loading States
  final RxBool isAskAILoading = false.obs;
  final RxBool isGenerateMessageLoading = false.obs;
  final RxBool isGenerateReplyLoading = false.obs;

  // Recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  // Ask AI - Navigate to AgentReplyScreen with response
  Future<void> askAI() async {
    if (propertyLinkController.text.trim().isEmpty) {
      Console.red('Error: Please enter a property link');
      return;
    }

    try {
      isAskAILoading.value = true;
      Console.blue('Asking AI...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Mock response data
      final String aiResponse =
          'Based on the listing title and your notes, here is a structured overview of key property details, potential buyer questions, and recommended talking points.';

      final List<String> keyHighlights = [
        'Neighborhood overview',
        'Property strengths',
        'Potential buyer objections',
        'Ideal buyer profile',
      ];

      Console.green('Success: AI response generated!');

      // Navigate to AgentReplyScreen with data
      Get.toNamed(
        RoutesName.agentReplyScreen,
        arguments: {
          'type': 'agent_inquiry',
          'aiResponse': aiResponse,
          'keyHighlights': keyHighlights,
          'propertyLink': propertyLinkController.text.trim(),
          'notes': notesController.text.trim(),
        },
      );
    } catch (e) {
      Console.red('Error: Failed to generate response - $e');
    } finally {
      isAskAILoading.value = false;
    }
  }

  // Generate Friendly First Message - Navigate to AgentReplyScreen
  Future<void> generateFriendlyMessage() async {
    if (agentMessageController.text.trim().isEmpty) {
      Console.red('Error: Please paste an agent message');
      return;
    }

    try {
      isGenerateMessageLoading.value = true;
      Console.blue('Generating friendly message...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Mock response data
      final String aiResponse =
          'Here is a friendly and professional response to the agent message. This reply maintains a warm tone while addressing all key points.';

      final List<String> keyHighlights = [
        'Professional greeting',
        'Address main concerns',
        'Propose next steps',
        'Friendly closing',
      ];

      Console.green('Success: Friendly message generated!');

      // Navigate to AgentReplyScreen with data
      Get.toNamed(
        RoutesName.agentReplyScreen,
        arguments: {
          'type': 'friendly_message',
          'aiResponse': aiResponse,
          'keyHighlights': keyHighlights,
          'originalMessage': agentMessageController.text.trim(),
        },
      );
    } catch (e) {
      Console.red('Error: Failed to generate message - $e');
    } finally {
      isGenerateMessageLoading.value = false;
    }
  }

  // Generate Reply - Navigate to AgentReplyScreen
  Future<void> generateReply() async {
    if (incomingEmailController.text.trim().isEmpty) {
      Console.red('Error: Please paste an incoming email');
      return;
    }

    try {
      isGenerateReplyLoading.value = true;
      Console.blue('Generating reply...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Mock response data
      final String aiResponse =
          'Here is a professional reply to the tenant email. This response addresses their concerns and provides clear next steps.';

      final List<String> keyHighlights = [
        'Acknowledge their message',
        'Address specific concerns',
        'Provide solutions',
        'Set expectations',
      ];

      Console.green('Success: Reply generated!');

      // Navigate to AgentReplyScreen with data
      Get.toNamed(
        RoutesName.agentReplyScreen,
        arguments: {
          'type': 'tenant_reply',
          'aiResponse': aiResponse,
          'keyHighlights': keyHighlights,
          'incomingEmail': incomingEmailController.text.trim(),
        },
      );
    } catch (e) {
      Console.red('Error: Failed to generate reply - $e');
    } finally {
      isGenerateReplyLoading.value = false;
    }
  }

  // Load Admin Recommendations
  Future<void> loadRecommendations() async {
    Console.cyan('Loading recommendations...');
    recommendations.value = [
      'This area is high demand for engineers.',
      'Avoid short-term rentals in first 12 months.',
      'Make sure contract includes noise clause.',
    ];
    Console.green('Recommendations loaded: ${recommendations.length}');
  }

  @override
  void onClose() {
    propertyLinkController.dispose();
    notesController.dispose();
    agentMessageController.dispose();
    incomingEmailController.dispose();
    Console.yellow('FieldAgentController disposed');
    super.onClose();
  }
}
