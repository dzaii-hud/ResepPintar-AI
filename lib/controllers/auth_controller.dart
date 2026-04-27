import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var userName = 'Guest'.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Di versi 7 ke atas, WAJIB dipanasin dulu mesinnya pas awal
    _initGoogle();
  }

  Future<void> _initGoogle() async {
    await GoogleSignIn.instance.initialize();
  }

  Future<void> loginWithGoogle() async {
    try {
      // Namanya sekarang ganti jadi authenticate(), bukan signIn() lagi
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

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
