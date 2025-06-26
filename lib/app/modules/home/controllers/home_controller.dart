import 'package:get/get.dart';
import 'dart:convert';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var responseMessage = "".obs;
  final baseUrl = ApiService.baseUrl;

  // ⬇️ Data latihan (berisi dari API)
  var listLatihan = [].obs;
  var latihanTanggalUser = <DateTime>[].obs;

  // ⬇️ Kategori filter
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

          // Tambahkan baseUrl dan path '/gambar/' atau '/video/' bila perlu
          latihan =
              latihan.map((lat) {
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

      http.Response tanggalResponse = await ApiService.getLatihanTanggalUser();
      if (tanggalResponse.statusCode == 200) {
        final tanggalJson = jsonDecode(tanggalResponse.body);
        if (tanggalJson["tanggal_latihan"] != null) {
          latihanTanggalUser.value =
              List<String>.from(
                tanggalJson["tanggal_latihan"],
              ).map((e) => DateTime.parse(e)).toList();
        }
      }
    } catch (e) {
      responseMessage.value = "Error: $e";
    }
  }

  List<Map<String, dynamic>> get filteredLatihan {
    final tingkat = kategori[selectedKategori.value];
    return listLatihan
        .cast<Map<String, dynamic>>()
        .where((e) => e['tingkat'] == tingkat)
        .toList();
  }
}
