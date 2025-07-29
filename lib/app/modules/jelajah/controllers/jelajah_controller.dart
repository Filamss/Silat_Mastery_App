import 'package:get/get.dart';
import 'dart:convert';
import 'package:silat_mastery_app_2/app/services/api_service.dart';
import 'package:http/http.dart' as http;

class JelajahController extends GetxController {
  var responseMessage = "".obs;
  final baseUrl = ApiService.baseUrl;
  final int limit = 5;

  var listLatihan = [].obs;
  var latihanTanggalUser = <DateTime>[].obs;
  var listArtikel = [].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  var isLoading = false.obs;

  // Fetch artikel per halaman (tidak pakai infinite scroll)
  Future<void> fetchArtikel({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await ApiService.getArtikel(
        page: page,
        limit: limit,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> artikelList = data['data'] ?? [];

        final mapped = artikelList.map((artikel) {
          artikel['judul'] = artikel['judul'] ?? artikel['title'];
          artikel['penulis'] =
              artikel['penulis'] ?? artikel['sumber'] ?? "Tidak diketahui";
          artikel['konten'] = artikel['konten'] ?? artikel['content'];
          artikel['tanggal'] = artikel['tanggal'] ?? artikel['date'];
          return artikel;
        }).toList();

        listArtikel.value = mapped;
        currentPage.value = page;

        // 💡 Optional: hitung total halaman jika data response ada count
        if (data['total'] != null) {
          int totalData = data['total'];
          totalPages.value = (totalData / limit).ceil();
        } else if (mapped.length < limit) {
          totalPages.value = page; // Tidak ada lagi halaman
        } else {
          totalPages.value = page + 1; // Asumsi masih ada
        }
      } else {
        print("❌ Gagal ambil artikel: ${response.body}");
      }
    } catch (e) {
      print("❌ Error ambil artikel: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToPage(int page) {
    if (page != currentPage.value && page >= 1 && page <= totalPages.value) {
      fetchArtikel(page: page);
    }
  }

  // Data latihan (tidak diubah)
  var selectedKategori = 0.obs;
  final kategori = ["Pemula", "Menengah", "Lanjutan"];

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

      http.Response tanggalResponse = await ApiService.getLatihanTanggalUser();
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

  List<Map<String, dynamic>> get filteredLatihan {
    final tingkat = kategori[selectedKategori.value];
    return listLatihan
        .cast<Map<String, dynamic>>()
        .where((e) => e['tingkat'] == tingkat)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchArtikel(page: 1);
  }
}
