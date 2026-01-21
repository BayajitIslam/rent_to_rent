import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class ContractAnalysisController extends GetxController {
  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // File
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString fileName = ''.obs;

  // Analysis Result
  final RxString overallRating = ''.obs;
  final RxString overallRatingColor = ''.obs;

  // Contract Summary
  final RxString contractSummary = ''.obs;

  // Summary Insight
  final RxString summaryInsightTitle = ''.obs;
  final RxString summaryInsightDescription = ''.obs;
  final RxList<String> summaryInsightVariations = <String>[].obs;

  // Safe Clauses
  final RxString safeClausesTitle = ''.obs;
  final RxString safeClausesDescription = ''.obs;
  final RxList<String> safeClausesVariations = <String>[].obs;

  // Red Flags
  final RxString redFlagsTitle = ''.obs;
  final RxString redFlagsDescription = ''.obs;
  final RxList<String> redFlagsVariations = <String>[].obs;

  // Warnings
  final RxString warningsTitle = ''.obs;
  final RxString warningsDescription = ''.obs;
  final RxList<String> warningsItems = <String>[].obs;

  // Admin Recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  // Pick PDF File
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        fileName.value = result.files.single.name;
        Console.green('File selected: ${fileName.value}');
      }
    } catch (e) {
      Console.red('Error picking file: $e');
    }
  }

  //Anaylyze Contract
  Future<void> analyzeContract() async {
    if (selectedFile.value == null) {
      Console.red('Error: Please select a PDF file');
      CustomeSnackBar.error('Please select a PDF file');
      return;
    }

    try {
      isLoading.value = true;
      final response = await ApiService.uploadMultipart(
        method: "POST",
        url: ApiEndpoints.contractcheck,
        files: {'contract_file': selectedFile.value!},
      );
      if (response.statusCode == 202 ||
          response.statusCode == 201 ||
          response.statusCode == 200) {
        final data = response.data;
        Console.info('$data');
        // Navigate to Analyzing Screen
        Get.toNamed(RoutesName.contractAnalyzingScreen);

        isAnalyzing.value = true;
        Console.blue('Analyzing contract...');

        // Timer to repeatedly check for the contract analysis result
        Timer.periodic(Duration(seconds: 1), (timer) async {
          try {
            final contractCheckResponse = await ApiService.getAuth(
              "${ApiEndpoints.contractcheck}${data['id']}/",
            );

            Console.info("${contractCheckResponse.statusCode}");
            if (contractCheckResponse.statusCode == 200) {
              final responseData = contractCheckResponse.data;
              Console.info('$responseData');

              if (responseData['contract_analysis_result'] != null &&
                  responseData['contract_analysis_result'].isNotEmpty) {
                final contractAnalysisResult =
                    responseData['contract_analysis_result'];
                Console.info('$contractAnalysisResult');

                // Stop the timer and navigate if result is available
                timer.cancel();
                mapContractAnalysisResult(contractAnalysisResult);

                Get.toNamed(RoutesName.contractAnalysisReportScreen);
              }
            }
          } catch (e) {
            Console.red('Error analyzing contract: $e');
            Get.back();
            timer.cancel(); // Stop the timer on error
          }
        });
      } else if (response.statusCode == 400) {
        final data = response.data;
        Console.info('$data');
      } else {
        Console.info("Something is wrong");
      }
    } catch (e) {
      Console.red('Error analyzing contract: $e');
      Get.back();
    } finally {
      isLoading.value = false;
      isAnalyzing.value = false;
    }
  }

  // Clear Data
  void clearData() {
    selectedFile.value = null;
    fileName.value = '';
    Console.yellow('Data cleared');
  }

  @override
  void onClose() {
    clearData();
    Console.yellow('ContractAnalysisController disposed');
    super.onClose();
  }

  // Mapping the contract analysis result to variables
  void mapContractAnalysisResult(Map<String, dynamic> contractAnalysisResult) {
    // Set overall rating and color
    overallRating.value = contractAnalysisResult['overall_rating'];
    overallRatingColor.value = contractAnalysisResult['overall_rating_color'];

    // Set contract summary
    contractSummary.value = contractAnalysisResult['contract_summary'];

    // Set Summary Insight
    summaryInsightTitle.value = 'SUMMARY INSIGHT';
    summaryInsightDescription.value = contractAnalysisResult['summary_insight'];
    summaryInsightVariations.value = List<String>.from(
      contractAnalysisResult['possible_variations'],
    );

    // Set Safe Clauses
    safeClausesTitle.value = 'SAFE CLAUSES SECTION';
    safeClausesDescription.value =
        contractAnalysisResult['safe_clauses'] != null
        ? contractAnalysisResult['safe_clauses']
              .map((clause) => clause['description'])
              .join('\n')
        : '';
    safeClausesVariations.value = contractAnalysisResult['safe_clauses'] != null
        ? List<String>.from(
            contractAnalysisResult['safe_clauses'].map(
              (clause) => clause['title'],
            ),
          )
        : [];

    // Set Red Flags
    redFlagsTitle.value = 'RED FLAGS SECTION';
    redFlagsDescription.value = contractAnalysisResult['red_flags'] != null
        ? contractAnalysisResult['red_flags']
              .map((flag) => flag['description'])
              .join('\n')
        : '';
    redFlagsVariations.value = contractAnalysisResult['red_flags'] != null
        ? List<String>.from(
            contractAnalysisResult['red_flags'].map((flag) => flag['title']),
          )
        : [];

    // Set Warnings
    warningsTitle.value = 'WARNINGS SECTION';
    warningsDescription.value = contractAnalysisResult['warnings'] != null
        ? contractAnalysisResult['warnings']
              .map((warning) => warning['description'])
              .join('\n')
        : '';
    warningsItems.value = contractAnalysisResult['warnings'] != null
        ? List<String>.from(
            contractAnalysisResult['warnings'].map(
              (warning) => warning['title'],
            ),
          )
        : [];
  }
}
