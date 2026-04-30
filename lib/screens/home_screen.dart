// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'recipe_detail_screen.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart'; // Tambahin ini buat manggil otak controller

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil asisten pintar kita
    final controller = Get.put(RecipeController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Text(
                'Menu ResepPintar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {},
            ),
          ],
        ),
      ),
      // --- REVISI 2: APPBAR DITENGAHIN & GANTI NAMA ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // Ini yang bikin judulnya otomatis ke tengah
        title: const Text(
          'Resep Pintar', // "AI"-nya dihapus
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            // fontStyle: FontStyle.italic, // Efek miringnya dihapus
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.primaryTextColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- REVISI 1: TEKS HEADER DIPERPENDEK BIAR LEGA ---
              const Text(
                'Mau masak apa hari ini?',
                style: TextStyle(
                  fontSize: 28, // Ukuran dikecilin dikit dari 32 ke 28 biar pas
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryTextColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8), // Jarak dirapetin dikit
              const Text(
                'Temukan inspirasi menu terbaik untukmu.', // Teks dipersingkat
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.secondaryTextColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // --- REVISI 3: TEKS SEARCH BAR DIGANTI ---
              TextField(
                onChanged: (value) => controller.updateSearchQuery(value),
                decoration: InputDecoration(
                  hintText:
                      'Cari menu, resep, atau bahan...', // Diganti sesuai request lu
                  hintStyle: const TextStyle(
                    color: AppColors.secondaryTextColor,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.secondaryTextColor,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDF2F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              const SizedBox(height: 24),

              // ... (Kode SingleChildScrollView untuk tombol filter "Semua", "Sarapan", dst biarin aja sama persis kayak sebelumnya)
              const SizedBox(height: 24),

              // --- FILTER DINAMIS ---
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Sarapan', 'Makan Siang', 'Makan Malam']
                        .map((filter) {
                          bool isSelected =
                              controller.selectedHomeFilter.value == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedHomeFilter.value = filter;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.inactiveChipColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Teratas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- KARTU REKOMENDASI TERATAS (OTOMATIS NASI GORENG) ---
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                var topRecipe = controller.topRecommendation;
                if (topRecipe == null) return const SizedBox.shrink();

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const RecipeDetailScreen(),
                      arguments: topRecipe,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: topRecipe['image_url'] != null
                                  ? Image.asset(
                                      topRecipe['image_url'],
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 200,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    )
                                  : Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                    ),
                            ),
                            Positioned(
                              top: 15,
                              left: 15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      topRecipe['tag_color'] ?? '0xFFFFFFFF',
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  topRecipe['tag'] ?? '',
                                  style: TextStyle(
                                    color: Color(
                                      int.parse(
                                        topRecipe['tag_text_color'] ??
                                            '0xFF000000',
                                      ),
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topRecipe['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        topRecipe['rating'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // --- DAFTAR RESEP BAWAH (BERDASARKAN FILTER) ---
              Obx(() {
                if (controller.isLoading.value) return const SizedBox.shrink();

                var displayRecipes = controller.filteredHomeRecipes;

                if (displayRecipes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Belum ada resep di kategori ini.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = displayRecipes[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const RecipeDetailScreen(),
                          arguments: recipe,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: recipe['image_url'] != null
                                  ? Image.asset(
                                      recipe['image_url'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        size: 16,
                                        color: AppColors.secondaryTextColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        recipe['time'] ?? '',
                                        style: const TextStyle(
                                          color: AppColors.secondaryTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCE4EC),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          recipe['difficulty'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.brown,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // KODINGAN BARU (PASTE INI)
                            Obx(() {
                              // Cek apakah ID resep ini ada di dalam list favorit di controller
                              bool isFav = controller.favoriteIds.contains(
                                recipe['id'],
                              );

                              return IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons
                                            .favorite_border, // Kalau isFav true, hatinya full. Kalau false, hatinya bolong.
                                  color: isFav
                                      ? Colors.red
                                      : AppColors
                                            .primaryColor, // Kalau isFav true warnanya merah
                                ),
                                onPressed: () {
                                  // Pas dipencet, kirim ID resepnya ke controller buat disimpen/dihapus
                                  controller.toggleFavorite(recipe['id']);
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
