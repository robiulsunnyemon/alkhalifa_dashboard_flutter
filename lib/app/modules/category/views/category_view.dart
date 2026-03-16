import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Category",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Obx(() {
                    final profileImg = Get.find<HomeController>().adminProfileImg.value;
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: profileImg.isNotEmpty ? NetworkImage(profileImg) : null,
                      child: profileImg.isEmpty ? const Icon(Icons.person, color: Colors.grey) : null,
                    );
                  }),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(Get.find<HomeController>().adminName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      Obx(() => Text(Get.find<HomeController>().adminRole.value, style: const TextStyle(color: Colors.grey, fontSize: 11))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) => controller.searchQuery.value = val,
                          decoration: InputDecoration(
                            hintText: "Search category",
                            prefixIcon: const Icon(Icons.search, size: 20),
                            fillColor: const Color(0xFFFBF8F5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showCategoryDialog(context),
                        icon: const Icon(Icons.add, size: 18, color: Colors.white),
                        label: const Text("Add Categories", style: TextStyle(color: Colors.white)),
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
                        }
                        return Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(4),
                                2: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration: const BoxDecoration(color: Color(0xFFEBEBEB)),
                                  children: [
                                    _buildHeaderCell("Sl. No."),
                                    _buildHeaderCell("Category Name"),
                                    _buildHeaderCell("Actions", alignment: Alignment.center),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(4),
                                    2: FlexColumnWidth(1),
                                  },
                                  children: [
                                    ...controller.filteredCategories.asMap().entries.map((entry) {
                                      int idx = entry.key;
                                      var category = entry.value;
                                      return TableRow(
                                        children: [
                                          _buildDataCell((idx + 1).toString().padLeft(2, '0')),
                                          _buildDataCell(category['name']),
                                          _buildActionCell(category),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildHeaderCell(String text, {Alignment alignment = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: alignment,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _buildActionCell(dynamic category) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: PopupMenuButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF00B14F)),
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text("Edit", style: TextStyle(fontSize: 13))]),
                onTap: () => Future.delayed(Duration.zero, () => _showCategoryDialog(context, category: category)),
              ),
              PopupMenuItem(
                child: const Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(fontSize: 13, color: Colors.red))]),
                onTap: () => Future.delayed(Duration.zero, () => _showDeleteConfirm(category['id'])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {dynamic category}) {
    final isEdit = category != null;
    final nameController = TextEditingController(text: isEdit ? category['name'] : "");
    
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? "Edit Category" : "Category Title",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your title here",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEdit) {
                        controller.updateCategory(category['id'], nameController.text);
                      } else {
                        controller.addCategory(nameController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005432),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(isEdit ? "Update Category" : "Save Category", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(int id) {
    Get.defaultDialog(
      title: "Delete Category",
      middleText: "Are you sure you want to delete this category?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteCategory(id);
      },
    );
  }
}
