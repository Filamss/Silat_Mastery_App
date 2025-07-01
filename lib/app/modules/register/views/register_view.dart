import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/modules/register/controllers/register_controller.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_input_field.dart';
import 'package:silat_mastery_app_2/app/widget/form/app_primary_button.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_gaya_teks.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_warna.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      backgroundColor: AppWarna.latar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Text("Daftar Akun", style: AppGayaTeks.judul),
              const SizedBox(height: 4),
              Text("Buat Akun Baru Anda", style: AppGayaTeks.keterangan),
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
                    children: [
                      AppInputFieldReactive(
                        value: controller.nama,
                        hint: 'Masukkan nama lengkap',
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Nama wajib diisi'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      AppInputFieldReactive(
                        value: controller.email,
                        hint: 'Masukkan email',
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Email wajib diisi'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      Obx(
                        () => AppInputFieldReactive(
                          value: controller.password,
                          hint: 'Masukkan password',
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
                                      ? 'Password minimal 6 karakter'
                                      : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Obx(
                        () => AppInputFieldReactive(
                          value: controller.confirmPassword,
                          hint: 'Ulangi password',
                          obscureText: controller.isConfirmHidden.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleConfirmVisibility,
                          ),
                          validator:
                              (val) =>
                                  val != controller.password.value
                                      ? 'Password tidak sama'
                                      : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      AppPrimaryButton(
                        label: 'Daftar',
                        onPressed: controller.register,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Text("Atau", style: AppGayaTeks.keterangan),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                  Text("Sudah Punya Akun ? ", style: AppGayaTeks.isi),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      "Login",
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
