import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:silat_mastery_app_2/app/modules/login/controllers/login_controller.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/loading_helper.dart';

class OtpVerifikasiController extends GetxController {
  final email = Get.arguments['email'];

  final otpFields = List.generate(4, (_) => TextEditingController());
  final timer = 30.obs;
  final isResending = false.obs;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void startCountdown() {
    timer.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (timer.value == 0) return false;
      timer.value--;
      return true;
    });
  }

  String get fullOtp =>
      otpFields.map((controller) => controller.text.trim()).join();

  Future<void> verifyOtp() async {
    if (fullOtp.length != 4) {
      Get.snackbar("Validasi", "Kode OTP tidak lengkap");
      return;
    }

    try {
      final response = await ApiService.verifyOtp(email: email, otp: fullOtp);

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body["success"] == true) {
        Get.snackbar("Berhasil", "OTP berhasil diverifikasi");

        // ✅ TRIK AMPUH: preload LoginController agar tidak terjadi race
        await Future.delayed(const Duration(milliseconds: 300));
        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController()); // paksa instansiasi sebelum view dibangun
        }

        // ✅ Delay sedikit lagi agar login controller stabil
        await Future.delayed(const Duration(milliseconds: 200));
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Gagal", body["message"] ?? "OTP tidak valid");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  Future<void> resendOtp() async {
    if (isResending.value) return;

    isResending.value = true;
    LoadingHelper.show(message: "Mengirim ulang kode OTP...");

    try {
      final response = await ApiService.resendOtp(email: email);

      final body = jsonDecode(response.body);
      await LoadingHelper.hide();

      if (response.statusCode == 200 && body["success"] == true) {
        Get.snackbar("Berhasil", "OTP baru dikirim ke email Anda");
        timer.value = 60;
        startCountdown();
      } else {
        final msg = body["message"] ?? "Gagal mengirim ulang OTP";
        if (msg.toLowerCase().contains("sudah diverifikasi")) {
          Get.snackbar("Info", msg);
          await Future.delayed(const Duration(seconds: 2));
          Get.offAllNamed('/login');
        } else {
          Get.snackbar("Gagal", msg);
        }
      }
    } catch (e) {
      await LoadingHelper.hide();
      Get.snackbar("Error", "Gagal menghubungi server: $e");
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in otpFields) {
      c.dispose();
    }
    super.onClose();
  }
}
