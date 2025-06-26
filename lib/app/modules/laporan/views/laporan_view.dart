import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:silat_mastery_app_2/app/widget/laporan/berat_badan.dart';
import 'package:silat_mastery_app_2/app/widget/laporan/stat_ringkasan.dart';
import 'package:silat_mastery_app_2/app/widget/laporan/riwayat_latihan.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/navbar_bawah.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      bottomNavigationBar: NavbarBawah(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;

          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/jelajah');
              break;
            case 2:
              Get.offAllNamed('/laporan');
              break;
            case 3:
              Get.offAllNamed('/pengaturan');
              break;
          }
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Laporan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const StatRingkasan(),
            const SizedBox(height: 24),
            RiwayatLatihan(),
            BeratBadanWidget(),
          ],
        ),
      ),
    );
  }
}
