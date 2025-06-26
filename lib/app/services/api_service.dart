import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.43.49:5000"; // alamat IP server Flask kamu
  static const String apiKey = "rahasiakamu";

  // Ambil daftar latihan
  static Future<http.Response> getLatihan() async {
    final uri = Uri.parse("$baseUrl/api/latihan");
    return await http.get(uri, headers: {"X-API-KEY": apiKey});
  }

  // Ambil tanggal latihan user
  static Future<http.Response> getLatihanTanggalUser() async {
    final uri = Uri.parse("$baseUrl/api/latihan-user-tanggal");
    return await http.get(uri, headers: {"X-API-KEY": apiKey});
  }

  static Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/login");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: '{"email": "$email", "password": "$password"}',
    );
  }

  static Future<http.Response> registerUser({
    required String nama,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/register");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: '{"nama": "$nama", "email": "$email", "password": "$password"}',
    );
  }

  static Future<http.Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse("$baseUrl/api/verify-otp");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );
  }

  static Future<http.Response> resendOtp({required String email}) async {
    final url = Uri.parse("$baseUrl/api/resend-otp");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
  }

  static Future<http.Response> updateJenisKelamin(String jenisKelamin) async {
    final box = GetStorage();
    final email = box.read('email');

    if (email == null) {
      throw Exception("Email tidak ditemukan di storage.");
    }

    final url = Uri.parse("$baseUrl/api/update-jenis-kelamin");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "jenis_kelamin": jenisKelamin}),
    );
  }

  static Future<http.Response> updateUmur(int umur) async {
    final box = GetStorage();
    final email = box.read('email');

    if (email == null) {
      throw Exception("Email tidak ditemukan di storage.");
    }

    final url = Uri.parse("$baseUrl/api/update-umur");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "umur": umur}),
    );
  }

  static Future<http.Response> updateTinggi(int tinggi) async {
    final box = GetStorage();
    final email = box.read('email');
    final url = Uri.parse("$baseUrl/api/update-tinggi");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "tinggi": tinggi}),
    );
  }

  static Future<http.Response> updateBerat(double berat) async {
    final box = GetStorage();
    final email = box.read('email');
    final url = Uri.parse("$baseUrl/api/update-berat");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "berat": berat}),
    );
  }

  static Future<http.Response> simpanRiwayat({
    required String userId,
    required int durasi,
    required int kkal,
  }) async {
    final url = Uri.parse("$baseUrl/api/riwayat");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json", "X-API-KEY": apiKey},
      body: jsonEncode({"user_id": userId, "durasi": durasi, "kkal": kkal}),
    );
  }

  static Future<List<Map<String, dynamic>>> getRiwayat(String userId) async {
    final url = Uri.parse("$baseUrl/api/riwayat/$userId");
    final response = await http.get(url, headers: {"X-API-KEY": apiKey});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getRiwayatBerat(
    String email,
  ) async {
    final url = Uri.parse("$baseUrl/api/riwayat-berat/$email");
    final response = await http.get(url, headers: {"X-API-KEY": apiKey});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDaftarLatihan() async {
    final uri = Uri.parse("$baseUrl/api/latihan");
    final response = await http.get(uri, headers: {"X-API-KEY": apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDaftarGerakan() async {
    final uri = Uri.parse("$baseUrl/api/gerakan");
    final response = await http.get(uri, headers: {"X-API-KEY": apiKey});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['gerakan']);
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getLatihanById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/latihan/$id'),
      headers: {"X-API-KEY": apiKey},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return Map<String, dynamic>.from(json['latihan']);
    }

    return null;
  }
}
