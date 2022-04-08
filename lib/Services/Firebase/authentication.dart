import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../dialogs.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Auth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    notifyListeners();
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw PlatformException(code: "Google Sign in Cancelled");
    }

    final googleAuth = await googleUser.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credentials);
    notifyListeners();
  }

  // Future signInWithFacebook() async {
  //   final fb = FacebookLogin();
  //   final response = await fb.logIn(
  //     permissions: [
  //       FacebookPermission.publicProfile,
  //       FacebookPermission.email,
  //     ],
  //   );
  //   try {
  //     switch (response.status) {
  //       case FacebookLoginStatus.success:
  //         final accessToken = response.accessToken;
  //         final userCredential = await _firebaseAuth.signInWithCredential(
  //           FacebookAuthProvider.credential(accessToken!.token),
  //         );
  //         return userCredential.user;
  //       case FacebookLoginStatus.cancel:
  //         throw FirebaseAuthException(
  //           code: 'ERROR_ABORTED_BY_USER',
  //           message: 'Sign in aborted by user',
  //         );
  //       case FacebookLoginStatus.error:
  //         throw FirebaseAuthException(
  //           code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //           message: response.error?.developerMessage,
  //         );
  //       default:
  //         throw UnimplementedError();
  //     }
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future signInWithFacebook() async{
    final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile', 'user_friends']);
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOut(context) async {
    getWaitingDialog(context: context);
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      // await googleSignIn.signOut();
      // final facebookLogin = FacebookLogin();
      // await facebookLogin.logOut();
    } catch (e){
      _firebaseAuth.currentUser;
    }finally {
      try {
        _firebaseAuth.signOut();
      }
      finally {
        Navigator.pop(context);
      }
    }
  }

  Future resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return true;
  }
}
