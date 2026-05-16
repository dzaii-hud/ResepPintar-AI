// File: lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final authController = Get.find<AuthController>();
  final recipeController = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryColor,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KATEGORI 1: PERSONALISASI ---
            const Text(
              'Personalisasi Dapur 🔪',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: authController.title1.value,
                    // Setiap kali diketik, nilainya otomatis masuk ke controller & diubah jadi HURUF KAPITAL
                    onChanged: (value) =>
                        authController.title1.value = value.toUpperCase(),
                    decoration: InputDecoration(
                      labelText: 'Gelar Pertama (Hijau)',
                      labelStyle: const TextStyle(
                        color: AppColors.primaryColor,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: authController.title2.value,
                    onChanged: (value) =>
                        authController.title2.value = value.toUpperCase(),
                    decoration: InputDecoration(
                      labelText: 'Gelar Kedua (Oranye)',
                      labelStyle: const TextStyle(color: Colors.orange),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- KATEGORI 2: PENGATURAN DATA ---
            const Text(
              'Pengaturan Data 🧹',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_sweep,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Bersihkan Favorit',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text(
                  'Hapus semua resep dari daftar love',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // Dialog konfirmasi biar kaga salah pencet
                  Get.defaultDialog(
                    title: "Hapus Favorit?",
                    middleText:
                        "Yakin mau hapus semua resep dari daftar favoritmu?",
                    textCancel: "Batal",
                    textConfirm: "Ya, Hapus",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    cancelTextColor: Colors.grey,
                    onConfirm: () {
                      recipeController.favoriteIds
                          .clear(); // Kosongin list love!
                      Get.back(); // Tutup dialog
                      Get.snackbar(
                        'Berhasil',
                        'Daftar favorit sudah bersih!',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // --- KATEGORI 3: INFORMASI ---
            const Text(
              'Informasi ℹ️',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Tentang Aplikasi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text(
                  'Versi, Developer, & Info',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // Munculin pop-up estetik pas diklik
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.restaurant_menu,
                            size: 80,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Resep Pintar AI',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Versi 1.0.0',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Dikembangkan dengan ☕ oleh:',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Hudzaifah Zafa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Tutup',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
