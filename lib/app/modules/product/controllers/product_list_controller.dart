import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/product_provider.dart';
import 'dart:convert';

class ProductListController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var products = [].obs;
  var isLoading = false.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalProducts = 0.obs;
  final int pageSize = 21;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _provider.getProducts(page: currentPage.value, size: pageSize);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        products.value = data['items'];
        totalProducts.value = data['total'];
      }
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value * pageSize < totalProducts.value) {
      currentPage.value++;
      fetchProducts();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchProducts();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _provider.deleteProduct(id);
      if (response.statusCode == 204) {
        fetchProducts();
        Get.snackbar("Success", "Product deleted", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
