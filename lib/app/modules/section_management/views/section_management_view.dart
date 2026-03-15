import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/section_management_controller.dart';

class SectionManagementView extends GetView<SectionManagementController> {
  const SectionManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Section Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add,color: Colors.white,),
            onPressed: () => _showCreateSectionDialog(),
          ),
          SizedBox(width: 80,)
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.sections.length,
          itemBuilder: (context, index) {
            final section = controller.sections[index];
            return Card(
              color: Colors.grey.shade100,
              margin: const EdgeInsets.all(8),
              child: ExpansionTile(
                shape: const Border(),
                title: Text(section['name']),
                subtitle: Text('Order: ${section['order_index']}'),
                leading: Switch(
                  value: section['is_active'],
                  onChanged: (val) => controller.toggleSectionStatus(section['id'], val),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteSection(section['id']),
                ),
                children: [
                   _buildProductList(section),
                   ListTile(
                     leading: const Icon(Icons.add_circle, color: Colors.green),
                     title: const Text('Add Product to this Section'),
                     onTap: () => _showAddProductDialog(section['id']),
                   )
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductList(dynamic section) {
    final List products = section['products'] ?? [];
    return Column(
      children: products.map((p) {
        final product = p['product'];
        return ListTile(
          title: Text(product['name']),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.orange),
            onPressed: () => controller.removeProduct(section['id'], product['id']),
          ),
        );
      }).toList(),
    );
  }

  void _showCreateSectionDialog() {
    final nameController = TextEditingController();
    final orderController = TextEditingController(text: '0');
    Get.dialog(
      AlertDialog(
        title: const Text('Create New Section'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Section Name')),
            TextField(controller: orderController, decoration: const InputDecoration(labelText: 'Order Index'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => controller.createSection(nameController.text, int.tryParse(orderController.text) ?? 0),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(int sectionId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Assign Product to Section'),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: controller.allProducts.length,
            itemBuilder: (context, index) {
              final product = controller.allProducts[index];
              return ListTile(
                title: Text(product['name']),
                onTap: () {
                  controller.assignProduct(sectionId, product['id']);
                  Get.back();
                },
              );
            },
          )),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
