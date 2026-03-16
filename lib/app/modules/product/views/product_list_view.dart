// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../home/controllers/home_controller.dart';
// import '../controllers/product_list_controller.dart';
//
// class ProductListView extends GetView<ProductListController> {
//   const ProductListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Custom Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const SizedBox(), // Placeholder for flex
//                 Row(
//                   children: [
//                     const Icon(Icons.notifications_none, color: Colors.black54),
//                     const SizedBox(width: 16),
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.grey[200],
//                       child: const Icon(Icons.person, color: Colors.grey),
//                     ),
//                     const SizedBox(width: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Obx(() => Text(Get.find<HomeController>().adminName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
//                         Obx(() => Text(Get.find<HomeController>().adminRole.value, style: const TextStyle(color: Colors.grey, fontSize: 11))),
//                       ],
//                     ),
//                     const Icon(Icons.keyboard_arrow_down, size: 20),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, spreadRadius: 0),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Listings Management",
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: () => Get.find<HomeController>().changeIndex(3),
//                           icon: const Icon(Icons.add, size: 18, color: Colors.white),
//                           label: const Text("New Item", style: TextStyle(color: Colors.white)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF005432),
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Obx(() {
//                               if (controller.isLoading.value) {
//                                 return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
//                               }
//                               if (controller.products.isEmpty) {
//                                 return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No products found")));
//                               }
//                               return GridView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   childAspectRatio: 0.82,
//                                   crossAxisSpacing: 20,
//                                   mainAxisSpacing: 20,
//                                 ),
//                                 itemCount: controller.products.length,
//                                 itemBuilder: (context, index) {
//                                   final product = controller.products[index];
//                                   return _buildProductCard(product);
//                                 },
//                               );
//                             }),
//                             const SizedBox(height: 32),
//                             // Pagination Footer
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Obx(() {
//                                   final start = ((controller.currentPage.value - 1) * controller.pageSize) + 1;
//                                   final end = (start + controller.products.length - 1).clamp(0, controller.totalProducts.value);
//                                   return Text(
//                                     "Showing $start to $end of ${controller.totalProducts.value} results",
//                                     style: const TextStyle(color: Color(0xFF00B14F), fontSize: 13),
//                                   );
//                                 }),
//                                 Row(
//                                   children: [
//                                     _buildPaginationButton("Previous", () => controller.previousPage()),
//                                     const SizedBox(width: 8),
//                                     _buildPaginationButton("Next", () => controller.nextPage()),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductCard(dynamic product) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[100]!),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, spreadRadius: 0),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 6,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   product['image_url'] ?? "https://via.placeholder.com/150",
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[100],
//                     child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product['name'],
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   product['description'] ?? "Juicy beef patty with melted cheese, fresh veggies...",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           Get.find<HomeController>().changeIndex(3, argument: product);
//                         },
//                         icon: const Icon(Icons.edit_outlined, size: 16),
//                         label: const Text("Edit", style: TextStyle(fontSize: 12)),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: const Color(0xFF00B14F),
//                           side: const BorderSide(color: Color(0xFF00B14F)),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () => _showDeleteConfirm(product['id']),
//                         icon: const Icon(Icons.delete_outline, size: 16),
//                         label: const Text("Delete", style: TextStyle(fontSize: 12)),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: const Color(0xFFFF5656),
//                           side: const BorderSide(color: Color(0xFFFF5656)),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaginationButton(String label, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(6),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF00B14F)),
//           borderRadius: BorderRadius.circular(6),
//           color: Colors.white,
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(color: Color(0xFF00B14F), fontSize: 12, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteConfirm(int id) {
//     Get.defaultDialog(
//       title: "Delete Product?",
//       middleText: "Are you sure you want to remove this item?",
//       textConfirm: "Delete",
//       textCancel: "Cancel",
//       confirmTextColor: Colors.white,
//       buttonColor: const Color(0xFFFF5656),
//       onConfirm: () {
//         Get.back();
//         controller.deleteProduct(id);
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    final horizontalPadding = isMobile ? 16.0 : 24.0;
    final verticalPadding = isMobile ? 12.0 : 16.0;
    final innerPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(), // Placeholder for flex
                Row(
                  children: [
                    SizedBox(width: isMobile ? 12 : 16),
                    Obx(() {
                      final profileImg = Get.find<HomeController>().adminProfileImg.value;
                      return CircleAvatar(
                        radius: isMobile ? 16 : 18,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: profileImg.isNotEmpty ? NetworkImage(profileImg) : null,
                        child: profileImg.isEmpty
                            ? Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: isMobile ? 16 : 20,
                              )
                            : null,
                      );
                    }),
                    if (!isMobile) ...[
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            Get.find<HomeController>().adminName.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          )),
                          Obx(() => Text(
                            Get.find<HomeController>().adminRole.value,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: EdgeInsets.all(innerPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Title and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Listings Management",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : (isTablet ? 22 : 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isMobile)
                          ElevatedButton.icon(
                            onPressed: () => Get.find<HomeController>().changeIndex(3),
                            icon: const Icon(Icons.add, size: 18, color: Colors.white),
                            label: const Text(
                              "New Item",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005432),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Mobile Add Button (if needed)
                    if (isMobile) ...[
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.find<HomeController>().changeIndex(3),
                          icon: const Icon(Icons.add, size: 16, color: Colors.white),
                          label: const Text(
                            "Add New Item",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005432),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: isMobile ? 16 : 24),

                    // Products Grid
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              if (controller.isLoading.value) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: CircularProgressIndicator(
                                      color: const Color(0xFF00B14F),
                                    ),
                                  ),
                                );
                              }
                              if (controller.products.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Text(
                                      "No products found",
                                      style: TextStyle(
                                        fontSize: isMobile ? 15 : 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                                  childAspectRatio: isMobile ? 0.9 : (isTablet ? 0.85 : 0.82),
                                  crossAxisSpacing: isMobile ? 12 : 20,
                                  mainAxisSpacing: isMobile ? 12 : 20,
                                ),
                                itemCount: controller.products.length,
                                itemBuilder: (context, index) {
                                  final product = controller.products[index];
                                  return _buildProductCard(product, isMobile);
                                },
                              );
                            }),

                            SizedBox(height: isMobile ? 24 : 32),

                            // Pagination Footer
                            _buildPaginationFooter(context, isMobile),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: isMobile ? 5 : 6,
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
                    child: Icon(
                      Icons.fastfood,
                      size: isMobile ? 40 : 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10.0 : 12.0,
              vertical: isMobile ? 6.0 : 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Unnamed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  product['description'] ?? "No description available",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isMobile ? 11 : 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 8 : 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.find<HomeController>().changeIndex(3, argument: product);
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          size: isMobile ? 14 : 16,
                        ),
                        label: Text(
                          "Edit",
                          style: TextStyle(fontSize: isMobile ? 11 : 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00B14F),
                          side: const BorderSide(color: Color(0xFF00B14F)),
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 4 : 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteConfirm(product['id']),
                        icon: Icon(
                          Icons.delete_outline,
                          size: isMobile ? 14 : 16,
                        ),
                        label: Text(
                          "Delete",
                          style: TextStyle(fontSize: isMobile ? 11 : 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF5656),
                          side: const BorderSide(color: Color(0xFFFF5656)),
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          final start = ((controller.currentPage.value - 1) * controller.pageSize) + 1;
          final end = (start + controller.products.length - 1).clamp(0, controller.totalProducts.value);
          return Text(
            isMobile
                ? "$start-$end of ${controller.totalProducts.value}"
                : "Showing $start to $end of ${controller.totalProducts.value} results",
            style: const TextStyle(
              color: Color(0xFF00B14F),
              fontSize: 13,
            ),
          );
        }),
        Row(
          children: [
            _buildPaginationButton("Previous", () => controller.previousPage(), isMobile),
            SizedBox(width: isMobile ? 4 : 8),
            _buildPaginationButton("Next", () => controller.nextPage(), isMobile),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(String label, VoidCallback onTap, bool isMobile) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00B14F)),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xFF00B14F),
            fontSize: isMobile ? 11 : 12,
            fontWeight: FontWeight.bold,
          ),
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