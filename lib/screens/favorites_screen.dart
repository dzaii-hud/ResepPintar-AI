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
  // === FUNGSI SAKTI BUAT BIKIN KOTAK EMOJI ATAU GAMBAR ===
  Widget _buildImageOrEmoji(
    String? imageUrl,
    double height, {
    double? width,
    BorderRadius? borderRadius,
  }) {
    String imageVal = imageUrl ?? 'assets/images/default.jpeg';

    // Kalau isinya cuma 1-3 karakter, kemungkinan besar itu EMOJI
    bool isEmoji =
        imageVal.length <= 3 &&
        !imageVal.contains('assets') &&
        !imageVal.contains('http');

    if (isEmoji) {
      return Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFBE9E7), // Warna background pastel estetik
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        child: Center(
          child: Text(
            imageVal,
            style: TextStyle(fontSize: height * 0.4), // Ukuran emoji dinamis
          ),
        ),
      );
    } else {
      // Kalau panjang, berarti file lokal (assets)
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          imageVal,
          height: height,
          width: width ?? double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: width ?? double.infinity,
              color: Colors.orange[200],
              child: const Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 50,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Panggil koki kita (Controller)
    final controller = Get.put(RecipeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primaryColor),
          onPressed: () {},
        ),
        title: const Text(
          'Resep Pintar',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
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
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          // Fungsi narik ulang data dari Laravel kalau ditarik ke bawah
          controller.fetchRecipes();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN 1: HEADER TEXT & SLIDER VIP ---
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
                      const SizedBox(height: 24),
                      // ==========================================
                      // START: SLIDER VIP RESEP FAVORIT
                      // ==========================================
                      Obx(() {
                        final favRecipes = controller.onlyFavoriteRecipes;

                        if (favRecipes.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Belum ada resep VIP.\nCari resep favoritmu dan pencet tombol hatinya!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: favRecipes.length,
                            itemBuilder: (context, index) {
                              var recipe = favRecipes[index];
                              return GestureDetector(
                                onTap: () => Get.to(
                                  () => const RecipeDetailScreen(),
                                  arguments: recipe,
                                ),
                                child: Container(
                                  width: 220,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // --- Panggil Fungsi Sakti di Sini ---
                                      _buildImageOrEmoji(
                                        recipe['image_url'],
                                        200,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      // --- Layer Gelap Buat Teks Biar Kebaca ---
                                      Container(
                                        width: double
                                            .infinity, // <--- INI DIA OBAT MELARNYA BRE
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                recipe['difficulty'] ?? 'Mudah',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              recipe['title'] ?? 'Nama Resep',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
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
                    onChanged: (value) => controller.updateSearchQuery(value),
                    decoration: const InputDecoration(
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
                      children: ['Semua Resep', 'Mudah', 'Sedang', 'Susah'].map(
                        (filter) {
                          bool isSelected =
                              controller.selectedFavFilter.value == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected)
                                  controller.selectedFavFilter.value = filter;
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
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- BAGIAN 4: LIST KARTU SEMUA RESEP (DIAMBIL DARI LARAVEL) ---
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  // PERHATIAN: Di bawah ini udah gw ganti manggil SEMUA resep yang difilter, bukan fav doang
                  var displayRecipes = controller.filteredFavRecipes;

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
                                color: Colors.black.withOpacity(0.05),
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
                                  // --- Panggil Fungsi Sakti di Sini ---
                                  _buildImageOrEmoji(
                                    recipe['image_url'],
                                    200,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(32),
                                    ),
                                  ),
                                  // ------------------------------------
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
                                        recipe['tag'] ?? 'BARU',
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
                                        bool isFav = controller.favoriteIds
                                            .contains(recipe['id']);
                                        return GestureDetector(
                                          onTap: () => controller
                                              .toggleFavorite(recipe['id']),
                                          child: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFav
                                                ? const Color(0xFFD32F2F)
                                                : Colors.grey,
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
                                              color:
                                                  AppColors.secondaryTextColor,
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
                                                color: AppColors
                                                    .secondaryTextColor,
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
                                                color: AppColors
                                                    .secondaryTextColor,
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
                                          recipe['rating'] ?? '5.0',
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
      ),
    );
  }
}
