import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:silat_mastery_app_2/app/routes/app_pages.dart';
import 'package:silat_mastery_app_2/app/widget/tema/app_tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);

  final box = GetStorage();
  final token = box.read("token");
  final user = box.read("user");

  String initialRoute;
  if (token != null && user != null) {
    final profileComplete = user["profile_complete"] ?? false;
    initialRoute = profileComplete ? Routes.HOME : Routes.BIODATA_JK;
  } else {
    initialRoute = Routes.LOGIN;
  }

  runApp(SilatMasteryApp(initialRoute: initialRoute));
}

class SilatMasteryApp extends StatelessWidget {
  final String initialRoute;
  const SilatMasteryApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silat Mastery',
      theme: AppTheme.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
