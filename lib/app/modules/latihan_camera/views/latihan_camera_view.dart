// 🎯 latihan_camera_view.dart (versi rapi & interaktif)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import '../controllers/latihan_camera_controller.dart';

class LatihanCameraView extends GetView<LatihanCameraController> {
  const LatihanCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      appBar: AppBar(
        backgroundColor: AppWarna.latar,
        elevation: 0,
        title: Obx(
          () => Text(controller.namaLatihan.value, style: AppGayaTeks.judul),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.black),
            onPressed: () => controller.switchCamera(),
            tooltip: "Ganti Kamera",
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value ||
            !controller.cameraController.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // 📷 Kamera (fullscreen)
            Positioned.fill(
              child: FittedBox(
                fit:
                    BoxFit
                        .cover, // ⚠️ Ini penting agar mengisi layar penuh tanpa gepeng
                child: SizedBox(
                  width: controller.cameraController.value.previewSize!.height,
                  height: controller.cameraController.value.previewSize!.width,
                  child: CameraPreview(controller.cameraController),
                ),
              ),
            ),

            // 🟩 Overlay hasil klasifikasi
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: controller.warnaKlasifikasi.value.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.hasilKlasifikasi.value.isEmpty
                        ? "Belum terdeteksi"
                        : controller.hasilKlasifikasi.value,
                    style: AppGayaTeks.subJudul1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // ℹ️ Info model & tips di bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        "Model Aktif: ${controller.tipeModel.value}",
                        style: AppGayaTeks.keterangan,
                      ),
                    ),
                    AppSpasi.kecil,
                    Text(
                      "Tips:\n• Pastikan seluruh tubuh terlihat kamera\n• Gunakan pencahayaan yang cukup\n• Jaga jarak 1–2 meter dari kamera",
                      style: AppGayaTeks.keterangan,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
