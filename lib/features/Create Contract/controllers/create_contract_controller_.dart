import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/Create%20Contract/models/contract_type_model.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class CreateContractController extends GetxController {
  // Loading State
  final RxBool isLoading = false.obs;

  // ==================== STEP 1: Contract Type ====================
  final RxString selectedContractType = ''.obs;
  final RxList<ContractTypeModel> contractTypes = <ContractTypeModel>[].obs;

  // ==================== STEP 2: Form Fields ====================
  // Property Type
  final RxString propertyType = 'entire_apartment'.obs;

  // Landlord Info
  final TextEditingController landlordNameController = TextEditingController();
  final TextEditingController landlordAddressController =
      TextEditingController();
  final TextEditingController landlordEmailController = TextEditingController();

  // Tenant Info
  final TextEditingController tenantNameController = TextEditingController();
  final TextEditingController tenantAddressController = TextEditingController();
  final TextEditingController tenantEmailController = TextEditingController();

  // Property Details
  final TextEditingController rentalObjectController = TextEditingController();
  final TextEditingController apartmentNumberController =
      TextEditingController();
  final RxString roomCount = ''.obs;
  final RxBool isFurnished = false.obs;

  // Monthly Rent
  final TextEditingController contractLimitationController =
      TextEditingController();
  final TextEditingController utilitiesAmountController =
      TextEditingController();
  final Rx<DateTime?> contractEndDate = Rx<DateTime?>(null);
  final Rx<DateTime?> contractStartDate = Rx<DateTime?>(null);
  final RxBool isPlusUtilities = false.obs;
  final RxBool isFlatRate = false.obs;

  // Rent Terms
  final TextEditingController monthlyRentController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController contractDurationController =
      TextEditingController();
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final RxBool confirmDetails = false.obs;

  //limitation
  final RxString limitationReason = ''.obs;

  final TextEditingController limitationExplanationController =
      TextEditingController();

  //result
  final RxString resultPdfUrl = ''.obs;

  // Recommendations
  final RxList<String> recommendations = <String>[
    'This area is high demand for engineers.',
    'Avoid short-term rentals in first 12 months.',
    'Make sure contract includes noise clause.',
  ].obs;

  // ==================== STEP 3: Generated Contract ====================
  final RxString partiesContent = ''.obs;
  final RxString propertyDescContent = ''.obs;
  final RxString saleContent = ''.obs;
  final RxString priceContent = ''.obs;
  final RxBool analyzeThis = false.obs;
  final TextEditingController markdownNotesController = TextEditingController();
  final RxList<String> notes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadContractTypes();
  }

  // Load Contract Types
  void loadContractTypes() {
    contractTypes.value = [
      ContractTypeModel(id: 'Ingenieurswohnung', name: 'Ingenieurswohnung'),
      ContractTypeModel(id: 'Monteurswohnung', name: 'Monteurswohnung'),
      ContractTypeModel(id: 'wg_zimmer', name: 'WG-Zimmer'),
      ContractTypeModel(id: 'type_4', name: 'Type 4'),
    ];
    Console.green('Contract types loaded: ${contractTypes.length}');
  }

  void selectContractType(String id) {
    selectedContractType.value = id;
    update();
    Console.cyan('Selected contract type: $id');
  }
  // ==================== Navigation ====================

  // Step 1 -> Step 2
  void goToFillContractDetails() {
    if (selectedContractType.value.isEmpty) {
      // Show error
      CustomeSnackBar.error('Please select a contract type');
      Console.red('Error: Please select a contract type');
      return;
    }
    Get.toNamed(RoutesName.fillContractDetailsScreen);
    Console.blue('Navigated to Fill Contract Details');
  }

  // Step 2 -> Step 3 (Generate Contract)
  Future<void> generateContract() async {
    if (!_validateStep2()) return;

    // Helper to format date as YYYY-MM-DD
    String formatDate(DateTime? date) {
      if (date == null) return '';
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }

    // Helper to parse room count
    int parseRoomCount(String value) {
      final match = RegExp(r'\d+').firstMatch(value);
      return match != null ? int.parse(match.group(0)!) : 0;
    }

    final data = {
      "contact_type": selectedContractType.value,
      "landlord_name": landlordNameController.text.trim(),
      "landlord_address": landlordAddressController.text.trim(),
      "landlord_email": landlordEmailController.text.trim(),
      "tenant_name": tenantNameController.text.trim(),
      "tenant_address": tenantAddressController.text.trim(),
      "tenant_email": tenantEmailController.text.trim(),
      "property_address": rentalObjectController.text.trim(),
      "property_appartment_number": apartmentNumberController.text.trim(),
      "property_room_count": parseRoomCount(roomCount.value),
      "property_is_furnished": isFurnished.value,
      "rent_type": isFlatRate.value ? "flat rate" : "plus utilities",
      "rent_amount": double.tryParse(monthlyRentController.text) ?? 0.0,
      "rent_contact_start_date": formatDate(contractStartDate.value),
      "rent_contact_end_date": formatDate(contractEndDate.value),
      "rent_reason_contract_limitations": limitationReason.value,
      "rent_term_monthly_rent":
          double.tryParse(monthlyRentController.text) ?? 0.0,
      "rent_security_deposit": double.tryParse(depositController.text) ?? 0.0,
      "rent_contract_duration_months":
          int.tryParse(contractDurationController.text) ?? 0,
      "rent_start_date": formatDate(startDate.value),
      "contract_limitation_reason": limitationReason.value,
      "contract_limitation_details": limitationExplanationController.text
          .trim(),
    };

    try {
      isLoading.value = true;
      Console.blue('Generating contract...');

      final response = await ApiService.postAuth(
        ApiEndpoints.generateContract,
        body: data,
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        Console.info('responseData: ${responseData.toString()}');
        Console.green(responseData['message']);
        Console.green(responseData['pdf_url']);

        resultPdfUrl.value = responseData['pdf_url'];
        // Navigate to Generate Contract Screen
        Get.toNamed(RoutesName.generateContractScreen);
      } else if (response.statusCode == 400) {
        Console.red('Error: Failed to generate contract - ${response.data}');
      }
    } catch (e) {
      Console.red('Error: Failed to generate contract - $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateStep2() {
    if (landlordNameController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please enter landlord name');
      Console.red('Error: Please enter landlord name');
      return false;
    }
    if (tenantNameController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please enter tenant name');
      Console.red('Error: Please enter tenant name');
      return false;
    }
    if (rentalObjectController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please enter property address');
      Console.red('Error: Please enter property address');
      return false;
    }
    if (!confirmDetails.value) {
      CustomeSnackBar.error('Please confirm contract details');
      Console.red('Error: Please confirm contract details');
      return false;
    }
    if (startDate.value == null) {
      CustomeSnackBar.error('Please select start date');
      Console.red('Error: Please select start date');
      return false;
    }
    if (contractEndDate.value == null) {
      CustomeSnackBar.error('Please select end date');
      Console.red('Error: Please select end date');
      return false;
    }
    if (contractStartDate.value == null) {
      CustomeSnackBar.error('Please select start date');
      Console.red('Error: Please select start date');
      return false;
    }
    if (contractEndDate.value == null) {
      CustomeSnackBar.error('Please select end date');
      Console.red('Error: Please select end date');
      return false;
    }
    return true;
  }

  // ==================== Actions ====================

  // Save as Draft
  void saveAsDraft() {
    Console.green('Contract saved as draft');
    // TODO: Save to local storage or API
  }

  // Select Start Date
  Future<void> selectStartDate(Rx<DateTime?> date) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: date.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      date.value = pickedDate;
    }
  }

  // Download PDF
  void downloadPdf() {
    Console.green('Downloading PDF...');
    // TODO: Implement PDF download
  }

  // Download Word
  void downloadWord() {
    Console.green('Downloading Word document...');
    // TODO: Implement Word download
  }

  // Download Contract (from AppBar)
  void downloadContract() {
    Console.green('Download contract...');
    // Show download options or direct download
  }

  // Save Contract (from AppBar)
  void saveContract() {
    Console.green('Contract saved');
    // TODO: Save to database
  }

  // Send for E-Signature
  Future<void> sendForESignature() async {
    try {
      isLoading.value = true;
      Console.blue('Sending for e-signature...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      Console.green('Contract sent for e-signature');

      // Navigate to success or home
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      Console.red('Error: Failed to send for e-signature - $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add Note
  void addNote() {
    if (markdownNotesController.text.trim().isNotEmpty) {
      notes.add(markdownNotesController.text.trim());
      markdownNotesController.clear();
      Console.cyan('Note added. Total notes: ${notes.length}');
    }
  }

  @override
  void onClose() {
    landlordNameController.dispose();
    landlordAddressController.dispose();
    landlordEmailController.dispose();
    tenantNameController.dispose();
    tenantAddressController.dispose();
    tenantEmailController.dispose();
    rentalObjectController.dispose();
    apartmentNumberController.dispose();
    monthlyRentController.dispose();
    depositController.dispose();
    contractDurationController.dispose();
    markdownNotesController.dispose();
    Console.yellow('CreateContractController disposed');
    super.onClose();
  }
}

// Contract Type Model
