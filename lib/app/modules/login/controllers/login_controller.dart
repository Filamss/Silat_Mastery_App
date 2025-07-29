import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final email = ''.obs;
  final password = ''.obs;
  final rememberMe = false.obs;
  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() async {
    if (formKey.currentState?.validate() ?? false) {
      final emailValue = email.value.trim();
      final passwordValue = password.value;

      try {
        final response = await ApiService.loginUser(
          email: emailValue,
          password: passwordValue,
        );

        final body = jsonDecode(response.body);
        final message = body["message"] ?? 'Login gagal';

        if (response.statusCode == 200 && body["success"] == true) {
          final user = body["data"]?["user"]; // ✅ ambil dari nested "data"
          if (user == null) {
            Get.snackbar('Gagal', 'Data pengguna tidak ditemukan.');
            return;
          }

          final profileComplete = user["profile_complete"] ?? false;

          // Simpan email ke GetStorage
          final box = GetStorage();
          box.write("user", user); // simpan semua data user (Map)
          box.write("token", body["data"]?["token"]); // simpan token login
          
          await ApiService.simpanRiwayatLogin();

          Get.snackbar('Berhasil', 'Selamat datang kembali!');

          if (profileComplete == true) {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.offAllNamed(Routes.BIODATA_JK);
          }
        } else if (message.toLowerCase().contains('belum diverifikasi')) {
          Get.snackbar('Verifikasi Diperlukan', message);
          await Future.delayed(const Duration(milliseconds: 500));
          Get.toNamed(Routes.OTP_VERIFIKASI, arguments: {'email': emailValue});
        } else {
          Get.snackbar('Gagal', message);
        }
      } catch (e) {
        Get.snackbar('Error', 'Tidak dapat terhubung ke server: $e');
      }
    }
  }

  // ✅ Login Google
  Future<void> loginWithGoogle() async {
    try {
      await ApiService.loginWithGoogle();

      final profile = await ApiService.getUserProfile();

      final box = GetStorage();
      box.write("user", profile);

      final profileComplete = profile["profile_complete"] ?? false;

      Get.snackbar('Berhasil', 'Login Google berhasil!');
      if (profileComplete == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.BIODATA_JK);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal login dengan Google: $e');
    }
  }
}
