import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class AppInputFieldReactive extends StatelessWidget {
  final RxString value;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  const AppInputFieldReactive({
    super.key,
    required this.value,
    required this.hint,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        initialValue: value.value,
        onChanged: (val) => value.value = val,
        obscureText: obscureText,
        validator: validator,
        style: AppGayaTeks.isi,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppGayaTeks.keterangan.copyWith(color: Colors.grey[600]),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFF7F7F7), // Latar abu muda
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1.2),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppWarna.utama, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.3),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
