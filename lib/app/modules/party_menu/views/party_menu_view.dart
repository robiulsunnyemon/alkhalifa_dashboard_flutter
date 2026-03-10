import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/party_menu_controller.dart';


class PartyMenuView extends GetView<PartyMenuController> {
  const PartyMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PartyMenuController>()) {
      Get.put(PartyMenuController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with User Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(), // Spacer
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
                        Obx(() => Text(
                          Get.find<HomeController>().adminName.value,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        )),
                        Obx(() => Text(
                          Get.find<HomeController>().adminRole.value,
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        )),
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Title and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Menu Management",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.clearForm();
                    _showMenuForm(context);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add New Menu", style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B14F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grid of Party Menus and Pagination
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
                }
                if (controller.partyMenus.isEmpty) {
                  return const Center(child: Text("No party menus yet"));
                }
                return CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.82,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final menu = controller.partyMenus[index];
                          return _buildMenuCard(menu,context);
                        },
                        childCount: controller.partyMenus.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    SliverToBoxAdapter(
                      child: Obx(() => Row(
                        children: [
                          Text(
                            "Showing ${(controller.currentPage.value - 1) * controller.pageSize + 1} to ${(controller.currentPage.value * controller.pageSize).clamp(0, controller.totalItems.value)} of ${controller.totalItems.value} results",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const Spacer(),
                          _buildPaginationButton("Previous", () => controller.previousPage()),
                          const SizedBox(width: 12),
                          _buildPaginationButton("Next", () => controller.nextPage()),
                        ],
                      )),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> menu,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: menu['image_url'] != null && menu['image_url'].toString().isNotEmpty
                ? Image.network(menu['image_url'], height: 220, width: double.infinity, fit: BoxFit.cover)
                : Container(height: 220, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  menu['description'] ?? "No description",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.populateForm(menu);
                          _showMenuForm(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00B14F)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Edit", style: TextStyle(color: Color(0xFF00B14F), fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.deletePartyMenu(menu['id']),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuForm(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      controller.isEditing.value ? "Update Party Menu" : "Add New Menu", 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    )),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Image Placeholder/Upload
                Obx(() => GestureDetector(
                  onTap: () => controller.pickAndUploadImage(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      image: controller.selectedImageUrl.value.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(controller.selectedImageUrl.value),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.isUploading.value
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)))
                        : controller.selectedImageUrl.value.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text("Add Photos", style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                            : null,
                  ),
                )),
                const SizedBox(height: 24),

                // Form Fields Row 1
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField("Title", controller.titleController, "Enter title"),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField("Price", controller.priceController, "Enter price"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Fields Row 2
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField("Menu category", controller.categoryController, "Select category"),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox()), // Spacer
                  ],
                ),
                const SizedBox(height: 16),

                _buildFormField("Description", controller.descriptionController, "Enter description", maxLines: 3),
                
                const SizedBox(height: 24),
                const Text("Add Item", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                
                // Search Field for Items
                TextField(
                  controller: controller.searchController,
                  onChanged: (val) => controller.searchProducts(val),
                  decoration: InputDecoration(
                    hintText: "Search items",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
                
                // Search Results list
                Obx(() {
                  if (controller.searchResults.isEmpty) return const SizedBox();
                  return Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: ListView.builder(
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final product = controller.searchResults[index];
                        return ListTile(
                          title: Text(product['name']),
                          onTap: () => controller.addProductToMenu(product),
                          trailing: const Icon(Icons.add, color: Color(0xFF00B14F)),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 16),
                const Text("Item List", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                
                // Selected Items list
                Obx(() => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.selectedProducts.isEmpty
                      ? const Text("Empty list", style: TextStyle(color: Colors.grey))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.selectedProducts.map((p) => Chip(
                            backgroundColor: Colors.white,
                            label: Text(p['name']),
                            onDeleted: () => controller.removeProductFromMenu(p['id']),
                            deleteIconColor: Colors.red,
                          )).toList(),
                        ),
                )),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.savePartyMenu(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B14F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Obx(() => Text(
                      controller.isEditing.value ? "Update Menu" : "Save Menu", 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF00B14F)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF00B14F), fontSize: 12),
      ),
    );
  }
}
