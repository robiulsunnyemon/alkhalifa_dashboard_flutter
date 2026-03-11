import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_fee_controller.dart';

class DeliveryFeeView extends StatelessWidget {
  const DeliveryFeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryFeeController());

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
                  'System Config - Delivery Fee',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Obx(() => ElevatedButton.icon(
                  onPressed: () => controller.openFormDialog(),
                  icon: Icon(controller.deliveryFees.isEmpty ? Icons.add : Icons.edit, color: Colors.white),
                  label: Text(controller.deliveryFees.isEmpty ? 'Add Fee' : 'Update Fee', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B14F),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.deliveryFees.isEmpty) {
                  return const Center(child: Text("No delivery fee found."));
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
                      double remainingWidth = constraints.maxWidth - 400;
                      if (remainingWidth < 200) remainingWidth = 250;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: DataTable(
                            columnSpacing: 24,
                            horizontalMargin: 24,
                            columns: [
                              const DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: SizedBox(width: remainingWidth, child: Text('Fee Amount (৳)', style: TextStyle(fontWeight: FontWeight.bold))),
                              )),
                              const DataColumn(label: Padding(
                                padding: EdgeInsets.only(left: 32.0, right: 40),
                                child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                              )),
                            ],
                            rows: controller.deliveryFees.take(1).map((feeData) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(feeData['id'].toString())),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: SizedBox(
                                        width: remainingWidth,
                                        child: Text(
                                          '৳ ${feeData['fee']}',
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                            tooltip: 'Update Fee',
                                            onPressed: () => controller.openFormDialog(feeMap: feeData),
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
