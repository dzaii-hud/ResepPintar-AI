// File: lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // AppBar sama seperti di Home
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
            crossAxisAlignment:
                CrossAxisAlignment.center, // Bikin teks rata tengah
            children: [
              // --- BAGIAN 1: HEADER TEXT ---
              const Text(
                'Masak Apa Hari Ini?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const Text(
                'Sebutkan bahan yang ada di kulkas, AI kami akan meracik resep lezat untukmu.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryTextColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // --- BAGIAN 2: KOTAK INPUT AI ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEDF2F7,
                  ), // Warna biru/abu pucat sesuai desain
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BAHAN DI KULKAS',
                      style: TextStyle(
                        color: AppColors.primaryColor, // Warna teks cokelat
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing:
                            1.5, // Kasih jarak antar huruf dikit biar elegan
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Field Text
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Contoh: telur, sosis, bawang...',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white, // Latar input putih
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),

                        // Ikon Sparkle di sebelah kanan (suffixIcon)
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            // Pake ikon auto_awesome karena mirip banget sama desain sparkle AI temen lo
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

             
             // --- BAGIAN 3: HASIL RESEP AI (OVERLAPPING) ---
              Stack(
                children: [
                  // 1. Gambar Latar Belakang
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1620601616428-2c2626b9a84a?q=80&w=1000&auto=format&fit=crop', 
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 260, 
                          color: Colors.grey[300], 
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey)
                        );
                      },
                    ),
                  ),

                  // 2. Kartu Putih Resep
                  Container(
                    margin: const EdgeInsets.only(top: 200),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label Resep Kilat & Tombol Love
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8E6C9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'RESEP KILAT AI',
                                style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                              ),
                            ),
                            const Icon(Icons.favorite_border, color: AppColors.primaryColor),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Orak-Arik Sosis Istimewa',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryTextColor, height: 1.2),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Row(
                          children: const [
                            Icon(Icons.timer_outlined, size: 16, color: AppColors.secondaryTextColor),
                            SizedBox(width: 6),
                            Text('10 MENIT', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 16),
                            Icon(Icons.restaurant, size: 16, color: AppColors.secondaryTextColor),
                            SizedBox(width: 6),
                            Text('MUDAH', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        const SizedBox(height: 24),

                        // --- SUB-BAGIAN: BAHAN ---
                        Row(
                          children: [
                            Container(width: 4, height: 18, color: AppColors.primaryColor),
                            const SizedBox(width: 8),
                            const Text('Bahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryTextColor)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('• 2 Butir Telur', style: TextStyle(color: AppColors.secondaryTextColor)),
                                  SizedBox(height: 8),
                                  Text('• Bawang Merah', style: TextStyle(color: AppColors.secondaryTextColor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('• 3 Buah Sosis', style: TextStyle(color: AppColors.secondaryTextColor)),
                                  SizedBox(height: 8),
                                  Text('• Garam & Lada', style: TextStyle(color: AppColors.secondaryTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // --- SUB-BAGIAN: CARA MASAK ---
                        Row(
                          children: [
                            Container(width: 4, height: 18, color: AppColors.primaryColor),
                            const SizedBox(width: 8),
                            const Text('Cara Masak', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryTextColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('01', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 12),
                            Expanded(child: Text('Iris sosis dan bawang merah tipis-tipis. Kocok lepas telur dengan sedikit garam.', style: TextStyle(color: AppColors.secondaryTextColor, height: 1.5))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('02', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 12),
                            Expanded(child: Text('Tumis bawang hingga harum, masukkan sosis, masak sebentar hingga sedikit kecokelatan.', style: TextStyle(color: AppColors.secondaryTextColor, height: 1.5))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('03', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 12),
                            Expanded(child: Text('Tuang telur, biarkan sebentar lalu orak-arik pelan. Sajikan selagi hangat!', style: TextStyle(color: AppColors.secondaryTextColor, height: 1.5))),
                          ],
                        ),

                        const SizedBox(height: 32),
                        
                        // Tombol Mulai Memasak
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: const Text('Mulai Memasak Sekarang', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // --- BAGIAN 4: SARAN TAMBAHAN (DI LUAR KARTU PUTIH) ---
              // Karena ini rata kiri, kita bungkus Text-nya dengan Align atau penuhi lebarnya
              SizedBox(
                width: double.infinity,
                child: const Text(
                  'Saran Tambahan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryTextColor),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              
              // Baris Pertama (Pakcoy & Cabai)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: const [
                          Icon(Icons.eco_outlined, color: AppColors.primaryColor),
                          SizedBox(height: 8),
                          Text('PAKCOY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryTextColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: const [
                          Icon(Icons.local_fire_department_outlined, color: AppColors.primaryColor),
                          SizedBox(height: 8),
                          Text('CABAI RAWIT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryTextColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Baris Kedua (Kecap & Keju)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: const [
                          Icon(Icons.restaurant, color: AppColors.primaryColor),
                          SizedBox(height: 8),
                          Text('KECAP MANIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryTextColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: const [
                          Icon(Icons.lunch_dining, color: AppColors.primaryColor),
                          SizedBox(height: 8),
                          Text('KEJU', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryTextColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
