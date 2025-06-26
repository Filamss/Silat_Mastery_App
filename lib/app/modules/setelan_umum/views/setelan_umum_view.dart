import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setelan_umum_controller.dart';

class SetelanUmumView extends GetView<SetelanUmumController> {
  const SetelanUmumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setelan Umum"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          const _Item(title: "Ingatkan saya untuk berlatih setiap hari", icon: Icons.access_alarm),
          const _Item(title: "Satuan metrik & imperial", icon: Icons.straighten),
          Obx(() => SwitchListTile(
                title: const Text("Biarkan layar menyala"),
                secondary: const Icon(Icons.phone_android),
                value: controller.biarkanLayarMenyala.value,
                onChanged: controller.toggleLayar,
              )),
          const _Item(title: "Kebijakan privasi", icon: Icons.remove_red_eye),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final IconData icon;

  const _Item({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {}, // bisa diisi navigasi atau dialog jika diperlukan
    );
  }
}
