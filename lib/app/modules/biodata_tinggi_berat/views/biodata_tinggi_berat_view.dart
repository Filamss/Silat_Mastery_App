import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/widget/picker/scroll_picker_desimal_horizontal.dart';
import '../controllers/biodata_tinggi_berat_controller.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';
import 'package:silat_mastery_app_2/app/widget/picker/scroll_picker_angka.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class BiodataTinggiBeratView extends GetView<BiodataTinggiBeratController> {
  const BiodataTinggiBeratView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Langkah 3/3',
                style: AppGayaTeks.judul.copyWith(color: AppWarna.teks),
              ),
              const SizedBox(height: 12),
              Text(
                'Berapa tinggi & berat badan anda?',
                textAlign: TextAlign.center,
                style: AppGayaTeks.judul.copyWith(
                  color: AppWarna.kedua,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Informasi ini membantu kami menyusun rencana latihan & pemantauan kesehatan yang optimal.',
                textAlign: TextAlign.center,
                style: AppGayaTeks.isi.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 24),

              // Scroll Picker Tinggi
              Obx(
                () => ScrollPickerAngka(
                  min: 100,
                  max: 220,
                  selectedValue: controller.tinggi.value,
                  satuan: 'cm',
                  onSelected: controller.setTinggi,
                  controller: controller.tinggiController,
                ),
              ),
              const SizedBox(height: 32),

              // Horizontal Picker Berat
              Obx(
                () => ScrollPickerDesimalHorizontal(
                  min: 10.0,
                  max: 150.0,
                  interval: 0.1,
                  selectedValue: controller.berat.value,
                  onChanged: controller.setBerat,
                ),
              ),

              const Spacer(),
              AppPrimaryButton(
                label: "Selesai",
                onPressed: controller.simpanTinggiBerat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
