import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meet_app/models/user_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FirebaseAuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> getCurrentUser() async {
    try {
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      return convertUserModel(currentUser);
    } catch (e) {
      debugPrint("HATA CURRENT USER FIREBASE AUTHSERVICE:" + e.toString());
      return null;
    }
  }

  Future<UserModel> getSignInAnonimously() async {
    try {
      AuthResult authAnonimous = await _firebaseAuth.signInAnonymously();
      FirebaseUser anonimousUser = authAnonimous.user;
      debugPrint("ANONİM BAŞARILI FİREBASE ");
      return convertUserModel(anonimousUser);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getSignInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        if (result.accessToken != null) {
          final authResult = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.getCredential(
                  accessToken: result.accessToken.token));
          final user = authResult.user;
          debugPrint("FACEBOOK ENRANCE İS SUCCESSFULL");
          return convertUserModel(user);
        } else {
          debugPrint("ACCESS TOKEN İS NULL");
          return null;
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint("FACEBOOK CANCELLED BY USER");
        return null;
        break;
      case FacebookLoginStatus.error:
        debugPrint("FACEBOOK ENTRANCE ERROR ");
        return null;
        break;
    }
  }

  Future<UserModel> getEmailAndPasswordSignUp(
      String email, String password) async {
    try {
      if (email != null) {
        final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        final mailUser = authResult.user;
        return convertUserModel(mailUser);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getLoginEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint("USER ID :" + email);
      final user = authResult.user;

      return convertUserModel(user);
    } catch (e) {
      return null;
    }
  }

  Future<bool> getSignOut() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint("SİGN OUT BAŞARILI");
      return true;
    } catch (e) {
      debugPrint("ERROR SİGN OUT FİREBASE");
      return false;
    }
  }

  UserModel convertUserModel(FirebaseUser firebaseUser) {
    try {
      if (firebaseUser == null) {
        return null;
      } else {
        UserModel userModel = UserModel(
            userID: firebaseUser.uid, userMailAddress: firebaseUser.email);
        debugPrint("USER ID:" + firebaseUser.uid);
        return userModel;
      }
    } catch (error) {
      debugPrint("CONVERT ERROR :" + error.toString());
      return null;
    }
  }
}
