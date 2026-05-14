// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'recipe_detail_screen.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';
import 'package:http/http.dart' as http; // Tambahin ini buat fungsi delete

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // === FUNGSI SAKTI BUAT BIKIN KOTAK EMOJI ATAU GAMBAR ===
  Widget _buildImageOrEmoji(
    String? imageUrl,
    double height, {
    double? width,
    BorderRadius? borderRadius,
  }) {
    String imageVal = imageUrl ?? 'assets/images/default.jpeg';

    // Deteksi kalau isinya cuma 1-3 karakter (Emoji)
    bool isEmoji =
        imageVal.length <= 3 &&
        !imageVal.contains('assets') &&
        !imageVal.contains('http');

    if (isEmoji) {
      return Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFBE9E7), // Warna pastel estetik
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        child: Center(
          child: Text(imageVal, style: TextStyle(fontSize: height * 0.4)),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          imageVal,
          height: height,
          width: width ?? double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: height,
            width: width ?? double.infinity,
            color: Colors.orange[200],
            child: const Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      );
    }
  }

  // === FUNGSI BUAT NGEHAPUS RESEP AI ===
  Future<void> _deleteRecipe(
    BuildContext context,
    int id,
    RecipeController controller,
  ) async {
    // Munculin pop-up konfirmasi dulu biar kaga salah pencet
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Hapus Resep?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Yakin mau hapus resep AI ini dari dapur?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    // CEK IP LU YA BRE! Samain sama yang lu pake di AI Chef Screen
    final String apiUrl = 'http://192.168.0.232:8000/api/ai-chef/delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil dihapus! 🗑️')),
        );
        controller.fetchRecipes(); // Suruh controller tarik data terbaru
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal hapus. Status: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error jaringan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
        // Tambahin pull-to-refresh biar mantap
        color: AppColors.primaryColor,
        onRefresh: () async {
          controller.fetchRecipes();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mau masak apa hari ini?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryTextColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan inspirasi menu terbaik untukmu.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.secondaryTextColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => controller.updateSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Cari menu, resep, atau bahan...',
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
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            'Semua',
                            'Sarapan',
                            'Makan Siang',
                            'Makan Malam',
                          ].map((filter) {
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
                          }).toList(),
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
                // --- KARTU REKOMENDASI TERATAS ---
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
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
                              // --- PANGGIL FUNGSI EMOJI DI SINI ---
                              _buildImageOrEmoji(
                                topRecipe['image_url'],
                                200,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topRecipe['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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

                // --- DAFTAR RESEP BAWAH ---
                Obx(() {
                  if (controller.isLoading.value)
                    return const SizedBox.shrink();

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
                      // Deteksi apakah ini resep buatan AI (dari judul atau isinya)
                      bool isAiRecipe = (recipe['title'] ?? '')
                          .toString()
                          .contains('🤖');

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
                              // --- PANGGIL FUNGSI EMOJI DI SINI ---
                              _buildImageOrEmoji(
                                recipe['image_url'],
                                80,
                                width: 80,
                                borderRadius: BorderRadius.circular(16),
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
                              // TOMBOL DELETE & FAVORITE
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Tombol hapus cuma nongol kalau resep AI
                                  if (isAiRecipe)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => _deleteRecipe(
                                        context,
                                        recipe['id'],
                                        controller,
                                      ),
                                    ),
                                  Obx(() {
                                    bool isFav = controller.favoriteIds
                                        .contains(recipe['id']);
                                    return IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFav
                                            ? Colors.red
                                            : AppColors.primaryColor,
                                      ),
                                      onPressed: () {
                                        controller.toggleFavorite(recipe['id']);
                                      },
                                    );
                                  }),
                                ],
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
