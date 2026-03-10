import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../../data/providers/category_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/services/cloudinary_service.dart';

class ProductController extends GetxController {
  final ProductProvider _productProvider = ProductProvider();
  final CategoryProvider _categoryProvider = CategoryProvider();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  var categories = [].obs;
  var selectedCategoryId = Rxn<int>();
  
  var isLoading = false.obs;
  var isEdit = false.obs;
  int? editingProductId;

  var selectedImage = Rxn<XFile>();
  var selectedImageBytes = Rxn<Uint8List>();
  var uploadedImageUrl = "".obs;

  // Variations: List of maps with 'name' and 'price'
  var variations = <Map<String, dynamic>>[
    {"name": "For 1 person", "price": 0.0},
  ].obs;

  var priceControllers = <TextEditingController>[].obs;
  var nameControllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    
    // Sync form whenever the selected product in HomeController changes
    final homeController = Get.find<HomeController>();
    ever(homeController.selectedProduct, (_) => syncFormWithState());
    
    // Initial sync
    syncFormWithState();
  }

  void addVariation() {
    variations.add({"name": "", "price": 0.0});
    nameControllers.add(TextEditingController(text: ""));
    priceControllers.add(TextEditingController(text: "0.0"));
  }

  void removeVariation(int index) {
    if (variations.length > 1) {
      variations.removeAt(index);
      nameControllers[index].dispose();
      nameControllers.removeAt(index);
      priceControllers[index].dispose();
      priceControllers.removeAt(index);
    } else {
      Get.snackbar("Info", "At least one variation is required", backgroundColor: Colors.blue, colorText: Colors.white);
    }
  }

  void syncFormWithState() {
    final homeController = Get.find<HomeController>();
    // Only sync if we are actually viewing the Product Add/Edit page (index 3)
    if (homeController.selectedIndex.value != 3) return;

    // Clear existing controllers
    for (var c in nameControllers) {
      c.dispose();
    }
    for (var c in priceControllers) {
      c.dispose();
    }
    nameControllers.clear();
    priceControllers.clear();

    if (homeController.selectedProduct.value != null) {
      isEdit.value = true;
      final product = homeController.selectedProduct.value;
      editingProductId = product['id'];
      
      titleController.text = product['name'];
      descriptionController.text = product['description'] ?? "";
      selectedCategoryId.value = product['category_id'];
      uploadedImageUrl.value = product['image_url'] ?? "";
      selectedImage.value = null;
      selectedImageBytes.value = null;
      
      if (product['variations'] != null) {
        final List vars = product['variations'];
        variations.value = vars.map((v) => {
          "name": v['name'],
          "price": (v['price'] as num).toDouble()
        }).toList();

        for (var v in variations) {
          nameControllers.add(TextEditingController(text: v['name']));
          priceControllers.add(TextEditingController(text: v['price'].toString()));
        }
      }
    } else {
      // Clear fields for New Product
      isEdit.value = false;
      editingProductId = null;
      titleController.clear();
      descriptionController.clear();
      selectedCategoryId.value = null;
      uploadedImageUrl.value = "";
      selectedImage.value = null;
      selectedImageBytes.value = null;
      
      // Reset variations to one default
      variations.value = [
        {"name": "For 1 person", "price": 0.0},
      ];
      
      nameControllers.add(TextEditingController(text: variations[0]['name']));
      priceControllers.add(TextEditingController(text: "0.0"));
    }
  }

  @override
  void onClose() {
    for (var c in nameControllers) {
      c.dispose();
    }
    for (var c in priceControllers) {
      c.dispose();
    }
    super.onClose();
  }

  Future<void> fetchCategories() async {
    final response = await _categoryProvider.getCategories();
    if (response.statusCode == 200) {
      categories.value = jsonDecode(response.body);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
      selectedImageBytes.value = await image.readAsBytes();
    }
  }

  Future<void> createProduct() async {
    if (selectedCategoryId.value == null || titleController.text.isEmpty) {
      Get.snackbar("Error", "Please fill required fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      // Upload image if selected
      if (selectedImage.value != null) {
        final imageUrl = await _cloudinaryService.uploadImage(selectedImage.value!);
        if (imageUrl == null || imageUrl.isEmpty) {
          Get.snackbar("Error", "Failed to upload image. Please check your Cloudinary settings (Unsigned Preset).", 
            backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
          isLoading.value = false;
          return;
        }
        uploadedImageUrl.value = imageUrl;
      }

      // Sync prices/names from controllers to variations list
      final List<Map<String, dynamic>> finalVariations = [];
      for (int i = 0; i < nameControllers.length; i++) {
        finalVariations.add({
          "name": nameControllers[i].text,
          "price": double.tryParse(priceControllers[i].text) ?? 0.0
        });
      }

      final productData = {
        "name": titleController.text,
        "description": descriptionController.text,
        "category_id": selectedCategoryId.value,
        "image_url": uploadedImageUrl.value,
        "variations": finalVariations,
      };

      final response = isEdit.value 
          ? await _productProvider.updateProduct(editingProductId!, productData)
          : await _productProvider.createProduct(productData);

      print("Product Save Response Body: ${response.body}, statuscode: ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.find<HomeController>().changeIndex(2);
        Get.snackbar("Success", isEdit.value ? "Product updated" : "Product created", 
          backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['detail'] ?? "Failed to save product", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
