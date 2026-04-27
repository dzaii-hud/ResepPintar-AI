import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib buat Firebase
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

// Tambahin 'async' di sini
void main() async {
  // Dua baris ini hukumnya WAJIB sebelum runApp kalau pakai Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      // Nah, pintunya kita arahin ke LoginScreen di sini
      home: const LoginScreen(),
    );
  }
}
