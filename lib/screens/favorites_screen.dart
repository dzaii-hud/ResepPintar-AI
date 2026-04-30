// File: lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import 'recipe_detail_screen.dart';
import '../controllers/recipe_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    // Panggil koki kita (Controller) - Cukup satu aja biar ga dobel
    final controller = Get.put(RecipeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // --- TEMPEL INI DI BAGIAN appBar: ---
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Latar transparan elegan
        elevation: 0, // Hapus bayangan biar flat cakep
        centerTitle: true, // INI YANG BIKIN KE TENGAH
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.primaryColor,
          ), // Warna oranye utama
          onPressed: () {}, // Nanti diisi logika drawer
        ),
        title: const Text(
          'Resep Pintar', // AI-nya dihapus, miringnya dihapus
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold, // Cuma tebel aja
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.primaryTextColor, // Warna teks biasa
            ),
            onPressed: () {}, // Nanti diisi logika notifikasi
          ),
        ],
      ),
      // ------------------------------------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BAGIAN 1: HEADER TEXT ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF4FC),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CURATED COLLECTION',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Culinary\nMasterpieces',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.secondaryTextColor,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Every kitchen has its secrets.\nRevisit the flavors you love and\nthe recipes that ',
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'made',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' your\ntable unforgettable.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- BAGIAN 2: SEARCH BAR ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF2F7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  // <-- Kata 'const' di sini udah gw hapus
                  // INI KABEL SENSORNYA BRE:
                  onChanged: (value) => controller.updateSearchQuery(value),

                  decoration: const InputDecoration(
                    // <-- Kata 'const' gw pindahin ke sini biar tetep enteng
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search your favorites...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- BAGIAN 3: FILTER CHIPS DINAMIS ---
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua Resep', 'Mudah', 'Sedang', 'Susah'].map((
                      filter,
                    ) {
                      bool isSelected =
                          controller.selectedFavFilter.value == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedFavFilter.value = filter;
                            }
                          },
                          selectedColor: AppColors.primaryColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- BAGIAN 4: LIST KARTU RESEP (DIAMBIL DARI LARAVEL) ---
              Obx(() {
                // 1. Kalau lagi proses narik data, tampilin loading muter
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                // 2. Ambil data yang UDAH DIFILTER dari controller
                var displayRecipes = controller.filteredFavRecipes;

                // 3. Kalau datanya kosong (setelah difilter), tampilin teks
                if (displayRecipes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Belum ada resep yang sesuai.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // 4. Kalau datanya ada, baru render kartunya
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
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(32),
                                    ),
                                    // Sudah diganti jadi Image.asset biar ngambil dari file lokal
                                    child: recipe['image_url'] != null
                                        ? Image.asset(
                                            recipe['image_url'],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.orange[200],
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            color: Colors.orange[200],
                                            child: const Icon(
                                              Icons.restaurant,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                          recipe['tag_color'] ?? '0xFFFFFFFF',
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      recipe['tag'] ?? '',
                                      style: TextStyle(
                                        color: Color(
                                          int.parse(
                                            recipe['tag_text_color'] ??
                                                '0xFF000000',
                                          ),
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Obx(() {
                                      // Cek apakah resep ini ada di daftar love
                                      bool isFav = controller.favoriteIds
                                          .contains(recipe['id']);

                                      return GestureDetector(
                                        onTap: () {
                                          // Pas icon dipencet, hapus/tambah dari favorit
                                          controller.toggleFavorite(
                                            recipe['id'],
                                          );
                                        },
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFav
                                              ? const Color(0xFFD32F2F)
                                              : Colors
                                                    .grey, // Merah kalau dilove, abu kalau dilepas
                                          size: 20,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          recipe['description'] ?? '',
                                          style: const TextStyle(
                                            color: AppColors.secondaryTextColor,
                                            height: 1.5,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_outlined,
                                              size: 16,
                                              color:
                                                  AppColors.secondaryTextColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              recipe['time'] ?? '',
                                              style: const TextStyle(
                                                color: AppColors
                                                    .secondaryTextColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            const Icon(
                                              Icons.restaurant,
                                              size: 16,
                                              color:
                                                  AppColors.secondaryTextColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              recipe['difficulty'] ?? '',
                                              style: const TextStyle(
                                                color: AppColors
                                                    .secondaryTextColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Text(
                                        recipe['rating'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.primaryColor,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
