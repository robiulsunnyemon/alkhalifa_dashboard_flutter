import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_management_controller.dart';

class OrderManagementView extends StatelessWidget {
  const OrderManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderManagementController());

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Management',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Obx(() => Row(
                  children: [
                    _buildFilterChip("ALL", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("PENDING", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("CONFIRMED", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("PROCESSING", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("SHIPPED", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("DELIVERED", controller),
                    const SizedBox(width: 8),
                    _buildFilterChip("CANCELLED", controller),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredOrders.isEmpty) {
                  return const Center(child: Text("No orders found for this status."));
                }
                return ListView.builder(
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return _buildOrderCard(order, controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, OrderManagementController controller) {
    final statusColor = _getStatusColor(order['status']);
    final date = DateTime.parse(order['created_at']);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Card(
      elevation:0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Row(
          children: [
            Text("Order #${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order['status'],
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Text("Total: ৳${order['total']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00B14F))),
          ],
        ),
        subtitle: Text("Customer: ${order['user'] != null ? '${order['user']['first_name']} ${order['user']['last_name']}' : 'Unknown'} (${order['user']?['email'] ?? ''}) | $formattedDate"),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...(order['items'] as List).map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['quantity']}x ${item['name']}"),
                      Text("৳${item['price'] * item['quantity']}"),
                    ],
                  ),
                )).toList(),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal:", style: TextStyle(color: Colors.grey)),
                    Text("৳${order['subtotal']}"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery Fee:", style: TextStyle(color: Colors.grey)),
                      Text("৳${order['delivery_fee']}"),
                    ],
                  ),
                ),
                const Divider(height: 24),
                _buildInfoRow("Delivery Info:", "${order['city']}, ${order['location']}"),
                _buildInfoRow("Address:", order['address']),
                if (order['phone_number'] != null)
                  _buildInfoRow("Phone:", order['phone_number']),
                if (order['special_instruction'] != null)
                  _buildInfoRow("Instruction:", order['special_instruction']),
                _buildInfoRow("Payment:", order['payment_method']),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (order['status'] == 'PENDING')
                      _buildStatusButton(order['id'], "CONFIRMED", Colors.blue, controller),
                    if (order['status'] == 'CONFIRMED')
                      _buildStatusButton(order['id'], "PROCESSING", Colors.indigo, controller),
                    if (order['status'] == 'PROCESSING')
                      _buildStatusButton(order['id'], "SHIPPED", Colors.purple, controller),
                    if (order['status'] == 'SHIPPED')
                      _buildStatusButton(order['id'], "DELIVERED", Colors.green, controller),
                    if (order['status'] != 'DELIVERED' && order['status'] != 'CANCELLED') ...[
                      const SizedBox(width: 8),
                      _buildStatusButton(order['id'], "CANCELLED", Colors.red, controller),
                    ],
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => controller.deleteOrder(order['id']),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String status, OrderManagementController controller) {
    final isSelected = controller.selectedStatus.value == status;
    return ChoiceChip(
      label: Text(status, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.filterOrders(status);
      },
      selectedColor: const Color(0xFF00B14F),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildStatusButton(int id, String status, Color color, OrderManagementController controller) {
    return TextButton(
      onPressed: () => controller.updateStatus(id, status),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(status),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING': return Colors.orange;
      case 'CONFIRMED': return Colors.blue;
      case 'PROCESSING': return Colors.indigo;
      case 'SHIPPED': return Colors.purple;
      case 'DELIVERED': return Colors.green;
      case 'CANCELLED': return Colors.red;
      default: return Colors.grey;
    }
  }
}
