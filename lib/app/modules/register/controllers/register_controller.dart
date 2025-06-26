import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ✅ Gunakan RxString
  final nama = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmVisibility() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      final namaValue = nama.value.trim();
      final emailValue = email.value.trim();
      final passwordValue = password.value;

      try {
        final response = await ApiService.registerUser(
          nama: namaValue,
          email: emailValue,
          password: passwordValue,
        );

        if (response.statusCode == 200) {
          Get.snackbar('Berhasil', 'Kode OTP telah dikirim ke email Anda');
          Get.toNamed('/otp-verifikasi', arguments: {'email': emailValue});
        } else {
          final data = jsonDecode(response.body);
          Get.snackbar('Gagal', data["message"] ?? "Terjadi kesalahan");
        }
      } catch (e) {
        Get.snackbar('Error', 'Tidak bisa terhubung ke server: $e');
      }
    }
  }
}
