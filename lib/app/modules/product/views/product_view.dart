// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/product_controller.dart';
// import '../../home/controllers/home_controller.dart';
//
// class ProductView extends GetView<ProductController> {
//   const ProductView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.find<HomeController>().changeIndex(2),
//         ),
//         title: Obx(() => Text(controller.isEdit.value ? "Edit Item" : "Add New Item")),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Picker
//             GestureDetector(
//               onTap: controller.pickImage,
//               child: Obx(() => Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: controller.selectedImageBytes.value != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.memory(controller.selectedImageBytes.value!, fit: BoxFit.cover),
//                       )
//                     : controller.uploadedImageUrl.value.isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(controller.uploadedImageUrl.value, fit: BoxFit.cover),
//                           )
//                         : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey[400]),
//                           const SizedBox(height: 8),
//                           Text("Add Photos", style: TextStyle(color: Colors.grey[500])),
//                         ],
//                       ),
//               )),
//             ),
//             const SizedBox(height: 24),
//
//             // Category & Flat Price (Optional)
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Main category", style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Obx(() => DropdownButtonFormField<int>(
//                         value: controller.selectedCategoryId.value,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                         ),
//                         items: controller.categories.map<DropdownMenuItem<int>>((cat) {
//                           return DropdownMenuItem<int>(
//                             value: cat['id'],
//                             child: Text(cat['name']),
//                           );
//                         }).toList(),
//                         onChanged: (val) => controller.selectedCategoryId.value = val,
//                         hint: const Text("Select one category"),
//                       )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Person & Prices", style: TextStyle(fontWeight: FontWeight.bold)),
//                 IconButton(
//                   onPressed: controller.addVariation,
//                   icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00B14F)),
//                   tooltip: "Add variation",
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//
//             // Dynamic Variations
//             Obx(() => Column(
//               children: controller.nameControllers.asMap().entries.map((entry) {
//                 int idx = entry.key;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: TextField(
//                           controller: controller.nameControllers[idx],
//                           decoration: InputDecoration(
//                             hintText: "Variation Name (e.g. For 1 person)",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: TextField(
//                           controller: controller.priceControllers[idx],
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             hintText: "Price",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                             prefixText: "\$ ",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         onPressed: () => controller.removeVariation(idx),
//                         icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                         tooltip: "Remove variation",
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             )),
//
//             const SizedBox(height: 24),
//             const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             TextField(
//               controller: controller.titleController,
//               decoration: InputDecoration(
//                 hintText: "Enter title",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//             const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             TextField(
//               controller: controller.descriptionController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Enter description",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//             ),
//
//             const SizedBox(height: 32),
//             Obx(() => SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: controller.isLoading.value ? null : controller.createProduct,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF00B14F),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: controller.isLoading.value
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(controller.isEdit.value ? "Update" : "Save",
//                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../home/controllers/home_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    final horizontalPadding = isMobile ? 16.0 : 24.0;
    final verticalPadding = isMobile ? 16.0 : 24.0;
    final spacing = isMobile ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: isMobile ? 20 : 24),
          onPressed: () => Get.find<HomeController>().changeIndex(2),
        ),
        title: Obx(() => Text(
          controller.isEdit.value ? "Edit Item" : "Add New Item",
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: isMobile ? false : true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() => Container(
                height: isMobile ? 160 : 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: controller.selectedImageBytes.value != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    controller.selectedImageBytes.value!,
                    fit: BoxFit.cover,
                  ),
                )
                    : controller.uploadedImageUrl.value.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    controller.uploadedImageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: isMobile ? 32 : 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text("Image not found", style: TextStyle(color: Colors.grey[500], fontSize: isMobile ? 12 : 14)),
                        ],
                      ),
                    ),
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: isMobile ? 36 : 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      "Add Photos",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isMobile ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              )),
            ),
            SizedBox(height: spacing),

            // Category Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Main category",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                Obx(() => DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 12,
                      vertical: isMobile ? 12 : 16,
                    ),
                  ),
                  items: controller.categories.map<DropdownMenuItem<int>>((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(
                        cat['name'],
                        style: TextStyle(fontSize: isMobile ? 14 : 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => controller.selectedCategoryId.value = val,
                  hint: Text(
                    "Select one category",
                    style: TextStyle(fontSize: isMobile ? 14 : 15),
                  ),
                  isExpanded: true,
                  iconSize: isMobile ? 20 : 24,
                )),
              ],
            ),
            SizedBox(height: spacing),

            // Person & Prices Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Person & Prices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 15 : 16,
                  ),
                ),
                IconButton(
                  onPressed: controller.addVariation,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: const Color(0xFF00B14F),
                    size: isMobile ? 24 : 28,
                  ),
                  tooltip: "Add variation",
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 4 : 8),

            // Dynamic Variations
            Obx(() => Column(
              children: controller.nameControllers.asMap().entries.map((entry) {
                int idx = entry.key;
                return Padding(
                  padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: isMobile ? 3 : 2,
                        child: TextField(
                          controller: controller.nameControllers[idx],
                          style: TextStyle(fontSize: isMobile ? 14 : 15),
                          decoration: InputDecoration(
                            hintText: "Variation Name",
                            hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 10 : 12,
                              vertical: isMobile ? 12 : 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 6 : 8),
                      Expanded(
                        flex: isMobile ? 2 : 1,
                        child: TextField(
                          controller: controller.priceControllers[idx],
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: isMobile ? 14 : 15),
                          decoration: InputDecoration(
                            hintText: "Price",
                            hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 8 : 12,
                              vertical: isMobile ? 12 : 16,
                            ),
                            prefixText: "\$ ",
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 2 : 4),
                      IconButton(
                        onPressed: () => controller.removeVariation(idx),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: isMobile ? 20 : 24,
                        ),
                        tooltip: "Remove variation",
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )),

            SizedBox(height: spacing),

            // Title Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 15,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                TextField(
                  controller: controller.titleController,
                  style: TextStyle(fontSize: isMobile ? 15 : 16),
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    hintStyle: TextStyle(fontSize: isMobile ? 14 : 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 14 : 18,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing),

            // Description Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 15,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                TextField(
                  controller: controller.descriptionController,
                  maxLines: isMobile ? 3 : 4,
                  style: TextStyle(fontSize: isMobile ? 15 : 16),
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    hintStyle: TextStyle(fontSize: isMobile ? 14 : 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.all(isMobile ? 12 : 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing * 2),

            // Save Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: isMobile ? 45 : 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.createProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  controller.isEdit.value ? "Update" : "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 15 : 16,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}