// File: lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Latar abu-biru super muda

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primaryColor),
          onPressed: () {},
        ),
        title: const Text(
          'ResepPintar AI',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
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
                  color: const Color(0xFFEDF4FC), // Biru pudar elegan
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    // Avatar + Tombol Edit
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
                            image: const DecorationImage(
                              // Dummy gambar chef dari Unsplash (bisa diganti foto profil beneran nanti)
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1583394838336-acd977736f90?q=80&w=400&auto=format&fit=crop',
                              ),
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
                              color: AppColors.primaryColor, // Cokelat/Oren
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

                    // Nama & Email
                    const Text(
                      'Hudzaifah', // Sesuaikan nama user
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'hudzaifah.chef@reseppintar.ai',
                      style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 16),

                    // Badges (Elite Chef & AI Master)
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
                          ), // Oren
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
                    // Stat 1
                    const Text(
                      '124',
                      style: TextStyle(
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

                    // Stat 2
                    const Text(
                      '12',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF388E3C),
                      ),
                    ), // Hijau gelap
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
                      'Manage your curated collections',
                    ),
                    Divider(
                      color: Colors.grey[100],
                      height: 1,
                      indent: 80,
                    ), // Garis pembatas tipis
                    _buildMenuItem(
                      Icons.settings_outlined,
                      const Color(0xFFD6E8FF),
                      AppColors.primaryColor,
                      'Settings',
                      'Account preferences and security',
                    ),
                    Divider(color: Colors.grey[100], height: 1, indent: 80),
                    _buildMenuItem(
                      Icons.favorite_border,
                      const Color(0xFFD6E8FF),
                      AppColors.primaryColor,
                      'Taste Profile',
                      'Dietary restrictions and preferences',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- BAGIAN 4: LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // Spasi bawah biar gak mentok nav bar
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi Helper untuk bikin baris menu berulang-ulang
  Widget _buildMenuItem(
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    String title,
    String subtitle,
  ) {
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
      onTap: () {}, // Nanti diisi logika pindah halaman
    );
  }
}
