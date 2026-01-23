import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/Create%20Contract/models/contract_type_model.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class CreateContractController extends GetxController {
  // loading state
  final RxBool isLoading = false.obs;

  // step 1: contract type
  final RxString selectedContractType = ''.obs;
  final RxList<ContractTypeModel> contractTypes = <ContractTypeModel>[].obs;

  // step 2: form controllers
  late final TextEditingController landlordNameController;
  late final TextEditingController landlordAddressController;
  late final TextEditingController landlordEmailController;
  late final TextEditingController tenantNameController;
  late final TextEditingController tenantAddressController;
  late final TextEditingController tenantEmailController;
  late final TextEditingController rentalObjectController;
  late final TextEditingController apartmentNumberController;
  late final TextEditingController contractLimitationController;
  late final TextEditingController utilitiesAmountController;
  late final TextEditingController monthlyRentController;
  late final TextEditingController depositController;
  late final TextEditingController contractDurationController;
  late final TextEditingController limitationExplanationController;
  late final TextEditingController markdownNotesController;

  // step 2: reactive fields
  final RxString propertyType = 'entire_apartment'.obs;
  final RxString roomCount = ''.obs;
  final RxBool isFurnished = false.obs;
  final RxBool isPlusUtilities = false.obs;
  final RxBool isFlatRate = false.obs;
  final RxBool confirmDetails = false.obs;
  final RxString limitationReason = ''.obs;

  // dates
  final Rx<DateTime?> contractEndDate = Rx<DateTime?>(null);
  final Rx<DateTime?> contractStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);

  // result
  final RxString resultPdfUrl = ''.obs;

  // recommendations
  final RxList<String> recommendations = <String>[].obs;

  // step 3: generated contract
  final RxString partiesContent = ''.obs;
  final RxString propertyDescContent = ''.obs;
  final RxString saleContent = ''.obs;
  final RxString priceContent = ''.obs;
  final RxBool analyzeThis = false.obs;
  final RxList<String> notes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _loadContractTypes();
    _loadRecommendations();
    Console.green('CreateContractController initialized');
  }

  @override
  void onClose() {
    _disposeControllers();
    Console.yellow('CreateContractController disposed');
    super.onClose();
  }

  // initialize text controllers
  void _initControllers() {
    landlordNameController = TextEditingController();
    landlordAddressController = TextEditingController();
    landlordEmailController = TextEditingController();
    tenantNameController = TextEditingController();
    tenantAddressController = TextEditingController();
    tenantEmailController = TextEditingController();
    rentalObjectController = TextEditingController();
    apartmentNumberController = TextEditingController();
    contractLimitationController = TextEditingController();
    utilitiesAmountController = TextEditingController();
    monthlyRentController = TextEditingController();
    depositController = TextEditingController();
    contractDurationController = TextEditingController();
    limitationExplanationController = TextEditingController();
    markdownNotesController = TextEditingController();
  }

  // dispose text controllers
  void _disposeControllers() {
    landlordNameController.dispose();
    landlordAddressController.dispose();
    landlordEmailController.dispose();
    tenantNameController.dispose();
    tenantAddressController.dispose();
    tenantEmailController.dispose();
    rentalObjectController.dispose();
    apartmentNumberController.dispose();
    contractLimitationController.dispose();
    utilitiesAmountController.dispose();
    monthlyRentController.dispose();
    depositController.dispose();
    contractDurationController.dispose();
    limitationExplanationController.dispose();
    markdownNotesController.dispose();
  }

  // load contract types
  void _loadContractTypes() {
    contractTypes.value = [
      ContractTypeModel(id: 'Ingenieurswohnung', name: 'Ingenieurswohnung'),
      ContractTypeModel(id: 'Monteurswohnung', name: 'Monteurswohnung'),
      ContractTypeModel(id: 'WG-Zimmer', name: 'WG-Zimmer'),
      ContractTypeModel(id: 'Senioren-WG', name: 'Senioren-WG'),
    ];
    Console.green('Contract types loaded: ${contractTypes.length}');
  }

  // load recommendations
  void _loadRecommendations() {
    recommendations.value = [
      'This area is high demand for engineers.',
      'Avoid short-term rentals in first 12 months.',
      'Make sure contract includes noise clause.',
    ];
  }

  // select contract type
  void selectContractType(String id) {
    selectedContractType.value = id;
    update();
    Console.cyan('Selected contract type: $id');
  }

  // step 1 -> step 2
  void goToFillContractDetails() {
    if (selectedContractType.value.isEmpty) {
      CustomeSnackBar.error('Please select a contract type');
      return;
    }
    Get.toNamed(RoutesName.fillContractDetailsScreen);
    Console.blue('Navigated to Fill Contract Details');
  }

  // step 2 -> step 3 (generate contract)
  Future<void> generateContract() async {
    if (!_validateStep2()) return;

    try {
      isLoading.value = true;
      Console.blue('Generating contract...');

      final data = _buildContractData();

      final response = await ApiService.postAuth(
        ApiEndpoints.generateContract,
        body: data,
      );

      if (response.statusCode == 201 && response.data != null) {
        final responseData = response.data;

        resultPdfUrl.value = _getString(responseData['pdf_url']);

        Console.green('Contract generated successfully');
        Console.green('PDF URL: ${resultPdfUrl.value}');

        Get.toNamed(RoutesName.generateContractScreen);
      } else if (response.statusCode == 400) {
        Console.red('Validation error: ${response.data}');
        CustomeSnackBar.error(response.message ?? 'Invalid contract data');
      } else {
        Console.red('Error: ${response.statusCode}');
        CustomeSnackBar.error('Failed to generate contract');
      }
    } catch (e) {
      Console.red('Error generating contract: $e');
      CustomeSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // build contract data for api
  Map<String, dynamic> _buildContractData() {
    return {
      "contact_type": selectedContractType.value,
      "landlord_name": landlordNameController.text.trim(),
      "landlord_address": landlordAddressController.text.trim(),
      "landlord_email": landlordEmailController.text.trim(),
      "tenant_name": tenantNameController.text.trim(),
      "tenant_address": tenantAddressController.text.trim(),
      "tenant_email": tenantEmailController.text.trim(),
      "property_address": rentalObjectController.text.trim(),
      "property_appartment_number": apartmentNumberController.text.trim(),
      "property_room_count": _parseRoomCount(roomCount.value),
      "property_is_furnished": isFurnished.value,
      "rent_type": isFlatRate.value ? "flat rate" : "plus utilities",
      "rent_amount": _parseDouble(monthlyRentController.text),
      "rent_contact_start_date": _formatDate(contractStartDate.value),
      "rent_contact_end_date": _formatDate(contractEndDate.value),
      "rent_reason_contract_limitations": limitationReason.value,
      "rent_term_monthly_rent": _parseDouble(monthlyRentController.text),
      "rent_security_deposit": _parseDouble(depositController.text),
      "rent_contract_duration_months": _parseInt(
        contractDurationController.text,
      ),
      "rent_start_date": _formatDate(startDate.value),
      "contract_limitation_reason": limitationReason.value,
      "contract_limitation_details": limitationExplanationController.text
          .trim(),
    };
  }

  // validate step 2
  bool _validateStep2() {
    final validations = [
      _ValidationItem(
        landlordNameController.text.trim().isNotEmpty,
        'Please enter landlord name',
      ),
      _ValidationItem(
        tenantNameController.text.trim().isNotEmpty,
        'Please enter tenant name',
      ),
      _ValidationItem(
        rentalObjectController.text.trim().isNotEmpty,
        'Please enter property address',
      ),
      _ValidationItem(
        GetUtils.isEmail(landlordEmailController.text.trim()),
        'Please enter valid landlord email',
      ),
      _ValidationItem(
        GetUtils.isEmail(tenantEmailController.text.trim()),
        'Please enter valid tenant email',
      ),
      _ValidationItem(
        contractStartDate.value != null,
        'Please select contract start date',
      ),
      _ValidationItem(
        contractEndDate.value != null,
        'Please select contract end date',
      ),
      _ValidationItem(startDate.value != null, 'Please select rent start date'),
      _ValidationItem(confirmDetails.value, 'Please confirm contract details'),
    ];

    for (var item in validations) {
      if (!item.isValid) {
        CustomeSnackBar.error(item.errorMessage);
        Console.red('Validation error: ${item.errorMessage}');
        return false;
      }
    }

    // validate dates
    if (contractStartDate.value != null && contractEndDate.value != null) {
      if (contractEndDate.value!.isBefore(contractStartDate.value!)) {
        CustomeSnackBar.error('End date must be after start date');
        return false;
      }
    }

    return true;
  }

  // select date picker
  Future<void> selectStartDate(Rx<DateTime?> date) async {
    try {
      final pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: date.value ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        date.value = pickedDate;
        Console.cyan('Date selected: ${_formatDate(pickedDate)}');
      }
    } catch (e) {
      Console.red('Error selecting date: $e');
    }
  }

  // save as draft
  void saveAsDraft() {
    Console.green('Contract saved as draft');
    CustomeSnackBar.success('Draft saved');
  }

  // download pdf
  void downloadPdf() {
    if (resultPdfUrl.value.isEmpty) {
      CustomeSnackBar.error('No PDF available');
      return;
    }
    Console.green('Downloading PDF: ${resultPdfUrl.value}');
    // todo: implement pdf download
  }

  // download word
  void downloadWord() {
    Console.green('Downloading Word document...');
    // todo: implement word download
  }

  // download contract
  void downloadContract() {
    Console.green('Download contract...');
  }

  // save contract
  void saveContract() {
    Console.green('Contract saved');
    CustomeSnackBar.success('Contract saved');
  }

  // send for e-signature
  Future<void> sendForESignature() async {
    if (resultPdfUrl.value.isEmpty) {
      CustomeSnackBar.error('No contract available');
      return;
    }

    try {
      isLoading.value = true;
      Console.blue('Sending for e-signature...');

      // todo: replace with actual api call
      await Future.delayed(Duration(seconds: 2));

      Console.green('Contract sent for e-signature');
      CustomeSnackBar.success('Contract sent for e-signature');

      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      Console.red('Error sending for e-signature: $e');
      CustomeSnackBar.error('Failed to send for e-signature');
    } finally {
      isLoading.value = false;
    }
  }

  // add note
  void addNote() {
    final note = markdownNotesController.text.trim();
    if (note.isEmpty) {
      CustomeSnackBar.error('Please enter a note');
      return;
    }

    notes.add(note);
    markdownNotesController.clear();
    Console.cyan('Note added. Total notes: ${notes.length}');
  }

  // remove note
  void removeNote(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
      Console.cyan('Note removed. Total notes: ${notes.length}');
    }
  }

  // clear all data
  void clearAllData() {
    selectedContractType.value = '';
    propertyType.value = 'entire_apartment';
    roomCount.value = '';
    isFurnished.value = false;
    isPlusUtilities.value = false;
    isFlatRate.value = false;
    confirmDetails.value = false;
    limitationReason.value = '';
    contractEndDate.value = null;
    contractStartDate.value = null;
    startDate.value = null;
    resultPdfUrl.value = '';
    notes.clear();

    landlordNameController.clear();
    landlordAddressController.clear();
    landlordEmailController.clear();
    tenantNameController.clear();
    tenantAddressController.clear();
    tenantEmailController.clear();
    rentalObjectController.clear();
    apartmentNumberController.clear();
    contractLimitationController.clear();
    utilitiesAmountController.clear();
    monthlyRentController.clear();
    depositController.clear();
    contractDurationController.clear();
    limitationExplanationController.clear();
    markdownNotesController.clear();

    Console.yellow('All data cleared');
  }

  // helper: format date
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // helper: parse room count
  int _parseRoomCount(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  // helper: parse double
  double _parseDouble(String value) {
    return double.tryParse(value.trim()) ?? 0.0;
  }

  // helper: parse int
  int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  // helper: safe string
  String _getString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}

// validation item
class _ValidationItem {
  final bool isValid;
  final String errorMessage;

  _ValidationItem(this.isValid, this.errorMessage);
}
