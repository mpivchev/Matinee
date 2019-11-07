import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> logInEmail(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user;
  }

  Future<FirebaseUser> registerEmail(String email, String password) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user;
  }

  Future<FirebaseUser> logInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

//    final user = await _firebaseAuth.signInWithGoogle(
//        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//    return user;
  }

  Future<FirebaseUser> getUser() async {
    final user = await _firebaseAuth.currentUser();

    return user;
  }
}
