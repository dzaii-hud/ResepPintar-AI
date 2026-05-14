// File: lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../controllers/recipe_controller.dart';
import 'my_ai_recipes_screen.dart'; // Nanti kita bikin file ini bre

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        final recipeController = Get.find<RecipeController>();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // --- BAGIAN 1: PROFILE HEADER ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF4FC),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              image: DecorationImage(
                                image: authController.userPhoto.value.isNotEmpty
                                    ? NetworkImage(
                                        authController.userPhoto.value,
                                      )
                                    : const NetworkImage(
                                            'https://images.unsplash.com/photo-1583394838336-acd977736f90?q=80&w=400&auto=format&fit=crop',
                                          )
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        authController.userName.value.isNotEmpty
                            ? authController.userName.value
                            : 'Guest',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authController.userEmail.value.isNotEmpty
                            ? authController.userEmail.value
                            : 'Belum login',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8E6C9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ELITE CHEF',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8A65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'AI MASTER',
                              style: TextStyle(
                                color: Color(0xFF8D4004),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- BAGIAN 2: STATS CARD ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${recipeController.favoriteCount}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'SAVED RECIPES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ==========================================
                      // INI ANGKA AI PROMPTS YANG UDAH LIVE
                      // ==========================================
                      Text(
                        '${recipeController.aiRecipeCount}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'CUSTOM AI PROMPTS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- BAGIAN 3: MENU LIST CARD ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
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
                      _buildMenuItem(
                        Icons.restaurant,
                        AppColors.primaryColor,
                        Colors.white,
                        'My Recipes',
                        'Manage your AI generated collections',
                        // Fungsi pindah ke halaman MyAiRecipesScreen
                        onTap: () => Get.to(() => const MyAiRecipesScreen()),
                      ),
                      Divider(color: Colors.grey[100], height: 1, indent: 80),
                      _buildMenuItem(
                        Icons.settings_outlined,
                        const Color(0xFFD6E8FF),
                        AppColors.primaryColor,
                        'Settings',
                        'Account preferences and security',
                        onTap: () {},
                      ),
                      Divider(color: Colors.grey[100], height: 1, indent: 80),
                      _buildMenuItem(
                        // Ikon buku biar cocok sama tema dokumentasi
                        Icons.menu_book_rounded,
                        const Color(0xFFD6E8FF),
                        AppColors.primaryColor,
                        // Judul diganti jadi Buku Panduan
                        'Buku Panduan AI',
                        'Tips meracik prompt resep yang lezat',
                        onTap: () {
                          // Nanti kalau ada halamannya tinggal masukin Get.to() ke sini
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- BAGIAN 4: LOGOUT BUTTON ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authController.logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    String title,
    String subtitle, {
    required VoidCallback
    onTap, // Tambahin parameter onTap biar menunya bisa diklik
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap, // Pasang fungsinya di sini
    );
  }
}
