import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_tombol.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import '../controllers/latihan_v2_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LatihanV2View extends GetView<LatihanV2Controller> {
  const LatihanV2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: Obx(() {

        final gerakan = controller.gerakan;
        final nama = gerakan['nama_gerakan'] ?? '-';
        final durasi = gerakan['durasi'] ?? 0;
        final repetisi = gerakan['repetisi'] ?? 0;
        final gambarPath = gerakan['gambar'] ?? '';

        final fullImageUrl =
            gambarPath.toString().startsWith('http')
                ? gambarPath
                : '${ApiService.baseUrl}/upload/gerakan/$gambarPath';

        return Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: fullImageUrl,
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.broken_image, size: 64),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.offNamed('/latihan'),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -36),
                child: Container(
                  width: double.infinity,
                  padding: AppSpasi.paddingLayar,
                  decoration: BoxDecoration(
                    color: AppWarna.latar,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(nama, style: AppGayaTeks.subJudul1),
                      AppSpasi.sangatbesar,

                      // Konten utama: waktu atau repetisi
                      if (durasi > 0)
                        Obx(
                          () => Text(
                            formatTime(controller.timerValue.value),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (repetisi > 0)
                        Text(
                          "x$repetisi",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      AppSpasi.kecil,

                      Obx(() {
                        final durasi = controller.gerakan['durasi'] ?? 0;
                        final isDurasi = durasi > 0;

                        final isRunning = controller.isRunning.value;
                        final isSelesai = controller.timerValue.value == 0;

                        final label =
                            isSelesai
                                ? 'SELESAI'
                                : (isDurasi
                                    ? (isRunning ? 'JEDA' : 'LANJUT')
                                    : 'SELESAI');

                        final icon =
                            isSelesai
                                ? Icons.check
                                : (isDurasi
                                    ? (isRunning
                                        ? Icons.pause
                                        : Icons.play_arrow)
                                    : Icons.check);

                        final onPressed =
                            isSelesai
                                ? () {
                                  if (!controller.sudahNavigasi) {
                                    controller.sudahNavigasi = true;
                                    controller.keGerakanSelanjutnya();
                                  }
                                }
                                : (isDurasi
                                    ? controller.pauseOrResume
                                    : controller.keGerakanSelanjutnya);

                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: Icon(icon, size: 20),
                            label: Text(label),
                            onPressed: onPressed,
                            style: AppGayaTombol.utama,
                          ),
                        );
                      }),

                      AppSpasi.kecil,

                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.indexGerakan.value > 0
                                ? TextButton.icon(
                                  onPressed: controller.keGerakanSebelumnya,
                                  icon: const Icon(Icons.skip_previous),
                                  label: const Text("Sebelumnya"),
                                )
                                : const SizedBox(width: 120),

                            TextButton.icon(
                              onPressed: controller.keGerakanSelanjutnya,
                              icon: const Icon(Icons.skip_next),
                              label: const Text("Melewatkan"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
