import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/section_provider.dart';
import '../../../data/providers/product_provider.dart';
import 'dart:convert';

class SectionManagementController extends GetxController {
  final SectionProvider _sectionProvider = SectionProvider();
  final ProductProvider _productProvider = ProductProvider();

  var sections = <dynamic>[].obs;
  var allProducts = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSections();
    fetchAllProducts();
  }

  Future<void> fetchSections() async {
    try {
      isLoading.value = true;
      final response = await _sectionProvider.getAllSections();
      print("fetch sections: body ${response.body},, statuscode: ${response.statusCode}");
      if (response.statusCode == 200) {
        sections.value = jsonDecode(response.body);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllProducts() async {
    final response = await _productProvider.getProducts();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      allProducts.value = data['items'] ?? [];
    }
  }

  Future<void> createSection(String name, int orderIndex) async {
    final response = await _sectionProvider.createSection({
      "name": name,
      "order_index": orderIndex,
      "is_active": true,
    });
    print("create section: body ${response.body},, statuscode: ${response.statusCode}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      fetchSections();
      Get.back();
      Get.snackbar("Success", "Section created");
    }
  }

  Future<void> deleteSection(int id) async {
    final response = await _sectionProvider.deleteSection(id);
    if (response.statusCode == 200) {
      fetchSections();
      Get.snackbar("Success", "Section deleted");
    }
  }

  Future<void> toggleSectionStatus(int id, bool status) async {
      await _sectionProvider.updateSection(id, {"is_active": status});
      fetchSections();
  }

  Future<void> assignProduct(int sectionId, int productId) async {
    final response = await _sectionProvider.assignProduct(sectionId, productId);
    if (response.statusCode == 200) {
      fetchSections();
      Get.snackbar("Success", "Product assigned to section");
    }
  }

  Future<void> removeProduct(int sectionId, int productId) async {
    final response = await _sectionProvider.removeProduct(sectionId, productId);
    if (response.statusCode == 200) {
      fetchSections();
      Get.snackbar("Success", "Product removed from section");
    }
  }
}
