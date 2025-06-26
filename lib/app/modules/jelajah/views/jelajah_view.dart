import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/jelajah/controllers/jelajah_controller.dart';
import 'package:silat_mastery_app_2/app/widget/home/item_latihan_card.dart';
import 'package:silat_mastery_app_2/app/widget/jelajah/analisis_streamlit.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/navbar_bawah.dart';

class JelajahView extends GetView<JelajahController> {
  const JelajahView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavbarBawah(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;

          switch (index) {
            case 0:
              Get.offAllNamed('/home');
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
              Text("Jelajah", style: AppGayaTeks.judul),
              AppSpasi.kecil,

              // 🎯 Banner
              Container(
                decoration: BoxDecoration(
                  color: AppWarna.utama,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/banner_dada.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 140,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "HIIT Menyingkirkan dada pria bergelambir",
                  style: AppGayaTeks.judul.copyWith(color: Colors.white),
                ),
              ),
              AppSpasi.besar,

              const AnalisisStreamlitCard(),

              // 🔘 Kategori
              Text("Pilihan untuk anda", style: AppGayaTeks.subJudul),
              AppSpasi.kecil,
              Column(
                children: List.generate(3, (_) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ItemLatihanCard(
                      data: {
                        'judul': 'Pemanasan Seluruh Tubuh',
                        'durasi': 14,
                        'jumlah_latihan': 5,
                        'tingkat': 'Pemula',
                        'gambar':
                            '${controller.baseUrl}/upload/gambar/pemanasan.png',
                      },
                      onTap: () {},
                    ),
                  );
                }),
              ),
              AppSpasi.sedang,

              // 🎚️ Filter Kategori
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(controller.kategori.length, (i) {
                    final selected = controller.selectedKategori.value == i;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.selectedKategori.value = i;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selected
                                    ? AppWarna.utama
                                    : Colors.grey.shade200,
                            foregroundColor:
                                selected ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            controller.kategori[i],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              AppSpasi.sedang,

              // 📦 Daftar Latihan
              Obx(
                () => Column(
                  children:
                      controller.filteredLatihan.map((latihan) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ItemLatihanCard(
                            data: latihan,
                            onTap: () {
                              Get.toNamed('/latihan', arguments: latihan);
                            },
                          ),
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
