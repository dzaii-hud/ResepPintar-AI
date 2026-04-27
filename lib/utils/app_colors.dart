// File: lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Warna Cokelat/Oranye Utama (Dipakai di Bottom Nav Active, Chip Active, dll)
  // Gw nembak hex-nya dari screenshot lo, nanti kalau lo punya hex code aslinya, tinggal lo ganti.
  static const Color primaryColor = Color(0xFFAC510E); 

  // Warna Latar Belakang Aplikasi yang bersih
  static const Color backgroundColor = Color(0xFFF7F8FA);

  // Warna Chip/Tombol yang tidak aktif (Biru muda pucat)
  static const Color inactiveChipColor = Color(0xFFD4E7FA);

  // Warna Teks Utama (Hitam tapi agak abu-abu tua)
  static const Color primaryTextColor = Color(0xFF1E1E1E);

  // Warna Teks Subtitle/Deskripsi
  static const Color secondaryTextColor = Color(0xFF757575);

  // Warna Tag Hijau (misal: "SEHAT")
  static const Color successTagColor = Color(0xFFD2EED2);
  static const Color successTagTextColor = Color(0xFF1C631C);
}