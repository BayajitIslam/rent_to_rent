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
  // loading states
  final RxBool isLoading = false.obs;
  final RxBool isAnalyzing = false.obs;

  // polling
  Timer? _pollingTimer;
  int _pollingAttempts = 0;
  static const int _maxPollingAttempts = 60;

  // file
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString fileName = ''.obs;

  // analysis result
  final RxString overallRating = ''.obs;
  final RxString overallRatingColor = ''.obs;

  // contract summary
  final RxString contractSummary = ''.obs;

  // summary insight
  final RxString summaryInsightTitle = ''.obs;
  final RxString summaryInsightDescription = ''.obs;
  final RxList<String> summaryInsightVariations = <String>[].obs;

  // safe clauses
  final RxString safeClausesTitle = ''.obs;
  final RxString safeClausesDescription = ''.obs;
  final RxList<String> safeClausesVariations = <String>[].obs;

  // red flags
  final RxString redFlagsTitle = ''.obs;
  final RxString redFlagsDescription = ''.obs;
  final RxList<String> redFlagsVariations = <String>[].obs;

  // warnings
  final RxString warningsTitle = ''.obs;
  final RxString warningsDescription = ''.obs;
  final RxList<String> warningsItems = <String>[].obs;

  // admin recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  @override
  void onClose() {
    _cancelPolling();
    Console.yellow('ContractAnalysisController disposed');
    super.onClose();
  }

  // pick pdf file
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        fileName.value = result.files.single.name;
        Console.green('File selected: ${fileName.value}');
      }
    } catch (e) {
      Console.red('Error picking file: $e');
      CustomeSnackBar.error('Failed to pick file');
    }
  }

  // analyze contract
  Future<void> analyzeContract() async {
    if (selectedFile.value == null) {
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
        if (data == null || data['id'] == null) {
          CustomeSnackBar.error('Invalid response from server');
          return;
        }

        Console.info('Analysis started with id: ${data['id']}');
        Get.toNamed(RoutesName.contractAnalyzingScreen);
        _startPolling(data['id']);
      } else if (response.statusCode == 400) {
        Console.info('${response.data}');
        CustomeSnackBar.error(response.message ?? 'Invalid request');
      } else {
        Console.info("Something is wrong");
        CustomeSnackBar.error('Failed to start analysis');
      }
    } catch (e) {
      Console.red('Error analyzing contract: $e');
      CustomeSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // start polling for analysis result
  void _startPolling(int analysisId) {
    _pollingAttempts = 0;
    isAnalyzing.value = true;

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      _pollingAttempts++;

      if (_pollingAttempts > _maxPollingAttempts) {
        _cancelPolling();
        CustomeSnackBar.error('Analysis is taking too long. Please try again.');
        Get.back();
        return;
      }

      await _checkAnalysisResult(analysisId);
    });
  }

  // check analysis result
  Future<void> _checkAnalysisResult(int analysisId) async {
    try {
      final response = await ApiService.getAuth(
        "${ApiEndpoints.contractcheck}$analysisId/",
      );

      Console.info("${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        Console.info('$responseData');

        if (responseData['contract_analysis_result'] != null &&
            responseData['contract_analysis_result'] is Map &&
            (responseData['contract_analysis_result'] as Map).isNotEmpty) {
          final contractAnalysisResult =
              responseData['contract_analysis_result'];
          Console.info('$contractAnalysisResult');

          _cancelPolling();
          mapContractAnalysisResult(contractAnalysisResult);
          Get.toNamed(RoutesName.contractAnalysisReportScreen);
        }
      }
    } catch (e) {
      Console.red('Error analyzing contract: $e');
    }
  }

  // cancel polling
  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isAnalyzing.value = false;
  }

  // mapping the contract analysis result to variables
  void mapContractAnalysisResult(Map<String, dynamic> contractAnalysisResult) {
    // set overall rating and color
    overallRating.value = _getString(contractAnalysisResult['overall_rating']);
    overallRatingColor.value = _getString(
      contractAnalysisResult['overall_rating_color'],
    );

    // set contract summary
    contractSummary.value = _getString(
      contractAnalysisResult['contract_summary'],
    );

    // set summary insight
    summaryInsightTitle.value = 'SUMMARY INSIGHT';
    summaryInsightDescription.value = _getString(
      contractAnalysisResult['summary_insight'],
    );
    summaryInsightVariations.value = _parseStringList(
      contractAnalysisResult['possible_variations'],
    );

    // set safe clauses
    safeClausesTitle.value = 'SAFE CLAUSES SECTION';
    safeClausesDescription.value = _parseClauseDescriptions(
      contractAnalysisResult['safe_clauses'],
    );
    safeClausesVariations.value = _parseClauseTitles(
      contractAnalysisResult['safe_clauses'],
    );

    // set red flags
    redFlagsTitle.value = 'RED FLAGS SECTION';
    redFlagsDescription.value = _parseClauseDescriptions(
      contractAnalysisResult['red_flags'],
    );
    redFlagsVariations.value = _parseClauseTitles(
      contractAnalysisResult['red_flags'],
    );

    // set warnings
    warningsTitle.value = 'WARNINGS SECTION';
    warningsDescription.value = _parseClauseDescriptions(
      contractAnalysisResult['warnings'],
    );
    warningsItems.value = _parseClauseTitles(
      contractAnalysisResult['warnings'],
    );

    Console.green('Contract analysis result mapped successfully');
  }

  // helper: safe string extraction
  String _getString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  // helper: parse string list
  List<String> _parseStringList(dynamic list) {
    if (list == null || list is! List) return [];
    return list.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
  }

  // helper: parse clause titles
  List<String> _parseClauseTitles(dynamic list) {
    if (list == null || list is! List) return [];
    return list
        .map((item) => item is Map ? _getString(item['title']) : '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // helper: parse clause descriptions
  String _parseClauseDescriptions(dynamic list) {
    if (list == null || list is! List) return '';
    return list
        .map((item) => item is Map ? _getString(item['description']) : '')
        .where((s) => s.isNotEmpty)
        .join('\n');
  }

  // clear data
  void clearData() {
    selectedFile.value = null;
    fileName.value = '';
    Console.yellow('Data cleared');
  }
}
