import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_area_controller.dart';

class DeliveryAreaView extends StatelessWidget {
  const DeliveryAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryAreaController());
    return Container(
      color: Colors.white60,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'System Config - Delivery Areas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.openFormDialog(),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Area', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B14F),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.deliveryAreas.isEmpty) {
                  return const Center(child: Text("No delivery areas found."));
                }
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate dynamic width for 'Locations' column to fill remaining space
                      // We allocate fixed space for ID (50), City (100), Actions (120), and padding
                      double remainingWidth = constraints.maxWidth - 500;
                      if (remainingWidth < 200) remainingWidth = 250;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: DataTable(
                            columnSpacing: 24,
                            horizontalMargin: 24, // Added padding on the left/right of the whole table
                            dataRowMaxHeight: double.infinity,
                            dataRowMinHeight: 60,
                            columns: [
                              const DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              const DataColumn(label: SizedBox(width: 80, child: Text('City', style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: SizedBox(width: remainingWidth, child: Text('Locations', style: TextStyle(fontWeight: FontWeight.bold))),
                              )),
                              const DataColumn(label: Padding(
                                padding: EdgeInsets.only(left: 32.0,right: 40),
                                child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                              )),
                            ],
                            rows: controller.deliveryAreas.map((area) {
                              List locations = area['locations'];
                              return DataRow(
                                cells: [
                                  DataCell(Text(area['id'].toString())),
                                  DataCell(SizedBox(width: 80, child: Text(area['city'], overflow: TextOverflow.ellipsis))),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      child: SizedBox(
                                        width: remainingWidth,
                                        child: Text(
                                          locations.join(', '),
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => controller.openFormDialog(area: area),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Delete Area',
                                            onPressed: () => controller.deleteDeliveryArea(area['id']),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
