// File: lib/controllers/main_controller.dart
import 'package:get/get.dart';

class MainController extends GetxController {
  // .obs (observable) adalah ilmu sakti GetX. 
  // Kalau nilai ini berubah, layarnya otomatis ikut berubah tanpa perlu kita refresh!
  var selectedIndex = 0.obs; 

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}