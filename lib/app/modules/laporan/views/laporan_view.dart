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
            Obx(() {
  final loginList = controller.riwayatLogin;

  if (loginList.isEmpty) {
    return const Text("Belum ada riwayat login.");
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      const Text(
        "Riwayat Login",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...loginList.map((e) {
        final waktu = DateTime.tryParse(e['waktu_login'] ?? '')?.toLocal();
        final formatted = waktu != null
            ? "${waktu.day}/${waktu.month}/${waktu.year} ${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}"
            : "Format tidak valid";

        return ListTile(
          leading: const Icon(Icons.login),
          title: Text("Login"),
          subtitle: Text(formatted),
        );
      }).toList(),
    ],
  );
})

          ],
        ),
      ),
    );
  }
}
