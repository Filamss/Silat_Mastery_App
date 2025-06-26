import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class LatihanCard extends StatelessWidget {
  final String namaGerakan;
  final String gambar;
  final int? repetisi;
  final int? durasi;
  final int index;

  const LatihanCard({
    super.key,
    required this.namaGerakan,
    required this.gambar,
    this.repetisi,
    this.durasi,
    required this.index,
  });

  String getImageUrl(String gambarPath) {
    if (gambarPath.isEmpty) {
      return "${ApiService.baseUrl}/upload/gerakan/placeholder.png";
    }
    final fileName = gambarPath.split('/').last;
    return "${ApiService.baseUrl}/upload/gerakan/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    String detailText = '';
    if (repetisi != null && repetisi! > 0) {
      detailText = 'x$repetisi';
    } else if (durasi != null && durasi! > 0) {
      detailText = '$durasi detik';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppWarna.latar,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_indicator, color: AppWarna.abu),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ), // jarak horizontal antar gambar dan teks
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: getImageUrl(gambar),
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget:
                    (context, url, error) =>
                        const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          AppSpasi.kecil,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaGerakan, style: AppGayaTeks.subJudul1),
                if (detailText.isNotEmpty)
                  Text(detailText, style: AppGayaTeks.keterangan2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
