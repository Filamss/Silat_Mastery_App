import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class LaporanController extends GetxController {
  var jumlahLatihan = 0.obs;
  var totalKkal = 0.obs;
  var totalMenit = 0.obs;
  var beratBadanSaatIni = 55.0.obs;
  var beratTerberat = 55.0;
  var beratTeringan = 53.0;
  var tinggiBadan = 166.obs;
  var bmi = 20.obs;

  var hariBeruntun = 1.obs;
  var personalBest = 3.obs;

  var riwayat = <Map<String, dynamic>>[].obs;
  var riwayatBerat = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  void fetchRiwayatBerat() async {
    final box = GetStorage();
    final email = box.read("email");

    if (email == null) return;

    final data = await ApiService.getRiwayatBerat(email);
    riwayatBerat.value = data;
  }

  void fetchRiwayat() async {
    final box = GetStorage();
    final user = box.read("user");

    if (user == null || user["_id"] == null) {
      return;
    }

    final userId = user["_id"];
    try {
      final data = await ApiService.getRiwayat(userId);

      riwayat.value = List<Map<String, dynamic>>.from(data);

      jumlahLatihan.value = riwayat.length;
      int totalKkalSum = 0;
      int totalDurasiSum = 0;

      for (var item in riwayat) {
        totalKkalSum += (item['kkal'] as num?)?.toInt() ?? 0;
        totalDurasiSum += (item['durasi'] as num?)?.toInt() ?? 0;
      }

      totalKkal.value = totalKkalSum;
      totalMenit.value = totalDurasiSum;

      // Konversi tanggal-tanggal latihan ke DateTime dan sort dari terbaru
      final tanggalList =
          riwayat.map((e) => DateTime.parse(e['tanggal']).toLocal()).toList()
            ..sort((a, b) => b.compareTo(a));

      // Set untuk menyimpan tanggal-tanggal unik (tanpa jam)
      final tanggalUnik =
          tanggalList
              .map((d) => DateTime(d.year, d.month, d.day))
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a));

      // Hitung hari beruntun
      int beruntun = 0;
      DateTime today = DateTime.now();
      for (int i = 0; i < tanggalUnik.length; i++) {
        final targetDate = today.subtract(Duration(days: i));
        if (tanggalUnik.contains(targetDate)) {
          beruntun++;
        } else {
          break;
        }
      }
      hariBeruntun.value = beruntun;

      // Hitung rekor terbaik personal
      int bestStreak = 0;
      int currentStreak = 1;
      for (int i = 1; i < tanggalUnik.length; i++) {
        final prev = tanggalUnik[i - 1];
        final curr = tanggalUnik[i];

        if (prev.difference(curr).inDays == 1) {
          currentStreak++;
        } else {
          bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
          currentStreak = 1;
        }
      }
      personalBest.value =
          bestStreak > currentStreak ? bestStreak : currentStreak;
    } catch (e) {}
  }
}
