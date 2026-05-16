import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib buat Firebase
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

// --- TAMBAHIN IMPORT CONTROLLER DI SINI ---
import 'controllers/auth_controller.dart';
import 'controllers/recipe_controller.dart';

// Tambahin 'async' di sini
void main() async {
  // Dua baris ini hukumnya WAJIB sebelum runApp kalau pakai Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ==========================================
  // BIKIN PABRIK OTAKNYA DI SINI BIAR GLOBAL & ABADI!
  // ==========================================
  Get.put(AuthController(), permanent: true);
  Get.put(RecipeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ResepPintar AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),

      // 1. Kasih tau pintu masuk pertamanya ke mana
      initialRoute: '/login',

      // 2. Daftarin semua "peta" jalan aplikasi lu di sini
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
          name: '/home',
          page: () => MainScreen(),
        ), // Pastiin class lu namanya MainScreen
      ],
    );
  }
}
