import 'package:flutter/foundation.dart';

class UserModel {
  final String userID;
  final String userMailAddress;

  UserModel({@required this.userID, this.userMailAddress});

  Map<String, dynamic> userMap() {
    return {
      "UserID": userID ?? "",
      "UserMailAddress": userMailAddress ?? "",
    };
  }
}
