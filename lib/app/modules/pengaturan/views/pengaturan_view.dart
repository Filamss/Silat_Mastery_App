import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/widget/komponen/navbar_bawah.dart';
import '../controllers/pengaturan_controller.dart';

class PengaturanView extends GetView<PengaturanController> {
  const PengaturanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavbarBawah(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/jelajah');
              break;
            case 2:
              Get.offAllNamed('/laporan');
              break;
            case 3:
              Get.offAllNamed('/pengaturan');
              break;
          }
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "PENGATURAN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Cadangan & Pemulihan Data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Cadangan & Pemulihan Data",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Masuk dan sinkronisasi data Anda",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const Icon(Icons.sync, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Daftar Premium
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text("DAFTAR PREMIUM"),
            ),
            const SizedBox(height: 16),

            // Item pengaturan dengan navigasi
            _SettingItem(
              icon: Icons.water_drop,
              title: "Pengaturan latihan",
              onTap: () => Get.toNamed('/pengaturan-latihan'),
            ),
            _SettingItem(
              icon: Icons.settings,
              title: "Setelan Umum",
              onTap: () => Get.toNamed('/setelan-umum'),
            ),
            const _SettingItem(icon: Icons.mic, title: "Opsi Suara (TTS)"),
            const _SettingItem(
              icon: Icons.tips_and_updates_outlined,
              title: "Usulkan Fitur Lainnya",
            ),
            const _SettingItem(
              icon: Icons.language,
              title: "Opsi bahasa",
              subtitle: "Default",
            ),

            // Switch toggle
            Obx(
              () => SwitchListTile(
                value: controller.syncHealth.value,
                onChanged: controller.toggleHealthSync,
                title: const Text("Sinkronisasi dengan Health Connect"),
                secondary: const Icon(Icons.health_and_safety),
              ),
            ),

            const Divider(),
            const _SettingItem(
              icon: Icons.share,
              title: "Berbagi dengan teman",
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
