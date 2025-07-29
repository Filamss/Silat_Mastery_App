import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/jelajah/controllers/jelajah_controller.dart';
import 'package:silat_mastery_app_2/app/widget/home/item_latihan_card.dart';
import 'package:silat_mastery_app_2/app/widget/jelajah/analisis_streamlit.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/navbar_bawah.dart';
import 'package:silat_mastery_app_2/app/widget/jelajah/artikel_card.dart';

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
      body: Obx(
        () => SingleChildScrollView(
          padding: AppSpasi.paddingLayar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jelajah", style: AppGayaTeks.judul),
              AppSpasi.kecil,
              Container(
                decoration: BoxDecoration(
                  color: AppWarna.utama,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/Silat 3.png'),
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
              AppSpasi.sedang,
              Text("Artikel Untuk Anda", style: AppGayaTeks.subJudul),
              AppSpasi.kecil,

              if (controller.listArtikel.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Belum ada artikel."),
                  ),
                ),
              ...controller.listArtikel.map(
                (artikel) => ArtikelCard(data: artikel),
              ),

              AppSpasi.kecil,
              Obx(() {
                final currentPage = controller.currentPage.value;
                final totalPages = controller.totalPages.value;

                List<Widget> paginationButtons = [];

                void addPageButton(int page) {
                  final isSelected = page == currentPage;
                  paginationButtons.add(
                    ElevatedButton(
                      onPressed: () => controller.goToPage(page),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? AppWarna.utama : Colors.grey.shade200,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: Text("$page"),
                    ),
                  );
                }

                // ← Prev
                paginationButtons.add(
                  ElevatedButton(
                    onPressed:
                        currentPage > 1
                            ? () => controller.goToPage(currentPage - 1)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentPage > 1
                              ? AppWarna.utama
                              : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("← Prev"),
                  ),
                );

                if (totalPages <= 7) {
                  for (int i = 1; i <= totalPages; i++) {
                    addPageButton(i);
                  }
                } else {
                  addPageButton(1);

                  if (currentPage > 4) {
                    paginationButtons.add(
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("..."),
                      ),
                    );
                  }

                  for (int i = currentPage - 1; i <= currentPage + 1; i++) {
                    if (i > 1 && i < totalPages) {
                      addPageButton(i);
                    }
                  }

                  if (currentPage < totalPages - 3) {
                    paginationButtons.add(
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("..."),
                      ),
                    );
                  }

                  addPageButton(totalPages);
                }

                // Next →
                paginationButtons.add(
                  ElevatedButton(
                    onPressed:
                        currentPage < totalPages
                            ? () => controller.goToPage(currentPage + 1)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentPage < totalPages
                              ? AppWarna.utama
                              : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Next →"),
                  ),
                );

                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: paginationButtons,
                );
              }),

              AppSpasi.besar,
              Text("Kategori Latihan", style: AppGayaTeks.subJudul),
              AppSpasi.kecil,
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
