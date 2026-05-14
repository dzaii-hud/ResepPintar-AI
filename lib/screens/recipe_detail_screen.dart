// File: lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/recipe_controller.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  // === FUNGSI SAKTI BUAT BIKIN KOTAK EMOJI ATAU GAMBAR ===
  Widget _buildImageOrEmoji(String? imageUrl) {
    String imageVal = imageUrl ?? 'assets/images/default.jpeg';

    // Deteksi kalau isinya cuma 1-3 karakter (Emoji)
    bool isEmoji =
        imageVal.length <= 3 &&
        !imageVal.contains('assets') &&
        !imageVal.contains('http');

    if (isEmoji) {
      return Container(
        color: const Color(0xFFFBE9E7), // Warna pastel estetik
        child: Center(
          child: Text(
            imageVal,
            style: const TextStyle(
              fontSize: 120,
            ), // Ukuran emoji gede buat header
          ),
        ),
      );
    } else {
      return Image.asset(
        imageVal,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.orange[200],
          child: const Icon(Icons.broken_image, size: 80, color: Colors.white),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> recipe = Get.arguments ?? {};

    if (recipe.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Waduh, datanya nyangkut bre!')),
      );
    }

    // Default value buat data yang rawan null dari AI
    String tagColor = recipe['tag_color'] ?? '0xFFFFFFFF';
    String tagTextColor = recipe['tag_text_color'] ?? '0xFF000000';
    String tagText = recipe['tag'] ?? 'AI CHEF';
    String ratingText =
        recipe['rating'] ?? '5.0'; // Kasih nilai sempurna buat AI 😎

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- HEADER: GAMBAR AESTHETIC ---
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
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
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Obx(() {
                  final controller = Get.find<RecipeController>();
                  bool isFav = controller.favoriteIds.contains(recipe['id']);

                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey[700],
                      size: 24,
                    ),
                    onPressed: () {
                      controller.toggleFavorite(recipe['id']);
                    },
                  );
                }),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              // --- PANGGIL FUNGSI EMOJI DI SINI ---
              background: _buildImageOrEmoji(recipe['image_url']),
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
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 1. Tag Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(int.parse(tagColor)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ), // Kasih border tipis kalau putih
                    ),
                    child: Text(
                      tagText,
                      style: TextStyle(
                        color: Color(int.parse(tagTextColor)),
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
                          recipe['title'] ?? 'Resep Spesial',
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
                              ratingText,
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

                  // 3. Ikon Informasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoIcon(
                        Icons.timer_outlined,
                        recipe['time'] ?? '-',
                        'Prep Time',
                      ),
                      _buildInfoIcon(
                        Icons.local_fire_department_outlined,
                        recipe['calories'] ?? 'N/A',
                        'Calories',
                      ),
                      _buildInfoIcon(
                        Icons.restaurant,
                        recipe['difficulty'] ?? '-',
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
                    recipe['description'] ??
                        'Belum ada deskripsi untuk resep ini.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 5. Bahan-Bahan
                  // Kalau ini resep AI, biasanya bahan dan step nyampur di deskripsi
                  // Kita tampilin text beda kalau bahannya kosong
                  if (recipe['ingredients'] != null) ...[
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
                      recipe['ingredients'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 6. Cara Membuat
                  if (recipe['steps'] != null) ...[
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
                      recipe['steps'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
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
