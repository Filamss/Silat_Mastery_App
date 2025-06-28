import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.4:5000";

  static Future<Map<String, String>> _authHeaders() async {
    final box = GetStorage();
    final token = box.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // --- Auth & Registrasi ---
  static Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    try {
      // ✅ Tambahkan ini untuk memaksa Google Sign-In tidak pakai akun lama
      await googleSignIn.signOut();

      // 🟡 Setelah itu baru mulai login lagi
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return;

      final GoogleSignInAuthentication auth = await account.authentication;

      final response = await http.post(
        Uri.parse('$baseUrl/api/login-google'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": auth.idToken}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final data = body['data'];
        final token = data['token'];
        final user = data['user'];

        final box = GetStorage();
        await box.write('token', token);
        await box.write('user', user);
      } else {
        throw Exception(body['message'] ?? "Login Google gagal");
      }
    } catch (e) {
      throw Exception("Gagal login dengan Google: $e");
    }
  }

  static Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/login");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
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
      body: jsonEncode({"nama": nama, "email": email, "password": password}),
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

  // --- Profile ---
  static Future<http.Response> updateJenisKelamin(String jenisKelamin) async {
    final url = Uri.parse("$baseUrl/api/update-jenis-kelamin");
    final headers = await _authHeaders();
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode({"jenis_kelamin": jenisKelamin}),
    );
  }

  static Future<http.Response> updateUmur(int umur) async {
    final url = Uri.parse("$baseUrl/api/update-umur");
    final headers = await _authHeaders();
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode({"umur": umur}),
    );
  }

  static Future<http.Response> updateTinggi(int tinggi) async {
    final url = Uri.parse("$baseUrl/api/update-tinggi");
    final headers = await _authHeaders();
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode({"tinggi": tinggi}),
    );
  }

  static Future<http.Response> updateBerat(double berat) async {
    final url = Uri.parse("$baseUrl/api/update-berat");
    final headers = await _authHeaders();
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode({"berat": berat}),
    );
  }

  // --- Latihan ---
  static Future<http.Response> getLatihan() async {
    final url = Uri.parse("$baseUrl/api/latihan");
    final headers = await _authHeaders();
    return await http.get(url, headers: headers);
  }

  static Future<Map<String, dynamic>?> getLatihanById(String id) async {
    final url = Uri.parse("$baseUrl/api/latihan/$id");
    final headers = await _authHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Map<String, dynamic>.from(json['latihan']);
    }

    return null;
  }

  static Future<http.Response> getLatihanTanggalUser() async {
    final url = Uri.parse("$baseUrl/api/latihan-user-tanggal");
    final headers = await _authHeaders();
    return await http.get(url, headers: headers);
  }

  // --- Gerakan ---
  static Future<List<Map<String, dynamic>>> getDaftarGerakan() async {
    final url = Uri.parse("$baseUrl/api/gerakan");
    final headers = await _authHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['gerakan']);
    } else {
      return [];
    }
  }

  // --- Riwayat Latihan ---
  static Future<http.Response> simpanRiwayat({
    required int durasi,
    required int kkal,
  }) async {
    final url = Uri.parse("$baseUrl/api/riwayat");
    final headers = await _authHeaders();
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode({"durasi": durasi, "kkal": kkal}),
    );
  }

  static Future<List<Map<String, dynamic>>> getRiwayat() async {
    final url = Uri.parse("$baseUrl/api/riwayat");
    final headers = await _authHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  // --- Riwayat Berat ---
  static Future<List<Map<String, dynamic>>> getRiwayatBerat() async {
    final url = Uri.parse("$baseUrl/api/riwayat-berat");
    final headers = await _authHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }
}
