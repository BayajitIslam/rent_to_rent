import 'package:get/get.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';

import '../../../core/constants/api_endpoints.dart';

class AgentReplyController extends GetxController {
  // loading state
  final RxBool isRegenerateLoading = false.obs;

  // ai response data
  final RxString aiResponse = ''.obs;
  final RxString subject = ''.obs;
  final RxString incomingEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // delayed to ensure screen is ready
    Future.delayed(Duration.zero, () {
      _loadFromArguments();
    });
  }

  // load data from navigation arguments
  void _loadFromArguments() {
    final args = Get.arguments;

    if (args == null) {
      Console.red('Warning: No arguments passed to AgentReplyScreen');
      aiResponse.value = 'No response available';
      return;
    }

    aiResponse.value = args['aiResponse'] ?? 'No response available';
    subject.value = args['subject'] ?? '';
    incomingEmail.value = args['incomingEmail'] ?? '';

    Console.cyan('AI Response loaded');
  }

  // regenerate response
  Future<void> regenerate() async {
    if (incomingEmail.value.isEmpty) {
      CustomeSnackBar.error('No incoming email found');
      return;
    }

    try {
      isRegenerateLoading.value = true;
      Console.blue('Regenerating reply...');

      final response = await ApiService.postAuth(
        ApiEndpoints.emailReplyDraft,
        body: {
          'original_email_body': incomingEmail.value,
          'reply_guidance': '',
        },
      );

      if (response.success || response.statusCode == 201) {
        final Map<String, dynamic> data = response.data;

        aiResponse.value = data['generated_email_body'] ?? '';
        subject.value = data['generated_email_subject'] ?? '';

        Console.green('Response regenerated successfully');
        CustomeSnackBar.success('Reply regenerated');
      } else if (response.statusCode == 400) {
        final data = response.data;
        final String message = data['message'] ?? 'Something went wrong';
        Console.info(message);
        CustomeSnackBar.error(message);
      } else {
        CustomeSnackBar.error('Failed to regenerate reply');
      }
    } catch (e) {
      Console.red('Error: Failed to regenerate - $e');
      CustomeSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isRegenerateLoading.value = false;
    }
  }
}
