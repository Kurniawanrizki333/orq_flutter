import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  GoogleAuth._();

  static final Future<void> _initialization = GoogleSignIn.instance.initialize();

  static bool get isConfigured => true;

  static Future<String> idToken() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    await _initialization;
    final account = await GoogleSignIn.instance.authenticate();
    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await user.user?.getIdToken();
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }
    return idToken;
  }
}
