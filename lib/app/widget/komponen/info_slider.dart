import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_spasi.dart';

class InfoSlider extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const InfoSlider({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(image, width: 240, height: 240, fit: BoxFit.contain),
        AppSpasi.besar,
        Text(title, style: AppGayaTeks.judul, textAlign: TextAlign.center),
        AppSpasi.sedang,
        Text(description, style: AppGayaTeks.isi, textAlign: TextAlign.center),
      ],
    );
  }
}
