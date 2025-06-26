import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:silat_mastery_app_2/app/widget/home/item_latihan_card.dart';
import 'package:silat_mastery_app_2/app/widget/home/target_mingguan_card.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/navbar_bawah.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavbarBawah(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;

          switch (index) {
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
        child: SingleChildScrollView(
          padding: AppSpasi.paddingLayar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Header
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppWarna.utama,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text("SILAT MASTERY", style: AppGayaTeks.judul),
                ],
              ),
              AppSpasi.sedang,

              // 📊 Statistik Dummy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatBox(title: "LATIHAN", value: "9"),
                  _StatBox(title: "KKAL", value: "1038"),
                  _StatBox(title: "MENIT", value: "54"),
                ],
              ),
              AppSpasi.sedang,

              // 🎯 Target Mingguan
              TargetMingguanCard(controller: controller),
              AppSpasi.sedang,

              // 🎚️ Kategori
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.kategori.length, (i) {
                      final isSelected = controller.selectedKategori.value == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed:
                              () => controller.selectedKategori.value = i,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected
                                    ? AppWarna.utama
                                    : Colors.grey.shade200,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(controller.kategori[i]),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              AppSpasi.sedang,

              // 🥋 Daftar Latihan
              Obx(
                () => Column(
                  children:
                      controller.filteredLatihan.map((latihan) {
                        return ItemLatihanCard(
                          data: latihan,
                          onTap: () {
                            Get.toNamed('/latihan', arguments: latihan);
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppGayaTeks.subJudul),
        AppSpasi.kecil,
        Text(title, style: AppGayaTeks.keterangan.copyWith(color: Colors.grey)),
      ],
    );
  }
}
