import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/modules/home/controllers/home_controller.dart';

class TargetMingguanCard extends StatelessWidget {
  final HomeController controller;

  const TargetMingguanCard({super.key, required this.controller});

  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  int getWeekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final offset = firstDay.weekday - 1;
    return ((date.day + offset) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final mingguIni = getCurrentWeekDates();

    return Obx(() {
      final latihanUserDates = controller.latihanTanggalUser;
      final mingguAktif =
          latihanUserDates.map((tgl) => getWeekOfMonth(tgl)).toSet();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul & Progress
            Row(
              children: [
                Text("Target Mingguan", style: AppGayaTeks.subJudul),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${mingguAktif.length}",
                        style: TextStyle(
                          color: AppWarna.utama,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: "/4",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Avatar Hari Minggu Ini
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  final tgl = mingguIni[index];
                  final isToday =
                      tgl.day == today.day &&
                      tgl.month == today.month &&
                      tgl.year == today.year;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          isToday ? AppWarna.utama : Colors.grey.shade300,
                      child: Text(
                        DateFormat.E('id_ID').format(tgl)[0],
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}
