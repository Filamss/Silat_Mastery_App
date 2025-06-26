import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_tombol.dart';
import 'package:silat_mastery_app_2/app/modules/info/controllers/info_controller.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/info_slider.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class InfoView extends GetView<InfoController> {
  InfoView({super.key});

  final List<Map<String, String>> infoData = [
    {
      "image": "assets/img/Silat 1.png",
      "title": "Bakar lemak – bangun otot dengan latihan silat",
      "desc":
          "Memperkenalkan aplikasi pelatihan silat baru yang revolusioner yang dirancang untuk membantu anda mencapai tujuan kebugaran anda! Dengan latihan langkah demi langkah, rencana makan yang dipersonalisasi, anda akan membakar lemak dan membentuk otot lebih cepat dari sebelumnya.",
    },
    {
      "image": "assets/img/Silat 2.jpeg",
      "title": "Latihan fleksibel di rumah",
      "desc":
          "Aplikasi ini memungkinkan kamu berlatih kapan saja dan di mana saja, tanpa alat! Cocok untuk pemula maupun tingkat lanjut.",
    },
    {
      "image": "assets/img/Silat 3.png",
      "title": "Panduan nutrisi personal",
      "desc":
          "Kami menyertakan saran makan berdasarkan tujuan dan kebutuhan fisikmu untuk hasil maksimal.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller.pageController,
                      itemCount: infoData.length,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (_, index) {
                        final item = infoData[index];
                        return InfoSlider(
                          image: item['image']!,
                          title: item['title']!,
                          description: item['desc']!,
                        );
                      },
                    ),
                    Positioned(
                      top: 6,
                      right: 2,
                      child: TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: Text(
                          "Lewati",
                          style: AppGayaTeks.subJudul.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(infoData.length, (index) {
                    final isActive = controller.currentPage.value == index;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.currentPage.value > 0)
                      OutlinedButton(
                        onPressed: controller.previousPage,
                        style: AppGayaTombol.sekunder,
                        child: Text(
                          "Sebelumnya",
                          style: AppGayaTeks.subJudul.copyWith(
                            color: AppWarna.kedua,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 90),
                    ElevatedButton(
                      onPressed: () => controller.nextPage(infoData.length),
                      style: AppGayaTombol.info,
                      child: Text(
                        controller.currentPage.value == infoData.length - 1
                            ? "Mulai"
                            : "Berikutnya",
                        style: AppGayaTeks.subJudul.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
