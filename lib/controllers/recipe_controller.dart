import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeController extends GetxController {
  var recipes = [].obs;
  var isLoading = true.obs;

  var searchQuery = ''.obs;
  var selectedHomeFilter = 'Semua'.obs;
  var selectedFavFilter = 'Semua Resep'.obs;

  // ==========================================
  // FITUR FAVORITE (LOVE) BARU DITAMBAHIN SINI
  // ==========================================
  var favoriteIds = <int>[].obs; // Nyimpen ID resep yg di-love

  // Fungsi buat nambah/hapus love
  void toggleFavorite(int recipeId) {
    if (favoriteIds.contains(recipeId)) {
      favoriteIds.remove(recipeId);
    } else {
      favoriteIds.add(recipeId);
    }
  }

  // Buat ngitung jumlah resep yg di-love (Buat di Halaman Profile)
  int get favoriteCount => favoriteIds.length;

  // Buat ngambil data lengkap resep yg di-love (Buat UI Card Gede nanti)
  List get onlyFavoriteRecipes {
    return recipes
        .where((recipe) => favoriteIds.contains(recipe['id']))
        .toList();
  }
  // ==========================================

  @override
  void onInit() {
    fetchRecipes();
    super.onInit();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void fetchRecipes() async {
    try {
      isLoading(true);
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

  // LOGIKA FILTER HOME
  List get filteredHomeRecipes {
    List filtered = recipes.toList();

    if (selectedHomeFilter.value != 'Semua') {
      filtered = filtered
          .where((recipe) => recipe['meal_time'] == selectedHomeFilter.value)
          .toList();
    }

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

  // --- LOGIKA FILTER FAVORITES ---
  List get filteredFavRecipes {
    // PERUBAHAN PENTING: Sekarang dia ngambil dari resep yg di-love aja, BUKAN semua resep!
    List filtered = onlyFavoriteRecipes.toList();

    // Filter Mudah/Sedang/Susah
    if (selectedFavFilter.value != 'Semua Resep') {
      filtered = filtered
          .where((recipe) => recipe['difficulty'] == selectedFavFilter.value)
          .toList();
    }

    // Filter dari Search Bar
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
