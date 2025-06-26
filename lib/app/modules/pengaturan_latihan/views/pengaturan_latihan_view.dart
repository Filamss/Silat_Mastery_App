import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pengaturan_latihan_controller.dart';

class PengaturanLatihanView extends GetView<PengaturanLatihanController> {
  const PengaturanLatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan latihan"),
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
          _ItemSetting(title: "Jenis kelamin", icon: Icons.person),
          _ItemSetting(
            title: "Durasi rehat latihan",
            icon: Icons.local_cafe,
            trailing: Obx(() => _DropdownDetik(
              values: const [15, 25, 30, 45],
              selected: controller.durasiRehat.value,
              onChanged: controller.setDurasiRehat,
            )),
          ),
          _ItemSetting(
            title: "Waktu Hitung Mundur",
            icon: Icons.av_timer,
            trailing: Obx(() => _DropdownDetik(
              values: const [5, 10, 15, 20],
              selected: controller.hitungMundur.value,
              onChanged: controller.setHitungMundur,
            )),
          ),
          _ItemSetting(title: "Opsi suara", icon: Icons.volume_up),
          _ItemSetting(title: "Atur Ulang Perkembangan", icon: Icons.refresh),
        ],
      ),
    );
  }
}

class _ItemSetting extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;

  const _ItemSetting({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

class _DropdownDetik extends StatelessWidget {
  final List<int> values;
  final int selected;
  final Function(int) onChanged;

  const _DropdownDetik({
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selected,
      underline: const SizedBox(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      items: values.map((v) => DropdownMenuItem(
        value: v,
        child: Text(
          "$v detik",
          style: const TextStyle(color: Colors.blue),
        ),
      )).toList(),
    );
  }
}
