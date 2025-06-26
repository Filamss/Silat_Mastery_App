import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';

class ItemLatihanCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

   const ItemLatihanCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = data['gambar'] ?? "";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 160,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Container(color: Colors.grey, height: 160),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 160,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                },
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha((0.4 * 255).toInt()),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['nama_latihan'] ?? '',
                        style: AppGayaTeks.subJudul.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data['tanggal'] != null)
                            Text(
                              "Terakhir: ${DateFormat.yMMMMd('id_ID').format(DateTime.parse(data['tanggal']))}",
                              style: AppGayaTeks.keterangan.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          Text(
                            "${data['durasi']} MENIT · ${data['jumlah']} LATIHAN",
                            style: AppGayaTeks.keterangan.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
