import 'package:get/get.dart';

import '../modules/biodata_jk/bindings/biodata_jk_binding.dart';
import '../modules/biodata_jk/views/biodata_jk_view.dart';
import '../modules/biodata_tinggi_berat/bindings/biodata_tinggi_berat_binding.dart';
import '../modules/biodata_tinggi_berat/views/biodata_tinggi_berat_view.dart';
import '../modules/biodata_umur/bindings/biodata_umur_binding.dart';
import '../modules/biodata_umur/views/biodata_umur_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/jelajah/bindings/jelajah_binding.dart';
import '../modules/jelajah/views/jelajah_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/latihan/bindings/latihan_binding.dart';
import '../modules/latihan/views/latihan_view.dart';
import '../modules/latihan_camera/bindings/latihan_camera_binding.dart';
import '../modules/latihan_camera/views/latihan_camera_view.dart';
import '../modules/latihan_detail/bindings/latihan_detail_binding.dart';
import '../modules/latihan_detail/views/latihan_detail_view.dart';
import '../modules/latihan_v1/bindings/latihan_v1_binding.dart';
import '../modules/latihan_v1/views/latihan_v1_view.dart';
import '../modules/latihan_v2/bindings/latihan_v2_binding.dart';
import '../modules/latihan_v2/views/latihan_v2_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp_verifikasi/bindings/otp_verifikasi_binding.dart';
import '../modules/otp_verifikasi/views/otp_verifikasi_view.dart';
import '../modules/pengaturan/bindings/pengaturan_binding.dart';
import '../modules/pengaturan/views/pengaturan_view.dart';
import '../modules/pengaturan_latihan/bindings/pengaturan_latihan_binding.dart';
import '../modules/pengaturan_latihan/views/pengaturan_latihan_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setelan_umum/bindings/setelan_umum_binding.dart';
import '../modules/setelan_umum/views/setelan_umum_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(name: _Paths.INFO, page: () => InfoView(), binding: InfoBinding()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFIKASI,
      page: () => OtpVerifikasiView(),
      binding: OtpVerifikasiBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA_JK,
      page: () => BiodataJkView(),
      binding: BiodataJkBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA_UMUR,
      page: () => BiodataUmurView(),
      binding: BiodataUmurBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA_TINGGI_BERAT,
      page: () => BiodataTinggiBeratView(),
      binding: BiodataTinggiBeratBinding(),
    ),
    GetPage(
      name: _Paths.LAPORAN,
      page: () => LaporanView(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: _Paths.JELAJAH,
      page: () => JelajahView(),
      binding: JelajahBinding(),
    ),
    GetPage(
      name: _Paths.PENGATURAN,
      page: () => PengaturanView(),
      binding: PengaturanBinding(),
    ),
    GetPage(
      name: _Paths.PENGATURAN_LATIHAN,
      page: () => PengaturanLatihanView(),
      binding: PengaturanLatihanBinding(),
    ),
    GetPage(
      name: _Paths.SETELAN_UMUM,
      page: () => SetelanUmumView(),
      binding: SetelanUmumBinding(),
    ),
    GetPage(
      name: _Paths.LATIHAN,
      page: () => LatihanView(),
      binding: LatihanBinding(),
    ),
    GetPage(
      name: _Paths.LATIHAN_V2,
      page: () => LatihanV2View(),
      binding: LatihanV2Binding(),
    ),
    GetPage(
      name: _Paths.LATIHAN_V1,
      page: () => LatihanV1View(),
      binding: LatihanV1Binding(),
    ),
    GetPage(
      name: _Paths.LATIHAN_DETAIL,
      page: () => LatihanDetailView(),
      binding: LatihanDetailBinding(),
    ),
    GetPage(
      name: _Paths.LATIHAN_CAMERA,
      page: () =>  LatihanCameraView(),
      binding: LatihanCameraBinding(),
    ),
  ];
}
