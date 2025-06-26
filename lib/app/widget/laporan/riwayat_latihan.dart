import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/laporan/controllers/laporan_controller.dart';

class RiwayatLatihan extends StatelessWidget {
  final LaporanController controller = Get.find();

  RiwayatLatihan({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final today = DateTime.now();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Header Riwayat ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Riwayat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Semua catatan", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),

          // === List horizontal tanggal ===
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final tanggal = today.subtract(Duration(days: 6 - index));
                      final isToday =
                          tanggal.day == today.day &&
                          tanggal.month == today.month;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              _getHari(tanggal.weekday),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isToday ? Colors.red : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${tanggal.day}',
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Statistik Hari
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hari Beruntun: ${controller.hariBeruntun}"),
                      Text("Terbaik Personal: ${controller.personalBest} Hari"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      );
    });
  }

  String _getHari(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      case 7:
        return 'Min';
      default:
        return '';
    }
  }
}
