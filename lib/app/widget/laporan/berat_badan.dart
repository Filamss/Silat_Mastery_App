import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class BeratBadanWidget extends StatelessWidget {
  final LaporanController controller = Get.find();

  BeratBadanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Berat Badan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Catat",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            // Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Info berat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Saat ini"),
                          Text(
                            "${controller.beratBadanSaatIni.value} Kg",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Terberat"),
                          Text("${controller.beratTerberat} Kg"),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Teringan"),
                          Text("${controller.beratTeringan} Kg"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grafik
                  SizedBox(
                    height: 150,
                    child: controller.riwayatBerat.isEmpty
                        ? const Center(child: Text("Belum ada data berat"))
                        : LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= controller.riwayatBerat.length) return const SizedBox();
                                      final tanggal = controller.riwayatBerat[index]['tanggal'];
                                      return Text(tanggal.toString().substring(5, 10)); // Format: MM-DD
                                    },
                                    interval: 1,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, interval: 1),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  spots: controller.riwayatBerat.asMap().entries.map((e) {
                                    final berat = (e.value['berat'] as num?)?.toDouble() ?? 0;
                                    return FlSpot(e.key.toDouble(), berat);
                                  }).toList(),
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: true),
                                  color: Colors.blue,
                                ),
                              ],
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
