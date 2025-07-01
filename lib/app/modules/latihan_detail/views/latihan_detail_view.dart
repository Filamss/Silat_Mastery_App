import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import '../controllers/latihan_detail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LatihanDetailView extends GetView<LatihanDetailController> {
  const LatihanDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: Obx(() {
        final data = controller.gerakan;
        final nama = data['nama_gerakan'] ?? '-';
        final gambar = data['gambar'] ?? '';
        final repetisi = data['repetisi'] ?? 0;
        final durasi = data['durasi'] ?? 0;
        final instruksi = data['instruksi'] ?? '-';

        final daftarLatihan =
            data['daftarLatihan'] as List<Map<String, dynamic>>?;
        final index = data['index'] as int? ?? 0;

        final imageUrl =
            gambar.toString().startsWith('http')
                ? gambar
                : '${ApiService.baseUrl}/upload/gerakan/$gambar';

        Widget pengulanganAtauDurasiWidget = const SizedBox();

        if (repetisi > 0) {
          pengulanganAtauDurasiWidget = Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pengulangan", style: AppGayaTeks.subJudul1),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: controller.kurangRepetisi,
                      splashRadius: 20,
                    ),
                    Text(
                      "x$repetisi",
                      style: AppGayaTeks.judul.copyWith(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: controller.tambahRepetisi,
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (durasi > 0) {
          pengulanganAtauDurasiWidget = Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.only(bottom: 8),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Durasi", style: AppGayaTeks.judul.copyWith(fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: controller.kurangDurasi,
                      splashRadius: 20,
                    ),
                    Text(
                      "$durasi detik",
                      style: AppGayaTeks.judul.copyWith(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: controller.tambahDurasi,
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        void navigateTo(int newIndex) {
          if (daftarLatihan == null ||
              newIndex < 0 ||
              newIndex >= daftarLatihan.length)
            return;

          final dataBaru = {
            ...daftarLatihan[newIndex],
            'daftarLatihan': daftarLatihan,
            'index': newIndex,
          };

          controller.gerakan.assignAll(dataBaru);
        }

        return Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 250,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text(nama, style: AppGayaTeks.judul)),
                      AppSpasi.sedang,
                      Center(child: pengulanganAtauDurasiWidget),
                      AppSpasi.sedang,
                      Text(
                        "Instruksi",
                        style: AppGayaTeks.judul.copyWith(fontSize: 18),
                      ),
                      AppSpasi.kecil,
                      Text(
                        instruksi,
                        style: AppGayaTeks.isi.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed:
                                index > 0 ? () => navigateTo(index - 1) : null,
                          ),

                          Text(
                            daftarLatihan != null
                                ? "${index + 1}/${daftarLatihan.length}"
                                : "1/1",
                            style: AppGayaTeks.subJudul1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed:
                                (daftarLatihan != null &&
                                        index < daftarLatihan.length - 1)
                                    ? () => navigateTo(index + 1)
                                    : null,
                          ),
                        ],
                      ),
                      AppSpasi.kecil,
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800,
                          ),
                          onPressed: () => Get.back(),
                          child: Text(
                            "TUTUP",
                            style: AppGayaTeks.subJudul1.copyWith(
                              color: Colors.white,
                            ),
                          ),
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
