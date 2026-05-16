// File: lib/screens/ai_guide_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class AiGuideScreen extends StatelessWidget {
  const AiGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Buku Panduan AI',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER INFO APLIKASI ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Dokumentasi Resep Pintar AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Versi 1.0.0 • Dibuat oleh Hudzaifah Zafa',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),

            // --- TIPS PROMPTING ---
            const Text(
              '💡 Tips Jitu Ngobrol Sama AI Chef',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildTipCard(
              '1. Sebutkan Bahan Spesifik',
              'Daripada bilang "masak apa ya?", coba bilang "Aku punya ayam, kecap, dan bawang. Enaknya dibikin apa?" Hasilnya bakal jauh lebih akurat.',
              Icons.kitchen,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              '2. Tentukan Tingkat Kesulitan',
              'Kalau lagi buru-buru, tambahin kata "yang gampang dan cepat (di bawah 15 menit)" di pesanmu.',
              Icons.timer,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              '3. Request Gaya Makanan',
              'AI bisa bikin resep gaya apapun. Coba tambahin "bikin ala restoran mewah" atau "versi diet rendah kalori".',
              Icons.restaurant_menu,
            ),

            const SizedBox(height: 32),

            // --- QUOTES MOTIVASI ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Every expert was once a beginner."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tetap semangat bereksperimen di dapur dan meracik barisan kode!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
