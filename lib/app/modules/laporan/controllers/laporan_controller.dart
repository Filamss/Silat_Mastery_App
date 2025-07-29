import 'package:get/get.dart';
import 'package:silat_mastery_app_2/app/services/api_service.dart';

class LaporanController extends GetxController {
  var jumlahLatihan = 0.obs;
  var totalKkal = 0.obs;
  var totalMenit = 0.obs;

  var beratBadanSaatIni = 0.0.obs;
  var beratTerberat = 0.0;
  var beratTeringan = 0.0;
  var tinggiBadan = 0.obs;
  var bmi = 0.obs;

  var hariBeruntun = 0.obs;
  var personalBest = 0.obs;

  var riwayat = <Map<String, dynamic>>[].obs;
  var riwayatBerat = <Map<String, dynamic>>[].obs;
  var riwayatLogin = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
    fetchRiwayatBerat();
    fetchRiwayatLogin();
  }

  void fetchRiwayatBerat() async {
    try {
      final data = await ApiService.getRiwayatBerat();
      print("Data berat dari server:");
      print(data);

      if (data.isEmpty) {
        riwayatBerat.clear();
        beratBadanSaatIni.value = 0.0;
        beratTerberat = 0.0;
        beratTeringan = 0.0;
        return;
      }

      // Urutkan dari tanggal paling awal ke terbaru
      data.sort((a, b) => a['tanggal'].compareTo(b['tanggal']));
      riwayatBerat.value = data;

      final beratList = data.map((e) => (e['berat'] as num).toDouble()).toList();

      beratBadanSaatIni.value = beratList.last;
      beratTerberat = beratList.reduce((a, b) => a > b ? a : b);
      beratTeringan = beratList.reduce((a, b) => a < b ? a : b);
    } catch (e) {
      print("Gagal mengambil riwayat berat: $e");
    }
  }

  void fetchRiwayat() async {
    try {
      final data = await ApiService.getRiwayat();

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

      final tanggalList = riwayat
          .map((e) => DateTime.tryParse(e['tanggal'])?.toLocal())
          .whereType<DateTime>()
          .toList()
        ..sort((a, b) => b.compareTo(a));

      final tanggalUnik = tanggalList
          .map((d) => DateTime(d.year, d.month, d.day))
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));

      // Hitung streak hari beruntun
      int beruntun = 0;
      final today = DateTime.now();
      for (int i = 0; i < tanggalUnik.length; i++) {
        final targetDate = today.subtract(Duration(days: i));
        if (tanggalUnik.contains(targetDate)) {
          beruntun++;
        } else {
          break;
        }
      }
      hariBeruntun.value = beruntun;

      // Hitung personal best streak
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
      personalBest.value = bestStreak > currentStreak ? bestStreak : currentStreak;
    } catch (e) {
      print("Gagal mengambil riwayat latihan: $e");
    }
  }

  Future<void> updateBeratDanRiwayat(double beratBaru) async {
    try {
      await ApiService.updateBerat(beratBaru); // update field user.berat
      await ApiService.simpanRiwayatBerat(beratBaru); // simpan ke riwayat_berat
      fetchRiwayatBerat(); // refresh grafik dan statistik
    } catch (e) {
      print("Gagal update berat dan riwayat: $e");
    }
  }

  void fetchRiwayatLogin() async {
  try {
    final data = await ApiService.getRiwayatLogin();
    riwayatLogin.value = data;
  } catch (e) {
    print("Gagal mengambil riwayat login: $e");
  }
}

}
