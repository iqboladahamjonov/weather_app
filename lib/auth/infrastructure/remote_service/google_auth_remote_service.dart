import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weather_app/auth/domain/auth_failure.dart';
import 'package:weather_app/core/infrastucture/exceptions.dart';

class GoogleAuthRemoteService {
  GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthRemoteService(this._firebaseAuth, this._googleSignIn);

  Future<UserCredential> login() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      _firebaseAuth.authStateChanges();
      _firebaseAuth.authStateChanges();
      return await _firebaseAuth.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      throw AuthException();
    } catch (e) {
      throw UnknownExeption();
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
