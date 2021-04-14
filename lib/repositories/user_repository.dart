import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_app/firebase_services/cloud_firestore_service.dart';
import 'package:meet_app/firebase_services/dynamic_link_service.dart';
import 'package:meet_app/firebase_services/firebase_auth_service.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/models/date_time_info.dart';
import 'package:meet_app/models/user_model.dart';

class UserRepository {
  ///////////////////// FİREBASE AUTHENTİCATİON SERVİCE ////////////////////
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  Future<UserModel> getCurrentUser() async {
    try {
      UserModel curentUser = await _firebaseAuthService.getCurrentUser();
      if (curentUser == null) {
        return null;
      } else {
        return curentUser;
      }
    } catch (e) {
      debugPrint("USER REPOSITORY | gerCurrentUser HATA: " + e.toString());
      return null;
    }
  }

  Future<UserModel> getSignInAnonimously() async {
    try {
      UserModel anonimousUser =
          await _firebaseAuthService.getSignInAnonimously();
      return anonimousUser;
    } catch (e) {
      debugPrint(
          "USER REPOSITORY | getSignInAnonimously HATA: " + e.toString());
      return null;
    }
  }

  Future<UserModel> getSignInWithFacebook() async {
    try {
      final facebookUser = await _firebaseAuthService.getSignInWithFacebook();
      return facebookUser;
    } catch (e) {
      debugPrint("USER REPOSITORY | getSignInWithFacebook HATA: $e");
      return null;
    }
  }

  Future<UserModel> getSignUpVieEmail(String email, String password) async {
    try {
      if (email != null) {
        final emailUser = await _firebaseAuthService.getEmailAndPasswordSignUp(
            email, password);
        return emailUser;
      } else {
        debugPrint("USER REPOSITORY | getSignUpViaEmail HATA");
        return null;
      }
    } catch (e) {
      debugPrint("USER REPOSITORY | getSignUpViaEmail HATA: $e");
      return null;
    }
  }

  Future<UserModel> getLoginVieEmail(String email, String password) async {
    try {
      final user =
          await _firebaseAuthService.getLoginEmailAndPassword(email, password);
      debugPrint("USER REPOSITORY | USER ID:" + user.userID.toString());
      return user;
    } catch (e) {
      debugPrint("USER REPOSITORY | getLoginViaEmail HATA: $e");
      return null;
    }
  }

  Future<bool> getSignOut() async {
    try {
      await _firebaseAuthService.getSignOut();
      return true;
    } catch (e) {
      debugPrint("USER REPOSITORY | getSigOut HATA: $e");
      return false;
    }
  }

  ////////////////////// FİREBASE FİRESTORE SERVİCE //////////////////
  final _firestoreService = locator<CloudFirestoreService>();

/////// save user to firestore
  Future<bool> getRegisterUser(UserModel user) async {
    try {
      await _firestoreService.registerUser(user);
      return true;
    } catch (e) {
      debugPrint("USER REPOSITORY | getRegisterUser HATA: $e");
      return false;
    }
  }

  Future<bool> getSaveTimeInfo(
      DateTimeInfo dateTimeInfo, UserModel user) async {
    try {
      await _firestoreService.saveTimeInfo(dateTimeInfo, user);
      return true;
    } catch (e) {
      debugPrint("USER REPOSITORY | getSaveTimeInfo HATA: $e");
      return false;
    }
  }

  Future<bool> getSaveDateInfo(
      DateTimeInfo dateTimeInfo, UserModel user) async {
    try {
      await _firestoreService.saveDateInfo(dateTimeInfo, user);
      return true;
    } catch (e) {
      debugPrint("USER REPOSITORY | getSaveDateInfo HATA: $e");
      return false;
    }
  }

///////////// written to list date info and time info
  ///at the created meetings at the same time
  Future<List<DateTimeInfo>> getDateTimeInfo(UserModel user) async {
    List<DateTimeInfo> dateTimeList = [];
    try {
      final timeList = await _firestoreService.getTimeInfo(user);
      final dateList = await _firestoreService.getDateInfo(user);
      for (int i = 0; i < (timeList.length); i++) {
        dateTimeList.add(timeList[i]);
      }
      for (int i = 0; i < (dateList.length); i++) {
        dateTimeList.add(dateList[i]);
      }
      return dateTimeList;
    } catch (e) {
      debugPrint("USER REPOSITORY | getDateTimeInfo HATA: $e");
      return [];
    }
  }

///////////// IT IS NOT USED NOW /////////////
  Future<List<DateTimeInfo>> getTimeInfo(UserModel user) async {
    try {
      final timeList = await _firestoreService.getTimeInfo(user);
      return timeList;
    } catch (e) {
      debugPrint("USER REPOSITORY | getTimeInfo HATA: $e");
      return [];
    }
  }

///////////// IT IS NOT USED NOW /////////////
  Future<List<DateTimeInfo>> getDateInfo(UserModel user) async {
    try {
      final dateList = await _firestoreService.getDateInfo(user);
      return dateList;
    } catch (e) {
      debugPrint("USER REPOSITORY | getDateInfo HATA: $e");
      return [];
    }
  }

  /////////////////////// FIREBASE DYNAMIC LINK SERVICE /////////////////////
  final _dynamicLinkService = locator<DynamicLinkService>();

//////// This is written to create URL for DATE page (dynamic link)
  Future<Uri> createUriForDate(UserModel user, DateTimeInfo dateTime) async {
    try {
      final Uri url = await _dynamicLinkService
          .createDynamicLinkParameterForDate(user, dateTime);
      return url;
    } catch (e) {
      debugPrint("USER REPOSITORY | createUriForDate HATA: $e");
      return null;
    }
  }

/////////// This is written to create URL for TIME page (dynamic link)
  Future<Uri> createUriForTime(UserModel user, DateTimeInfo dateTime) async {
    try {
      final Uri url = await _dynamicLinkService
          .createDynamicLinkParameterForTime(user, dateTime);
      return url;
    } catch (e) {
      debugPrint("USER REPOSITORY | createUriForTime HATA: $e");
      return null;
    }
  }

////////// This is written to handle dynamic link
  Future<bool> handleDynamicLinksBackgroundMode(
      BuildContext context, UserModel user) async {
    try {
      await _dynamicLinkService.handleDynamicLinksWhenAppIsAtBackground(
          context, user);
      return true;
    } catch (e) {
      debugPrint("USER REPOSITORY | handleDynamicLinksBackgroundMode HATA: $e");
      return false;
    }
  }
}

////////// This is written to create incoming meetings page
///
/* Future<List<DateTimeInfo>> getDateTimeInfoToUserDB(UserModel user) async {
    List<DateTimeInfo> dateTimeList = [];
    try {
      final timeList = await _firestoreService.getTimeInfo(user);
      final dateList = await _firestoreService.getDateInfo(user);
      debugPrint("LİSTEYE ATAMA İŞLEMİ BAŞARILI REPO");
      for (int i = 0; i < (timeList.length); i++) {
        dateTimeList.add(timeList[i]);
      }
      for (int i = 0; i < (dateList.length); i++) {
        dateTimeList.add(dateList[i]);
      }
      return dateTimeList;
    } catch (e) {
      debugPrint("LİSTEYE ATAMA HATA ALINDI " + e.toString());
      return [];
    }
  } */
