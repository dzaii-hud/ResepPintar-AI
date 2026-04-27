import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;

  // ID KTP Web Client lu
  final String webClientId =
      '191900858378-juver7eeceqcmilg8lucig584sej06fo.apps.googleusercontent.com';

  Future<void> loginWithGoogle() async {
    try {
      // PAKAI .instance BIAR KAGA MERAH LAGI
      // Ini cara paling sakti di versi terbaru
      final googleSignIn = GoogleSignIn.instance;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      userName.value = googleUser.displayName ?? 'User';
      userEmail.value = googleUser.email;
      userPhoto.value = googleUser.photoUrl ?? '';
      isLoggedIn.value = true;

      print('MANTAP! Login sukses: ${userName.value}');
      Get.offAllNamed('/home');
    } catch (error) {
      print('Gagal login bre: $error');
    }
  }

  void logout() async {
    await GoogleSignIn.instance.signOut();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
