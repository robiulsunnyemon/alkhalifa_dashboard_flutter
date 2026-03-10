import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../home/controllers/home_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.find<HomeController>().changeIndex(2),
        ),
        title: Obx(() => Text(controller.isEdit.value ? "Edit Item" : "Add New Item")),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() => Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: controller.selectedImageBytes.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(controller.selectedImageBytes.value!, fit: BoxFit.cover),
                      )
                    : controller.uploadedImageUrl.value.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(controller.uploadedImageUrl.value, fit: BoxFit.cover),
                          )
                        : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text("Add Photos", style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
              )),
            ),
            const SizedBox(height: 24),
            
            // Category & Flat Price (Optional)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Main category", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<int>(
                        value: controller.selectedCategoryId.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: controller.categories.map<DropdownMenuItem<int>>((cat) {
                          return DropdownMenuItem<int>(
                            value: cat['id'],
                            child: Text(cat['name']),
                          );
                        }).toList(),
                        onChanged: (val) => controller.selectedCategoryId.value = val,
                        hint: const Text("Select one category"),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Person & Prices", style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: controller.addVariation,
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00B14F)),
                  tooltip: "Add variation",
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Dynamic Variations
            Obx(() => Column(
              children: controller.nameControllers.asMap().entries.map((entry) {
                int idx = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: controller.nameControllers[idx],
                          decoration: InputDecoration(
                            hintText: "Variation Name (e.g. For 1 person)",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller.priceControllers[idx],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            prefixText: "\$ ",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => controller.removeVariation(idx),
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        tooltip: "Remove variation",
                      ),
                    ],
                  ),
                );
              }).toList(),
            )),

            const SizedBox(height: 24),
            const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.createProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(controller.isEdit.value ? "Update" : "Save", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
