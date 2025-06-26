import 'package:flutter/material.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_tombol.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppGayaTombol.utama,
      child: SizedBox(
        height: 35,
        width: double.infinity,
        child: Center(
          child: Text(
            label,
            style: AppGayaTeks.judul.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
