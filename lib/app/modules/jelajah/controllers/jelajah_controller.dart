import 'package:get/get.dart';
import 'dart:convert';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:http/http.dart' as http;

class JelajahController extends GetxController {
  var responseMessage = "".obs;
  final baseUrl = ApiService.baseUrl;

  // ⬇️ Data latihan dari API
  var listLatihan = [].obs;
  var latihanTanggalUser = <DateTime>[].obs;

  // ⬇️ Filter kategori
  var selectedKategori = 0.obs;
  final kategori = ["Pemula", "Menengah", "Lanjutan"];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      http.Response response = await ApiService.getLatihan();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        responseMessage.value = data["message"] ?? "";

        if (data["latihan"] != null) {
          List<Map<String, dynamic>> latihan = List<Map<String, dynamic>>.from(
            data["latihan"],
          );

          // Perbaiki path gambar agar lengkap dengan baseUrl
          latihan = latihan.map((lat) {
            if (lat['gambar'] != null &&
                !lat['gambar'].toString().startsWith('http')) {
              String gambar = lat['gambar'].toString();
              if (!gambar.startsWith('/upload/gambar/')) {
                gambar = '/upload/gambar/$gambar';
              }
              lat['gambar'] = "$baseUrl$gambar";
            }
            return lat;
          }).toList();

          listLatihan.value = latihan;
        }
      } else {
        responseMessage.value = "Gagal: ${response.body}";
      }

      // Ambil data tanggal latihan user
      http.Response tanggalResponse =
          await ApiService.getLatihanTanggalUser();
      if (tanggalResponse.statusCode == 200) {
        final tanggalJson = jsonDecode(tanggalResponse.body);
        if (tanggalJson["tanggal_latihan"] != null) {
          latihanTanggalUser.value = List<String>.from(
            tanggalJson["tanggal_latihan"],
          ).map((e) => DateTime.parse(e)).toList();
        }
      }
    } catch (e) {
      responseMessage.value = "Error: $e";
    }
  }

  // 🔍 Filter berdasarkan kategori aktif
  List<Map<String, dynamic>> get filteredLatihan {
    final tingkat = kategori[selectedKategori.value];
    return listLatihan
        .cast<Map<String, dynamic>>()
        .where((e) => e['tingkat'] == tingkat)
        .toList();
  }
}
