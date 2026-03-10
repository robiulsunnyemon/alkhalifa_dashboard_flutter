import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(), // Placeholder for flex
                Row(
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.black54),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(Get.find<HomeController>().adminName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        Obx(() => Text(Get.find<HomeController>().adminRole.value, style: const TextStyle(color: Colors.grey, fontSize: 11))),
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, spreadRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Listings Management",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Get.find<HomeController>().changeIndex(3),
                          icon: const Icon(Icons.add, size: 18, color: Colors.white),
                          label: const Text("New Item", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005432),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
                              }
                              if (controller.products.isEmpty) {
                                return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No products found")));
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.82,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: controller.products.length,
                                itemBuilder: (context, index) {
                                  final product = controller.products[index];
                                  return _buildProductCard(product);
                                },
                              );
                            }),
                            const SizedBox(height: 32),
                            // Pagination Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  final start = ((controller.currentPage.value - 1) * controller.pageSize) + 1;
                                  final end = (start + controller.products.length - 1).clamp(0, controller.totalProducts.value);
                                  return Text(
                                    "Showing $start to $end of ${controller.totalProducts.value} results",
                                    style: const TextStyle(color: Color(0xFF00B14F), fontSize: 13),
                                  );
                                }),
                                Row(
                                  children: [
                                    _buildPaginationButton("Previous", () => controller.previousPage()),
                                    const SizedBox(width: 8),
                                    _buildPaginationButton("Next", () => controller.nextPage()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['image_url'] ?? "https://via.placeholder.com/150",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['description'] ?? "Juicy beef patty with melted cheese, fresh veggies...",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.find<HomeController>().changeIndex(3, argument: product);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text("Edit", style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00B14F),
                          side: const BorderSide(color: Color(0xFF00B14F)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteConfirm(product['id']),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text("Delete", style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF5656),
                          side: const BorderSide(color: Color(0xFFFF5656)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPaginationButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00B14F)),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFF00B14F), fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showDeleteConfirm(int id) {
    Get.defaultDialog(
      title: "Delete Product?",
      middleText: "Are you sure you want to remove this item?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFFF5656),
      onConfirm: () {
        Get.back();
        controller.deleteProduct(id);
      },
    );
  }
}
