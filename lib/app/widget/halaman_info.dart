import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';

class HalamanInfo extends StatelessWidget {
  final String judul;
  final String deskripsi;

  const HalamanInfo({super.key, required this.judul, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpasi.paddingLayar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: AppGayaTeks.judul),
          AppSpasi.sedang,
          Text(deskripsi, style: AppGayaTeks.isi),
        ],
      ),
    );
  }
}
