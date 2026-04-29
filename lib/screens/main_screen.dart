// File: lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../utils/app_colors.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

// Import halaman-halaman yang udah kita bikin
import 'home_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  // Mendaftarkan Controller ke dalam halaman ini
  final MainController controller = Get.put(MainController());

  // Ini ibarat Route di Laravel. Array berisi halaman apa aja yang mau ditampilin.
  final List<Widget> pages = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Obx() ini yang bertugas "mengawasi" perubahan data di Controller.
    // Kalau selectedIndex berubah, Obx akan me-render ulang isi layarnya.
    return Obx(
      () => Scaffold(
        // Bagian body ini mirip @yield('content'). Akan berubah sesuai index menu yang diklik.
        body: pages[controller.selectedIndex.value],

        // Menu Bawah (Footer)
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller
                .changeTabIndex, // Panggil fungsi di controller saat menu diklik
            type: BottomNavigationBarType
                .fixed, // Biar menunya ga gerak-gerak aneh
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search, size: 28),
                label: 'SEARCH',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'FAVORITES',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'PROFILE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
