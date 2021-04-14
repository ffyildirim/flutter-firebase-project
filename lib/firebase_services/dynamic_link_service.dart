import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meet_app/UI/selection_date_page.dart';
import 'package:meet_app/UI/selection_time_page.dart';
import 'package:meet_app/models/date_time_info.dart';
import 'package:meet_app/models/user_model.dart';

class DynamicLinkService {
  ///////// Create URL for DATE
  Future<Uri> createDynamicLinkParameterForDate(
      UserModel user, DateTimeInfo dateTime) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://calendarconnection.page.link',
        link: Uri.parse(
            'https://calendarconnection.page.link/?id=${user.userID}&eventName=${dateTime.eventName}&eventDates=${dateTime.dateList}'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.meet_app',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
      );
      final ShortDynamicLink dynamicLink = await parameters.buildShortLink();
      Uri url = dynamicLink.shortUrl;
      return url;
    } catch (e) {
      debugPrint(
          "DYNAMIC LINK SERVICE | createDynamicLinkParameterForDate HATA :$e");
      return null;
    }
  }

///////// Create URL for TIME
  Future<Uri> createDynamicLinkParameterForTime(
      UserModel user, DateTimeInfo dateTime) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://calendarconnection.page.link',
        link: Uri.parse(
            'https://calendarconnection.page.link/?id=${user.userID}&eventName=${dateTime.eventName}&eventTimes=${dateTime.timeList}&uniqueDate=${dateTime.date}'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.meet_app',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
      );
      final ShortDynamicLink dynamicLink = await parameters.buildShortLink();
      Uri url = dynamicLink.shortUrl;
      return url;
    } catch (e) {
      debugPrint(
          "DYNAMIC LINK SERVICE | createDynamicLinkParameterForTime HATA :$e");
      return null;
    }
  }

  Future<bool> handleDynamicLinksWhenAppIsAtBackground(
      BuildContext context, UserModel user) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        _handleDeepLink(context, dynamicLink, user);
        return true;
      }, onError: (OnLinkErrorException e) async {
        debugPrint(
            "FIREBASE DYNAMIC LINK |  handleDynamicLinksWhenAppIsAtBackground | onError HATA: $e");
      });
    } catch (e) {
      print(
          "DYNAMIC LINK SERVICE |  handleDynamicLinksWhenAppIsAtBackground | catch HATA: $e" +
              e.toString());
    }
    return false;
  }

  void _handleDeepLink(BuildContext context2, PendingDynamicLinkData data,
      UserModel user) async {
    try {
      Uri deepLink = data?.link;
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id') &&
            deepLink.queryParameters.containsKey('eventName') &&
            deepLink.queryParameters.containsKey('eventDates')) {
          String id = deepLink.queryParameters['id'];
          String eventName = deepLink.queryParameters['eventName'];
          String eventDates = deepLink.queryParameters['eventDates'];
          debugPrint("_handleDeepLink | deepLink FOR DATE: $deepLink");
          debugPrint("***********************DeepLink ID :$id");
          debugPrint("***********************DeepLink EVENT NAME :$eventName");
          debugPrint(
              "***********************DeepLink EVENT DATES :$eventDates");
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context2).pushReplacement(MaterialPageRoute(
              builder: (context) => Deneme(
                  currentUser: user,
                  moderatorID: id,
                  eventName: eventName,
                  eventDates: eventDates),
            ));
          });
        }
        if (deepLink.queryParameters.containsKey('id') &&
            deepLink.queryParameters.containsKey('eventName') &&
            deepLink.queryParameters.containsKey('eventTimes') &&
            deepLink.queryParameters.containsKey('uniqueDate')) {
          String id = deepLink.queryParameters['id'];
          String eventName = deepLink.queryParameters['eventName'];
          String eventTimes = deepLink.queryParameters['eventTimes'];
          String uniqueDate = deepLink.queryParameters['uniqueDate'];
          debugPrint("_handleDeepLink | deepLink FOR TIME: $deepLink");
          debugPrint("***********************DeepLink ID :$id");
          debugPrint("***********************DeepLink EVENT NAME :$eventName");
          debugPrint(
              "***********************DeepLink EVENT Times :$eventTimes");
          debugPrint(
              "***********************DeepLink EVENT Unique DATES :$uniqueDate");
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context2).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TimeSelectionPage(
                  currentUser: user,
                  idOnLink: id,
                  eventName: eventName,
                  eventTimes: eventTimes,
                  uniqueDate: uniqueDate,
                ),
              ),
            );
          });
        }
        debugPrint("DEEPLINK _HANDLE SUCCESS: $deepLink");
      } else {
        debugPrint(
            "DYNAMIC LINK SERVICE | _handleDeepLink HATA: DEEPLİNK İS NULL ");
      }
    } catch (e) {
      debugPrint("DYNAMIC LINK SERVICE | _handleDeepLinks HATA: $e");
    }
  }
}
