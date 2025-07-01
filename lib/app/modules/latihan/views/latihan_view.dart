import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/widget/latihan/latihancard.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_tombol.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import '../controllers/latihan_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LatihanView extends GetView<LatihanController> {
  const LatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    final dataLatihan = controller.dataLatihan.value ?? {};

    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalDurasi = controller.dataLatihan.value?['durasi'] ?? 0;
        final totalLatihan = controller.dataLatihan.value?['jumlah'] ?? 0;
        final gambarPath = controller.dataLatihan.value?['gambar'] ?? '';

        final fullImageUrl =
            gambarPath.toString().startsWith('http')
                ? gambarPath
                : '${ApiService.baseUrl}/upload/gambar/$gambarPath';

        return Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: fullImageUrl,
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
                Positioned(
                  top: 40,
                  right: 30,
                  child: CircleAvatar(
                    backgroundColor: AppWarna.latar.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_enhance_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        final latihan = controller.dataLatihan.value;
                        if (latihan != null) {
                          Get.toNamed(
                            '/latihan-camera',
                            arguments: {
                              'nama_latihan':
                                  controller
                                      .dataLatihan
                                      .value?['nama_latihan'] ??
                                  '-',
                              'tipe_model': controller.tipeModel.value,
                            },
                          );
                        }
                      },
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
                      Center(
                        child: Text(
                          dataLatihan['judul']?.toUpperCase() ?? "Hari",
                          style: AppGayaTeks.judul,
                        ),
                      ),
                      AppSpasi.kecil,
                      Row(
                        children: [
                          _infoBox("Durasi", "$totalDurasi Menit"),
                          const SizedBox(width: 12),
                          _infoBox("Latihan", "$totalLatihan"),
                        ],
                      ),
                      AppSpasi.sedang,
                      Expanded(
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = controller.daftarLatihan.removeAt(
                              oldIndex,
                            );
                            controller.daftarLatihan.insert(newIndex, item);
                          },
                          children: List.generate(
                            controller.daftarLatihan.length,
                            (index) {
                              final gerakan = controller.daftarLatihan[index];
                              return LatihanCard(
                                key: ValueKey(gerakan['nama_gerakan'] ?? index),
                                index: index,
                                namaGerakan: gerakan['nama_gerakan'] ?? '-',
                                gambar: gerakan['gambar'] ?? '',
                                repetisi: gerakan['repetisi'],
                                durasi: gerakan['durasi'],
                                onTap: () {
                                  Get.toNamed(
                                    '/latihan-detail',
                                    arguments: {
                                      ...gerakan,
                                      'index': index,
                                      'daftarLatihan': controller.daftarLatihan,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      AppSpasi.kecil,
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.daftarLatihan.isNotEmpty) {
                              final gerakanPertama =
                                  controller.daftarLatihan[0];
                              Get.toNamed(
                                '/latihan-v1',
                                arguments: {
                                  'gerakan': gerakanPertama,
                                  'daftarLatihan': controller.daftarLatihan,
                                  'index': 0,
                                },
                              );
                            }
                          },
                          style: AppGayaTombol.utama,
                          child: Text(
                            "Mulai",
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

  Widget _infoBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppWarna.abuMuda,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: AppGayaTeks.judul.copyWith(fontSize: 20)),
            AppSpasi.kecil,
            Text(title, style: AppGayaTeks.keterangan),
          ],
        ),
      ),
    );
  }
}
