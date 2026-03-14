import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/home_controller.dart';

class DashboardContentView extends GetView<HomeController> {
  const DashboardContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Welcome to Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Obx(() => DropdownButton<String>(
                    value: controller.period.value,
                    items: const [
                      DropdownMenuItem(value: 'week', child: Text('This Week')),
                      DropdownMenuItem(value: 'month', child: Text('This Month')),
                      DropdownMenuItem(value: 'year', child: Text('This Year')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.updatePeriod(val);
                    },
                  )),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoadingStats.value) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (controller.statsError.value.isNotEmpty) {
              return Expanded(child: Center(child: Text(controller.statsError.value, style: const TextStyle(color: Colors.red))));
            }
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Stats Cards row
                    Row(
                      children: [
                        _buildStatCard('Active Listing', controller.activeListings.value.toString(),Colors.blue),
                        const SizedBox(width: 16),
                        _buildStatCard('Active Menu', controller.activeMenus.value.toString(),  Colors.orange),
                        const SizedBox(width: 16),
                        _buildStatCard('Pending Order', controller.pendingOrders.value.toString(), Colors.red),
                        const SizedBox(width: 16),
                        _buildStatCard('Total Revenue', '${controller.totalRevenue.value.toStringAsFixed(2)} TK', Colors.green),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Charts Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildChartCard('Revenue Stats', controller.revenueChart, Colors.green)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildChartCard('User Growth Stats', controller.userGrowthChart, Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, List<Map<String, dynamic>> data, Color lineCol) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text("No data available"))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(data) * 1.2, // add some headroom
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(data[value.toInt()]['label'] ?? '', style: const TextStyle(fontSize: 12)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _getMaxY(data) > 0 ? _getMaxY(data) / 5 : 1,
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: data.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: (entry.value['value'] ?? 0).toDouble(),
                              color: lineCol,
                              width: 22,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 10;
    double max = 0;
    for (var item in data) {
      double val = (item['value'] ?? 0).toDouble();
      if (val > max) max = val;
    }
    return max == 0 ? 10 : max;
  }
}
