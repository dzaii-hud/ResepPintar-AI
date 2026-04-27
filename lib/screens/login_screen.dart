import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo atau Ikon Aplikasi
              const Icon(Icons.restaurant_menu, size: 100, color: AppColors.primaryColor),
              const SizedBox(height: 24),
              
              // 2. Judul Sapaan
              const Text(
                'Resep Pintar',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryTextColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masak jadi lebih mudah dan personal.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 48),

              // 3. Tombol Login Google
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => authController.loginWithGoogle(),
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                    height: 24,
                  ),
                  label: const Text('Masuk dengan Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}