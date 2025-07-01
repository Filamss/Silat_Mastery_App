import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_tombol.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

import '../controllers/latihan_v1_controller.dart';

class LatihanV1View extends GetView<LatihanV1Controller> {
  const LatihanV1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: Obx(() {
        final gerakan = controller.gerakan;
        final nama = gerakan['nama_gerakan'] ?? '-';
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
                    backgroundColor: AppWarna.latar.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
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
                      Text("SIAP BERAKSI", style: AppGayaTeks.judul),
                      AppSpasi.kecil,
                      Text(nama, style: AppGayaTeks.isi),
                      AppSpasi.kecil,
                      Obx(
                        () => Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value:
                                    controller.countdown.value /
                                    controller.totalCountdown,
                                strokeWidth: 6,
                                color: AppWarna.utama,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            Text(
                              controller.countdown.value.toString(),
                              style: AppGayaTeks.judul,
                            ),
                          ],
                        ),
                      ),
                      AppSpasi.kecil,
                      Text(
                        "Persiapkan posisi dan fokus!",
                        style: AppGayaTeks.keterangan2,
                      ),

                      AppSpasi.kecil,

                      SizedBox(
                        width: 250,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: Text(
                            "Mulai",
                            style: AppGayaTeks.subJudul1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: controller.navigateToLatihanV2,
                          style: AppGayaTombol.utama,
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
}
