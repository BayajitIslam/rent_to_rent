import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

import '../../../core/constants/api_endpoints.dart';

class FieldAgentController extends GetxController {
  // text controllers
  final TextEditingController notesController = TextEditingController();
  final TextEditingController incomingEmailController = TextEditingController();

  // loading states
  final RxBool isGenerateReplyLoading = false.obs;

  // recommendations list
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  // generate reply and navigate to agent reply screen
  Future<void> generateReply() async {
    if (incomingEmailController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please paste an incoming email');
      Console.red('Error: Please paste an incoming email');
      return;
    }

    if (notesController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please enter notes');
      Console.red('Error: Please enter notes');
      return;
    }

    try {
      isGenerateReplyLoading.value = true;
      Console.blue('Generating reply...');

      final response = await ApiService.postAuth(
        ApiEndpoints.emailReplyDraft,
        body: {
          'original_email_body': incomingEmailController.text,
          'reply_guidance': notesController.text,
        },
      );

      if (response.success || response.statusCode == 201) {
        Console.info('Reply generated successfully');

        final Map<String, dynamic> data = response.data;

        // navigate to agent reply screen with data
        Get.toNamed(
          RoutesName.agentReplyScreen,
          arguments: {
            'subject': data['generated_email_subject'] ?? '',
            'aiResponse': data['generated_email_body'] ?? '',
            'incomingEmail': incomingEmailController.text,
          },
        );
      } else if (response.statusCode == 400) {
        final data = response.data;
        final String message = data['message'] ?? 'Something went wrong';
        Console.info(message);
        CustomeSnackBar.error(message);
      } else {
        CustomeSnackBar.error('Failed to generate reply');
      }
    } catch (e) {
      Console.red('Error: Failed to generate reply - $e');
      CustomeSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isGenerateReplyLoading.value = false;
    }
  }

  // load admin recommendations from api
  Future<void> loadRecommendations() async {
    Console.cyan('Loading recommendations...');
    // todo: replace with actual api call
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
