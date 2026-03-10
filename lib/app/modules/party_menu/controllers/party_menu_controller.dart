import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/providers/party_menu_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/services/cloudinary_service.dart';

class PartyMenuController extends GetxController {
  final PartyMenuProvider _provider = PartyMenuProvider();
  final ProductProvider _productProvider = ProductProvider();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  var partyMenus = [].obs;
  var isLoading = false.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalItems = 0.obs;
  final int pageSize = 21;

  // Form Fields & State
  var isEditing = false.obs;
  var currentMenuId = RxnInt();

  // Form Fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  var selectedImageUrl = "".obs;
  var selectedProducts = [].obs; // List of product objects
  var isUploading = false.obs;

  // Search Products for Adding to Menu
  var searchResults = [].obs;
  var isSearching = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPartyMenus();
  }

  Future<void> fetchPartyMenus() async {
    try {
      isLoading.value = true;
      final response = await _provider.getPartyMenus(page: currentPage.value, size: pageSize);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        partyMenus.value = data['items'];
        totalItems.value = data['total'];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load party menus: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value * pageSize < totalItems.value) {
      currentPage.value++;
      fetchPartyMenus();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchPartyMenus();
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    try {
      isSearching.value = true;
      final response = await _productProvider.getProducts(page: 1, size: 10); // Simple search
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List allProducts = data['items'];
        // Filter locally for now or modify provider for server-side search
        searchResults.value = allProducts.where((p) => 
          p['name'].toString().toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    } finally {
      isSearching.value = false;
    }
  }

  void addProductToMenu(Map<String, dynamic> product) {
    if (!selectedProducts.any((p) => p['id'] == product['id'])) {
      selectedProducts.add(product);
    }
    searchResults.clear();
    searchController.clear();
  }

  void removeProductFromMenu(int id) {
    selectedProducts.removeWhere((p) => p['id'] == id);
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        isUploading.value = true;
        final String? url = await _cloudinaryService.uploadImage(image);
        if (url != null) {
          selectedImageUrl.value = url;
          Get.snackbar("Success", "Image uploaded successfully", backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar("Error", "Failed to upload image", backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Error picking image: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploading.value = false;
    }
  }

  void populateForm(Map<String, dynamic> menu) {
    isEditing.value = true;
    currentMenuId.value = menu['id'];
    titleController.text = menu['title'] ?? "";
    descriptionController.text = menu['description'] ?? "";
    priceController.text = (menu['price'] ?? 0).toString();
    categoryController.text = menu['category'] ?? "";
    selectedImageUrl.value = menu['image_url'] ?? "";
    
    // Extract products from nested items
    if (menu['items'] != null) {
      selectedProducts.value = (menu['items'] as List).map((item) => item['product']).toList();
    } else {
      selectedProducts.clear();
    }
  }

  Future<void> savePartyMenu() async {
    if (titleController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar("Error", "Title and Price are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final data = {
        "title": titleController.text,
        "description": descriptionController.text,
        "image_url": selectedImageUrl.value,
        "price": double.parse(priceController.text),
        "category": categoryController.text,
        "product_ids": selectedProducts.map((p) => p['id']).toList(),
      };

      final response = isEditing.value 
          ? await _provider.updatePartyMenu(currentMenuId.value!, data)
          : await _provider.createPartyMenu(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close form
        fetchPartyMenus();
        clearForm();
        Get.snackbar("Success", isEditing.value ? "Party Menu updated" : "Party Menu created", 
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePartyMenu(int id) async {
    try {
      final response = await _provider.deletePartyMenu(id);
      if (response.statusCode == 200) {
        fetchPartyMenus();
        Get.snackbar("Success", "Menu deleted");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete: $e");
    }
  }

  void clearForm() {
    isEditing.value = false;
    currentMenuId.value = null;
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    categoryController.clear();
    selectedImageUrl.value = "";
    selectedProducts.clear();
  }
}
