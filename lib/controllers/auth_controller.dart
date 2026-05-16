import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;

  // ==========================================
  // FITUR EDIT GELAR (BARU DITAMBAHIN)
  // ==========================================
  var title1 = 'ELITE CHEF'.obs;
  var title2 = 'AI MASTER'.obs;

  final String webClientId =
      '191900858378-juver7eeceqcmilg8lucig584sej06fo.apps.googleusercontent.com';

  @override
  void onInit() {
    super.onInit();
    // ATURAN BARU GOOGLE: Wajib dipanasin dulu mesinnya sebelum ngapa-ngapain
    _initGoogle();
  }

  Future<void> _initGoogle() async {
    // Masukin KTP lu di sini pakai initialize
    await GoogleSignIn.instance.initialize(serverClientId: webClientId);

    // Bagian signInSilently udah dicabut biar kaga error merah!
  }

  Future<void> loginWithGoogle() async {
    try {
      // THE MAGIC WORD: Sekarang pakainya authenticate(), BUKAN signIn() lagi!
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Ambil datanya
      userName.value = googleUser.displayName ?? 'User';
      userEmail.value = googleUser.email;
      userPhoto.value = googleUser.photoUrl ?? '';
      isLoggedIn.value = true;

      print('MANTAP! Login sukses: ${userName.value}');

      // Pindah halaman
      Get.offAllNamed('/home');
    } catch (error) {
      // Kalau user mencet 'back' atau batalin login, bakal masuk ke catch sini
      print('Gagal atau batal login bre: $error');
    }
  }

  void logout() async {
    await GoogleSignIn.instance.signOut();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
