import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/latihan_detail_controller.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class LatihanDetailView extends GetView<LatihanDetailController> {
  const LatihanDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final data = controller.gerakan;
        final nama = data['nama_gerakan'] ?? '-';
        final gambar = data['gambar'] ?? '';
        final repetisi = data['repetisi'] ?? 0;
        final instruksi = data['instruksi'] ?? '-';

        final imageUrl = gambar.toString().startsWith('http')
            ? gambar
            : '${ApiService.baseUrl}/upload/gerakan/$gambar';

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pengulangan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (controller.gerakan['repetisi'] > 1) {
                          controller.gerakan['repetisi']--;
                        }
                      },
                    ),
                    Text("x$repetisi", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.gerakan['repetisi']++;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Instruksi", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(instruksi),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back_ios),
                    Text("1/16"),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800),
                    onPressed: () => Get.back(),
                    child: const Text("TUTUP"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
