import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/biodata_jk_controller.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';

class BiodataJkView extends GetView<BiodataJKController> {
  const BiodataJkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Langkah 1/3',
                    style: AppGayaTeks.judul.copyWith(color: AppWarna.teks), //
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 0 ? Colors.black87 : Colors.grey[300],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Apa jenis kelamin anda?',
                    textAlign: TextAlign.center,
                    style: AppGayaTeks.judul.copyWith(
                      color: AppWarna.kedua,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beritahu kami yang terbaik untuk membantu\nmeningkatkan hasil latihan anda',
                    textAlign: TextAlign.center,
                    style: AppGayaTeks.isi.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => controller.pilihJenisKelamin('Laki-laki'),
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    controller.jenisKelamin.value == 'Laki-laki'
                                        ? AppWarna.utama
                                        : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/img/gender_male.jpeg',
                              height: 160,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => controller.pilihJenisKelamin('Perempuan'),
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    controller.jenisKelamin.value == 'Perempuan'
                                        ? AppWarna.utama
                                        : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/img/gender_female.jpeg',
                              height: 160,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol tetap di bawah
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: AppPrimaryButton(
                  label: 'Berikutnya',
                  onPressed: controller.simpanJenisKelamin,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
