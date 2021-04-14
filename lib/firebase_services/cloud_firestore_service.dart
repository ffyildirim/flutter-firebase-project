import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meet_app/models/date_time_info.dart';
import 'package:meet_app/models/moderator_user.dart';
import 'package:meet_app/models/user_model.dart';

class CloudFirestoreService {
  final _firestoreService = Firestore.instance;

  Future<bool> registerUser(UserModel user) async {
    try {
      await _firestoreService
          .collection("users")
          .document(user.userID)
          .setData(user.userMap(), merge: true);

      return true;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | registerUser HATA: $e");
      return false;
    }
  }

  Future<bool> saveTimeInfo(DateTimeInfo dateTimeInfo, UserModel user) async {
    try {
      await _firestoreService
          .collection("users")
          .document(user.userID)
          .collection("time_data")
          .add(dateTimeInfo.myMapTime());
      return true;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | saveTimeInfo HATA: $e");
      return false;
    }
  }

  Future<bool> saveDateInfo(DateTimeInfo dateTimeInfo, UserModel user) async {
    try {
      await _firestoreService
          .collection("users")
          .document(user.userID)
          .collection("date_data")
          .add(dateTimeInfo.myMapDate());
      return true;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | saveDateInfo HATA: $e");
      return false;
    }
  }

////// Save selected date info to firestore at date_selection_page
  ///
  Future<bool> saveSelectedDateInfo(List<String> selectedDatesList,
      String moderatorID, String eventName) async {
    try {
      await _firestoreService
          .collection("users")
          .document(moderatorID)
          .collection(eventName)
          .add({"selectedDates": selectedDatesList});
      return true;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | saveSelectedDateInfo HATA: $e");
      return false;
    }
  }

/////////////// Save selected date info to firestore at time_selection_page
  ///
  Future<bool> saveSelectedTimeInfo(List<String> selectedDatesList,
      String moderatorID, String eventName) async {
    try {
      await _firestoreService
          .collection("users")
          .document(moderatorID)
          .collection(eventName)
          .add({"selectedTimes": selectedDatesList});
      return true;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | saveSelectedTimeInfo HATA: $e");
      return false;
    }
  }

/////// get selected date info at result_date_page
  ///
  Future<List<List>> getSelectedDateInfo(
      String moderatorID, String eventName) async {
    try {
      final querySnapshot = await _firestoreService
          .collection("users")
          .document(moderatorID)
          .collection(eventName)
          .getDocuments();

      List<List> selectedDatesList = [];

      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        ModeratorUser moderatorUser =
            ModeratorUser.fromMapSelectedDates(documentSnapshot.data);
        selectedDatesList.add(moderatorUser.selectedEventDates);
      }
      return selectedDatesList;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | getSelectedDateInfo HATA: $e");
      return [];
    }
  }

/////// get selected date info at result_time_page
  ///
  Future<List<List>> getSelectedTimeInfo(
      String moderatorID, String eventName) async {
    try {
      final querySnapshot = await _firestoreService
          .collection("users")
          .document(moderatorID)
          .collection(eventName)
          .getDocuments();

      List<List> selectedDatesList = [];

      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        ModeratorUser moderatorUser =
            ModeratorUser.fromMapSelectedTimes(documentSnapshot.data);
        selectedDatesList.add(moderatorUser.selectedEventTimes);
      }
      return selectedDatesList;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | getSelectedTimeInfo HATA: $e");
      return [];
    }
  }

  Future<List<DateTimeInfo>> getTimeInfo(UserModel user) async {
    try {
      final querySnapshot = await _firestoreService
          .collection("users")
          .document(user.userID)
          .collection("time_data")
          .getDocuments();
      List<DateTimeInfo> infoList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        DateTimeInfo info = DateTimeInfo.fromMapTime(documentSnapshot.data);

        infoList.add(info);
      }
      return infoList;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | getTimeInfo HATA: $e");
      return [];
    }
  }

  Future<List<DateTimeInfo>> getDateInfo(UserModel user) async {
    try {
      final querySnapshot = await _firestoreService
          .collection("users")
          .document(user.userID)
          .collection("date_data")
          .getDocuments();
      List<DateTimeInfo> infoList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        DateTimeInfo info = DateTimeInfo.fromMapDate(documentSnapshot.data);

        infoList.add(info);
      }
      return infoList;
    } catch (e) {
      debugPrint("CLOUD FİRESTORE | getDateInfo HATA: $e");
      return [];
    }
  }
}

/////// FOR INCOMING MEETINGS /////////////////////
///
///
/*   Future<bool> saveSelectedDateInfoToUserDB(List<String> selectedDatesList,
      String userID, String eventName, String eventDates) async {
    try {
      await _firestoreService
          .collection("users")
          .document(userID)
          .collection("incomingMeetings")
          .add({
        "selectedDates": selectedDatesList,
        "eventName": eventName,
        "eventDates": eventDates
      });

      debugPrint("SAVİNG DATE TIME DATA IS SUCCESSFULL");

      return true;
    } catch (e) {
      debugPrint("FİRESTORE HATASI DATE TIME SAVİNG");
      return false;
    }
  }
 */
/* Future<List<List>> getSelectedDateInfoFromUserDB(
      String userID, String eventName) async {
    try {
      final querySnapshot = await _firestoreService
          .collection("users")
          .document(userID)
          .collection("incomingMeeting")
          .getDocuments();

      List<List> selectedDatesList = [];

      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        debugPrint("DOCUMENT SNAPSHOT" + documentSnapshot.data.toString());
        debugPrint("DOCUMENT SNAPSHOT DATA VALUES :" +
            documentSnapshot.data.values.toString());
        //selectedDatesList.add(documentSnapshot.data.values);
        ModeratorUser moderatorUser =
            ModeratorUser.fromMapSelectedDates(documentSnapshot.data);
        selectedDatesList.add(moderatorUser.selectedEventDates);
      }
      return selectedDatesList;
    } catch (e) {
      debugPrint("FİRESTORE HATASI DATE TIME SAVİNG");
      return [];
    }
  }
 */
/* Future<bool> saveSelectedTimeInfoToUserDB(
      List<String> selectedDatesList,
      String userID,
      String eventName,
      String uniqueDate,
      String eventTimes) async {
    try {
      await _firestoreService
          .collection("users")
          .document(userID)
          .collection('incomingMeetings')
          .add({
        "selectedTimes": selectedDatesList,
        "eventName": eventName,
        "uniqueDate": uniqueDate,
        "eventTimes": eventTimes
      });
      debugPrint("SAVİNG DATE TIME DATA IS SUCCESSFULL");
      return true;
    } catch (e) {
      debugPrint("FİRESTORE HATASI DATE TIME SAVİNG");
      return false;
    }
  } */
