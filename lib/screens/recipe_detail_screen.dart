// File: lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // NANGKEP DATA DARI HALAMAN SEBELUMNYA DI SINI
    final Map<String, dynamic> recipe = Get.arguments ?? {};

    // Kalau misal datanya nyasar/kosong, tampilin error biar gak crash
    if (recipe.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Waduh, datanya nyangkut bre!')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- HEADER: GAMBAR AESTHETIC ---
          SliverAppBar(
            expandedHeight: 350,
            pinned: true, // Biar tombol back gak ikut ilang pas discroll
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: recipe['image_url'] != null
                  ? Image.asset(
                      recipe['image_url'],
                      fit: BoxFit.cover,
                      // Tambahin errorBuilder biar kalau salah ketik nama file ga crash
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.orange[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.orange[200],
                      child: const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          // --- KONTEN DETAIL BAWAH ---
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              // Efek minus biar narik kotak putihnya naik nimpa gambar
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---> TAMBAHIN BARIS INI BIAR NGGAK MEPET <---
                  const SizedBox(height: 16),

                  // 1. Tag Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(int.parse(recipe['tag_color'])),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe['tag'],
                      style: TextStyle(
                        color: Color(int.parse(recipe['tag_text_color'])),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Judul & Bintang Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe['title'],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              recipe['rating'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. Ikon Informasi (Waktu, Kalori, Kesulitan)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoIcon(
                        Icons.timer_outlined,
                        recipe['time'],
                        'Prep Time',
                      ),
                      _buildInfoIcon(
                        Icons.local_fire_department_outlined,
                        recipe['calories'] ?? 'N/A',
                        'Calories',
                      ),
                      _buildInfoIcon(
                        Icons.restaurant,
                        recipe['difficulty'],
                        'Difficulty',
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // 4. Deskripsi Pendek
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 5. Bahan-Bahan
                  const Text(
                    'Bahan-bahan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe['ingredients'] ?? 'Bahan belum tersedia.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 6. Cara Membuat
                  const Text(
                    'Cara Membuat',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe['steps'] ?? 'Langkah belum tersedia.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon, String value, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
