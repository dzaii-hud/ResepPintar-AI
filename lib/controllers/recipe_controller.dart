import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeController extends GetxController {
  var recipes = [].obs;
  var isLoading = true.obs;

  // Variabel buat nyimpen status filter yang lagi aktif
  var selectedHomeFilter = 'Semua'.obs;
  var selectedFavFilter = 'Semua Resep'.obs;

  @override
  void onInit() {
    fetchRecipes();
    super.onInit();
  }

  void fetchRecipes() async {
    try {
      isLoading(true);
      // Pastikan IP masih IP kosan lu
      var response = await http.get(
        Uri.parse('http://192.168.1.9:8000/api/recipes'),
      );

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);

        // --- LOGIKA PENANGKAP SUPER KEBAL ---
        if (decodedData is List) {
          // Kalau bentuknya List murni
          recipes.value = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          // Kalau kebungkus di dalam objek "data"
          recipes.value = decodedData['data'];
        } else {
          // Kalau aneh, masukin aja ke array kosong biar ga crash
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

  // --- LOGIKA FILTER HOME (Berdasarkan Waktu Makan) ---
  List get filteredHomeRecipes {
    if (selectedHomeFilter.value == 'Semua') return recipes;
    return recipes
        .where((recipe) => recipe['meal_time'] == selectedHomeFilter.value)
        .toList();
  }

  // --- LOGIKA FILTER FAVORITES (Berdasarkan Kesulitan) ---
  List get filteredFavRecipes {
    if (selectedFavFilter.value == 'Semua Resep') return recipes;
    return recipes
        .where((recipe) => recipe['difficulty'] == selectedFavFilter.value)
        .toList();
  }

  // --- LOGIKA TOP REKOMENDASI (Nasi Goreng) ---
  Map<String, dynamic>? get topRecommendation {
    if (recipes.isEmpty) return null;
    // Otomatis nyari resep Nasi Goreng buat ditaruh di paling atas
    return recipes.firstWhere(
      (recipe) => recipe['title'] == 'Nasi Goreng',
      orElse: () => recipes.first,
    );
  }
}
