import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/payments_controller.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentsController());

    return Container(
      color: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payments Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitor your revenue and SSLCommerz performance',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Stats Cards
            Obx(() => Row(
              children: [
                Expanded(child: _buildStatCard(
                  "Total Revenue", 
                  controller.formatCurrency(controller.stats['total_revenue']),
                  Icons.account_balance_wallet_outlined,
                  Colors.green,
                )),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(
                  "Offline Revenue (COD)", 
                  controller.formatCurrency(controller.stats['offline_revenue']),
                  Icons.money_off_csred_outlined,
                  Colors.orange,
                )),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(
                  "Online Revenue (Gross)", 
                  controller.formatCurrency(controller.stats['online_revenue']),
                  Icons.credit_card_outlined,
                  Colors.blue,
                )),
                const SizedBox(width: 20),
                Expanded(child: _buildStatCard(
                  "SSL Cost (3% Est.)", 
                  controller.formatCurrency(controller.stats['ssl_cost']),
                  Icons.receipt_long_outlined,
                  Colors.red,
                )),
              ],
            )),
            
            const SizedBox(height: 32),
            
            // Transaction History Title
            const Text(
              'Transaction History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Transaction Table
            Expanded(
              child: Container(
                width: double.infinity, // কন্টেইনারকে পুরো প্রস্থ নিতে বাধ্য করুন
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.transactions.isEmpty) {
                    return const Center(child: Text("No transactions found"));
                  }

                  return LayoutBuilder( // স্ক্রিনের উপলব্ধ জায়গা মাপার জন্য
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth), // টেবিলকে পুরো প্রস্থ নিতে বাধ্য করবে
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                            horizontalMargin: 24, // কলামগুলোর মধ্যে সুন্দর স্পেসিংয়ের জন্য
                            columnSpacing: 20, // কলামের গ্যাপ নিয়ন্ত্রণ করতে
                            columns: const [
                              DataColumn(label: Text('DATE/TIME', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('TRANS ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: controller.transactions.map((txn) {
                              // ... আপনার বর্তমান rows এর কোড ...
                              final date = DateTime.parse(txn['created_at']);
                              final formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(date);
                              return DataRow(cells: [
                                DataCell(Text(formattedDate, style: const TextStyle(fontSize: 13))),
                                DataCell(Text(txn['customer_name'], style: const TextStyle(fontSize: 13))),
                                DataCell(Text(txn['transaction_id'], style: const TextStyle(fontSize: 13, color: Colors.blue))),
                                DataCell(Text(controller.formatCurrency(txn['amount']), style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(_buildStatusBadge(txn['status'])),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'PAID') color = Colors.green;
    if (status == 'FAILED') color = Colors.red;
    if (status == 'PENDING') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
