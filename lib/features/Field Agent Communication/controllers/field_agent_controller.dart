import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class FieldAgentController extends GetxController {
  // Text Controllers
  final TextEditingController notesController = TextEditingController();
  final TextEditingController incomingEmailController = TextEditingController();

  // Loading States
  final RxBool isGenerateReplyLoading = false.obs;

  // Recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  // Generate Reply - Navigate to AgentReplyScreen
  Future<void> generateReply() async {
    if (incomingEmailController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please paste an incoming email');
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
    notesController.dispose();
    incomingEmailController.dispose();
    Console.yellow('FieldAgentController disposed');
    super.onClose();
  }
}
