import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/customer_list_controller.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    if (!Get.isRegistered<CustomerListController>()) {
      Get.put(CustomerListController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // All Customers List Title and Search
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Customers List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    decoration: InputDecoration(
                      hintText: "Search for something",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  _buildHeaderCell("Name", flex: 3),
                  _buildHeaderCell("Phone Number", flex: 2),
                  _buildHeaderCell("Email", flex: 3),
                  _buildHeaderCell("Location", flex: 3),
                ],
              ),
            ),
            const Divider(height: 1),

            // Table Body
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
                }
                if (controller.filteredCustomers.isEmpty) {
                  return const Center(child: Text("No customers found"));
                }
                return ListView.builder(
                  itemCount: controller.filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = controller.filteredCustomers[index];
                    final isEven = index % 2 == 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isEven ? const Color(0xFFF1F6F1) : Colors.white,
                      ),
                      child: Row(
                        children: [
                          _buildDataCell("${customer['first_name']} ${customer['last_name']}", flex: 3),
                          _buildDataCell(customer['phone_number'] ?? "N/A", flex: 2),
                          _buildDataCell(customer['email'], flex: 3),
                          _buildDataCell(customer['address'] ?? "N/A", flex: 3),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Table Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final start = (controller.currentPage.value - 1) * controller.pageSize + 1;
                    final end = start + controller.filteredCustomers.length - 1;
                    return Text(
                      "Showing $start to $end of ${controller.totalCustomers.value} results",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _buildPaginationButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }
}
