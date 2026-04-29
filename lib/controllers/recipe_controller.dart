import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeController extends GetxController {
  var recipes = [].obs;
  var isLoading = true.obs;

  // 1. TAMBAHIN INI: Variabel buat nampung teks yang diketik user
  var searchQuery = ''.obs;

  var selectedHomeFilter = 'Semua'.obs;
  var selectedFavFilter = 'Semua Resep'.obs;

  @override
  void onInit() {
    fetchRecipes();
    super.onInit();
  }

  // 2. TAMBAHIN INI: Fungsi buat update teks pencarian dari keyboard
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void fetchRecipes() async {
    try {
      isLoading(true);
      // Ganti IP sesuai IP laptop lu kalau ganti jaringan
      var response = await http.get(
        Uri.parse('http://192.168.0.232:8000/api/recipes'),
      );

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);

        if (decodedData is List) {
          recipes.value = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          recipes.value = decodedData['data'];
        } else {
          recipes.value = [];
        }

        print('MANTAP! Data berhasil ditarik: ${recipes.length} resep');
      }
    } catch (e) {
      print('Waduh error bre: $e');
    } finally {
      isLoading(false);
    }
  }

  // 3. LOGIKA FILTER HOME (Sekarang support Kategori + Search)
  List get filteredHomeRecipes {
    List filtered = recipes.toList();

    // A. Filter berdasarkan tombol kategori (Sarapan, dll)
    if (selectedHomeFilter.value != 'Semua') {
      filtered = filtered
          .where((recipe) => recipe['meal_time'] == selectedHomeFilter.value)
          .toList();
    }

    // B. Filter berdasarkan Search (Menu, Resep, atau Bahan)
    if (searchQuery.value.isNotEmpty) {
      var query = searchQuery.value.toLowerCase();
      filtered = filtered.where((recipe) {
        // Nyari di Nama Masakan
        var title = (recipe['title'] ?? '').toString().toLowerCase();
        // Nyari di Waktu Makan (Menu)
        var mealTime = (recipe['meal_time'] ?? '').toString().toLowerCase();
        // Nyari di Bahan-bahan
        // PENTING: Pastiin di Laravel nama field-nya 'ingredients' atau ganti sesuai field lu
        var ingredients = (recipe['ingredients'] ?? '')
            .toString()
            .toLowerCase();

        return title.contains(query) ||
            mealTime.contains(query) ||
            ingredients.contains(query);
      }).toList();
    }

    return filtered;
  }

  // --- LOGIKA FILTER FAVORITES (Sekarang support Kesulitan + Search) ---
  List get filteredFavRecipes {
    // 1. Ambil data mentah jadi List biasa
    List filtered = recipes.toList();

    // 2. Filter berdasarkan tingkat kesulitan (Mudah, Sedang, Susah)
    if (selectedFavFilter.value != 'Semua Resep') {
      filtered = filtered
          .where((recipe) => recipe['difficulty'] == selectedFavFilter.value)
          .toList();
    }

    // 3. Filter berdasarkan Search (biar bisa nyari nama/bahan di halaman favorite)
    if (searchQuery.value.isNotEmpty) {
      var query = searchQuery.value.toLowerCase();
      filtered = filtered.where((recipe) {
        var title = (recipe['title'] ?? '').toString().toLowerCase();
        var mealTime = (recipe['meal_time'] ?? '').toString().toLowerCase();
        var ingredients = (recipe['ingredients'] ?? '')
            .toString()
            .toLowerCase();

        return title.contains(query) ||
            mealTime.contains(query) ||
            ingredients.contains(query);
      }).toList();
    }

    return filtered;
  }

  // LOGIKA TOP REKOMENDASI
  Map<String, dynamic>? get topRecommendation {
    if (recipes.isEmpty) return null;
    return recipes.firstWhere(
      (recipe) => recipe['title'] == 'Nasi Goreng',
      orElse: () => recipes.first,
    );
  }
}
