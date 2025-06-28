import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/login/controllers/login_controller.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_input_field.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/img/Logo_Silat_Mastery.png',
                  width: 180,
                  height: 180,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputFieldReactive(
                        value: controller.email,
                        hint: "Masukkan email atau username",
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Email tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => AppInputFieldReactive(
                          value: controller.password,
                          hint: "Masukkan password",
                          obscureText: controller.isPasswordHidden.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          validator:
                              (val) =>
                                  val == null || val.length < 6
                                      ? 'Minimal 6 karakter'
                                      : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Row(
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: controller.toggleRememberMe,
                            ),
                            Text("Ingat Saya", style: AppGayaTeks.keterangan),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                // bisa arahkan ke halaman reset password jika ada
                              },
                              child: Text(
                                "Lupa Kata Sandi?",
                                style: AppGayaTeks.keterangan,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppPrimaryButton(
                        label: 'Masuk',
                        onPressed: controller.login,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text("Atau", style: AppGayaTeks.keterangan),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: controller.loginWithGoogle,
                        child: Center(
                          child: Image.asset(
                            'assets/icons/google.png',
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum Punya Akun ? ", style: AppGayaTeks.isi),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Text(
                      "Daftar Sekarang",
                      style: AppGayaTeks.subJudul,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
