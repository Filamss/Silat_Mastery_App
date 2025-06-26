import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/widget/picker/scroll_picker_angka.dart';
import '../controllers/biodata_umur_controller.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';

class BiodataUmurView extends GetView<BiodataUmurController> {
  const BiodataUmurView({super.key});

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
                children: [
                  Text(
                    'Langkah 2/3',
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
                          color: index == 1 ? Colors.black : Colors.grey[300],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Berapa Umur Anda?',
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
                  const SizedBox(height: 48),
                  Obx(
                    () => ScrollPickerAngka(
                      min: 10,
                      max: 100,
                      selectedValue: controller.usia.value,
                      satuan: 'tahun',
                      onSelected: controller.setUmur,
                      controller: controller.scrollController,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppPrimaryButton(
                  label: 'Berikutnya',
                  onPressed: controller.simpanUmur,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
