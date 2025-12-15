import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/Create%20Contract/models/contract_type_model.dart';
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
  final TextEditingController propertyAddressController =
      TextEditingController();
  final RxString roomCount = ''.obs;
  final RxBool isFurnished = false.obs;

  // Rent Terms
  final RxString numberOfBeds = ''.obs;
  final TextEditingController monthlyRentController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController contractDurationController =
      TextEditingController();
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final RxBool confirmDetails = false.obs;

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
      ContractTypeModel(
        id: 'wg',
        name: 'WG',
        previewImage: 'assets/images/contract_preview.png',
      ),
      ContractTypeModel(
        id: 'short_stay',
        name: 'Short Stay/Temporary',
        previewImage: 'assets/images/contract_preview.png',
      ),
      ContractTypeModel(
        id: 'fully_furnished',
        name: 'Fully Furnished Unit',
        previewImage: 'assets/images/contract_preview.png',
      ),
      ContractTypeModel(
        id: 'type_4',
        name: 'Type 4',
        previewImage: 'assets/images/contract_preview.png',
      ),
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
      Console.red('Error: Please select a contract type');
      return;
    }
    Get.toNamed(RoutesName.fillContractDetailsScreen);
    Console.blue('Navigated to Fill Contract Details');
  }

  // Step 2 -> Step 3 (Generate Contract)
  Future<void> generateContract() async {
    if (!_validateStep2()) return;

    try {
      isLoading.value = true;
      Console.blue('Generating contract...');

      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Mock generated content
      partiesContent.value =
          'This Agreement (hereinafter the "Agreement") is entered into as of [Date] by and between the following parties. The Seller hereby agrees to sell and the Purchaser agrees to buy the Property described herein.';
      propertyDescContent.value =
          'The Property is described as follows: ${propertyAddressController.text}. The property consists of ${roomCount.value} with ${numberOfBeds.value}.';
      saleContent.value =
          'The Seller agrees to sell and the Purchaser agrees to purchase herein the "Property" located at the address mentioned above, subject to the terms and conditions set forth in this Agreement.';
      priceContent.value =
          'The purchase price to be paid by the Purchaser for the Property shall be ${monthlyRentController.text} per month with a deposit of ${depositController.text}.';

      Console.green('Contract generated successfully');

      // Navigate to Generate Contract Screen
      Get.toNamed(RoutesName.generateContractScreen);
    } catch (e) {
      Console.red('Error: Failed to generate contract - $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateStep2() {
    if (landlordNameController.text.trim().isEmpty) {
      Console.red('Error: Please enter landlord name');
      return false;
    }
    if (tenantNameController.text.trim().isEmpty) {
      Console.red('Error: Please enter tenant name');
      return false;
    }
    if (propertyAddressController.text.trim().isEmpty) {
      Console.red('Error: Please enter property address');
      return false;
    }
    if (!confirmDetails.value) {
      Console.red('Error: Please confirm contract details');
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
  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
    );
    if (picked != null) {
      startDate.value = picked;
      Console.cyan('Start date selected: $picked');
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
    propertyAddressController.dispose();
    monthlyRentController.dispose();
    depositController.dispose();
    contractDurationController.dispose();
    markdownNotesController.dispose();
    Console.yellow('CreateContractController disposed');
    super.onClose();
  }
}

// Contract Type Model
