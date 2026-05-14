// File: lib/screens/my_ai_recipes_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/recipe_controller.dart';
import 'recipe_detail_screen.dart';
import 'package:http/http.dart' as http;

class MyAiRecipesScreen extends StatelessWidget {
  const MyAiRecipesScreen({super.key});

  Widget _buildImageOrEmoji(
    String? imageUrl,
    double height, {
    double? width,
    BorderRadius? borderRadius,
  }) {
    String imageVal = imageUrl ?? 'assets/images/default.jpeg';

    bool isEmoji =
        imageVal.length <= 3 &&
        !imageVal.contains('assets') &&
        !imageVal.contains('http');

    if (isEmoji) {
      return Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFBE9E7),
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

  Future<void> _deleteRecipe(
    BuildContext context,
    int id,
    RecipeController controller,
  ) async {
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
            content: const Text(
              'Yakin mau hapus resep AI ini dari koleksi kamu?',
            ),
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

    final String apiUrl = 'http://192.168.0.232:8000/api/ai-chef/delete/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil dihapus! 🗑️')),
        );
        controller.fetchRecipes();
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
    final controller = Get.find<RecipeController>();

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
          'Koleksi AI Chef',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          controller.fetchRecipes();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          var displayRecipes = controller.onlyAiRecipes;

          if (displayRecipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Koleksi Masih Kosong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Kamu belum menyimpan resep apapun dari AI Chef. Yuk ngobrol dan minta resep sekarang!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: displayRecipes.length,
            itemBuilder: (context, index) {
              final recipe = displayRecipes[index];

              return GestureDetector(
                onTap: () {
                  Get.to(() => const RecipeDetailScreen(), arguments: recipe);
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
                      _buildImageOrEmoji(
                        recipe['image_url'],
                        80,
                        width: 80,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(width: 12), // Jarak dikecilin dikit
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 15, // Font dikecilin dikit biar muat
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTextColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // --- INI OBAT DIETNYA (Pake Wrap biar ga nabrak) ---
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      size: 14,
                                      color: AppColors.secondaryTextColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      recipe['time'] ?? '',
                                      style: const TextStyle(
                                        color: AppColors.secondaryTextColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCE4EC),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    recipe['difficulty'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.brown,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // --- TOMBOL DELETE & FAVORITE (Padding dibuang biar ga makan tempat) ---
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            constraints:
                                const BoxConstraints(), // Hapus padding default
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ), // Kasih tipis aja
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            onPressed: () => _deleteRecipe(
                              context,
                              recipe['id'],
                              controller,
                            ),
                          ),
                          Obx(() {
                            bool isFav = controller.favoriteIds.contains(
                              recipe['id'],
                            );
                            return IconButton(
                              constraints:
                                  const BoxConstraints(), // Hapus padding default
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav
                                    ? Colors.red
                                    : AppColors.primaryColor,
                                size: 22,
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
      ),
    );
  }
}
