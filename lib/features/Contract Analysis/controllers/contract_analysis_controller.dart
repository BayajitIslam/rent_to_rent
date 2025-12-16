import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';

class ContractAnalysisController extends GetxController {
  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // File
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString fileName = ''.obs;

  // Analysis Result
  final RxString overallRating = 'Green'.obs;
  final RxString overallRatingColor = 'green'.obs;

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

  // Analyze Contract
  Future<void> analyzeContract() async {
    if (selectedFile.value == null) {
      Console.red('Error: Please select a PDF file');
      return;
    }

    try {
      isLoading.value = true;

      // Navigate to Analyzing Screen
      Get.toNamed(RoutesName.contractAnalyzingScreen);

      isAnalyzing.value = true;
      Console.blue('Analyzing contract...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 3));

      // Mock response data
      _loadMockAnalysisData();

      Console.green('Contract analysis completed');

      // Navigate to Report Screen
      Get.offNamed(RoutesName.contractAnalysisReportScreen);
    } catch (e) {
      Console.red('Error analyzing contract: $e');
      Get.back();
    } finally {
      isLoading.value = false;
      isAnalyzing.value = false;
    }
  }

  // Regenerate Analysis
  Future<void> regenerateAnalysis() async {
    try {
      isLoading.value = true;
      Console.blue('Regenerating analysis...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Reload mock data or call API again
      _loadMockAnalysisData();

      Console.green('Analysis regenerated');
    } catch (e) {
      Console.red('Error regenerating analysis: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Download Report
  void downloadReport() {
    Console.green('Downloading report...');
    // TODO: Implement PDF download
  }

  // Save Report
  void saveReport() {
    Console.green('Saving report...');
    // TODO: Implement save functionality
  }

  // Load Mock Analysis Data
  void _loadMockAnalysisData() {
    overallRating.value = 'Green';
    overallRatingColor.value = 'green';

    contractSummary.value =
        'A quick overview of your contract\'s safety, risks, and missing elements — analyzed by AI.';

    // Summary Insight
    summaryInsightTitle.value = 'SUMMARY INSIGHT';
    summaryInsightDescription.value =
        'Your contract contains a few clauses that need final review.';
    summaryInsightVariations.value = [
      'Your contract is mostly safe, with a few points worth revisiting.',
      'Several sections need clarification before signing.',
      'Multiple risks detected — please review the red flags.',
      'Your contract appears strong, with only minor gaps.',
    ];

    // Safe Clauses
    safeClausesTitle.value = 'SAFE CLAUSES SECTION';
    safeClausesDescription.value =
        'Your contract contains a few clauses that need final review.';
    safeClausesVariations.value = [
      'Your contract is mostly safe, with a few points worth revisiting.',
      'Several sections need clarification before signing.',
      'Multiple risks detected — please review the red flags.',
      'Your contract appears strong, with only minor gaps.',
    ];

    // Red Flags
    redFlagsTitle.value = 'RED FLAGS SECTION';
    redFlagsDescription.value =
        'These are clauses that may create legal, financial, or operational risk.';
    redFlagsVariations.value = [
      'Unclear termination conditions — The contract does not define how either party can end the agreement.',
      'No liability limit — You may be responsible for unlimited damages.',
      'One-sided payment terms — The payment obligations favor the other party significantly.',
      'Missing dispute resolution method — No process is defined if conflicts arise.',
    ];

    // Warnings
    warningsTitle.value = 'WARNINGS SECTION';
    warningsDescription.value =
        'These may not be dangerous alone but require attention.';
    warningsItems.value = [
      'Ambiguous delivery deadlines — Timelines are mentioned but not clearly defined.',
      'Incomplete confidentiality terms — The clause does not specify the duration of confidentiality.',
      'Generic warranty language — Warranty coverage is unclear or too broad.',
      'Renewal terms unclear — Automatic renewal is mentioned but conditions are missing.',
    ];

    // Admin Recommendations
    recommendations.value = [
      'This area is high demand for engineers.',
      'Avoid short-term rentals in first 12 months.',
      'Make sure contract includes noise clause.',
    ];
  }

  // Clear Data
  void clearData() {
    selectedFile.value = null;
    fileName.value = '';
    Console.yellow('Data cleared');
  }

  @override
  void onClose() {
    Console.yellow('ContractAnalysisController disposed');
    super.onClose();
  }
}
