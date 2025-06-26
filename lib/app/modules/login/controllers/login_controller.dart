import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            '1082666813493-b45d6ti72k5cvahp6hnno4c18nq1o2t5.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar('Gagal', 'Tidak dapat mengambil token Google');
        return;
      }

      final response = await http.post(
        Uri.parse("http://192.168.1.5:5000/api/login-google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final user = data["user"];

        if (user == null) {
          Get.snackbar('Gagal', 'Data pengguna Google tidak ditemukan.');
          return;
        }

        final profileComplete = user["profile_complete"] ?? false;

        final box = GetStorage();
        box.write("email", user["email"]);

        Get.snackbar('Berhasil', 'Login Google berhasil!');
        if (profileComplete == true) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.BIODATA_JK);
        }
      } else {
        Get.snackbar('Gagal', data["message"] ?? 'Login gagal');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
