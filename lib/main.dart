import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Mengimpor package GetX yang baru kita install
import 'screens/main_screen.dart';

void main() {
  // Fungsi main() adalah pintu masuk utama saat aplikasi dijalankan
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita menggunakan GetMaterialApp, BUKAN MaterialApp biasa.
    // Ini hukumnya wajib agar seluruh fitur canggih GetX (seperti pindah halaman,
    // pop-up, dan state management) bisa menyala di seluruh aplikasi.
    return GetMaterialApp(
      title: 'ResepPintar AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      // Ubah bagian ini untuk memanggil file HomeScreen yang baru kita buat
      home: MainScreen(),
    );
  }
}
