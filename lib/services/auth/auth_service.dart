import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_ui/services/auth/auth_user.dart';
import 'package:login_ui/services/auth/auth_provider.dart';
import 'dart:developer' as devtools show log;

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}

class AuthService2 {
  signINWtihGoogle(context) async {
    devtools.log("signINWtihGoogle");

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError((onError) {
      return onError;
    });
  }
}

