import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/firebase_services/cloud_firestore_service.dart';
import 'package:meet_app/locator.dart';

class ResultTime extends StatelessWidget {
  final String eventName;
  final String moderatorID;
  final List eventTimes;
  final DateTime eventUniqueDate;
  ResultTime({
    @required this.eventTimes,
    @required this.moderatorID,
    @required this.eventName,
    @required this.eventUniqueDate,
  });
  @override
  Widget build(BuildContext context) {
    final _firestore = locator<CloudFirestoreService>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Result Time"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _firestore.getSelectedTimeInfo(moderatorID, eventName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List selectedTimeList = snapshot.data;

              debugPrint("selectedtime :" + selectedTimeList.toString());

              ranking(selectedTimeList);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8, left: 8, top: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.blue.shade900, width: 5),
                        ),
                        child: Card(
                          color: Colors.blue.shade100,
                          child: ListTile(
                            leading: Icon(
                              Icons.people,
                              size: 30,
                              color: Colors.blue.shade900,
                            ),
                            title: Text(
                              "Number of Participants",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic),
                            ),
                            subtitle: Text(
                              selectedTimeList.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 320,
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 8, right: 8),
                      child: ListView.builder(
                        itemCount: eventTimes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 8,
                            color: Colors.blue.shade100,
                            child: ListTile(
                              leading: Icon(
                                Icons.check_circle_outline,
                                color: Colors.blue.shade900,
                                size: 40,
                              ),
                              title: Text(
                                rankedAndSortedMap(ranking(selectedTimeList))
                                    .keys
                                    .toList()[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "Number of Voters: ${rankedAndSortedMap(ranking(selectedTimeList)).values.toList()[index]}"),
                              /*  trailing: Icon(
                                Icons.help_outline,
                                color: Colors.blue.shade900,
                              ), */
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Back to Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  List<String> formattedUniqueDate(String eventDates) {
    List<String> first = [];
    first = eventDates.split(' ');
    List<String> second = [];
    for (int i = 0; i < first.length; i++) {
      if (i % 2 == 0) {
        second.add(first[i]);
      }
    }
    return second;
  }

  Map ranking(List<List> selectedDateList) {
    Map<String, int> dateRanks = Map();
    int sayac = 0;
    for (int i = 0; i < eventTimes.length; i++) {
      if (selectedDateList.length != 0) {
        for (int j = 0; j < selectedDateList.length; j++) {
          if (selectedDateList[j].length != 0) {
            for (int k = 0; k < selectedDateList[j].length; k++) {
              if (eventTimes[i].toString() == selectedDateList[j][k]) {
                dateRanks["${eventTimes[i].toString()}"] = ++sayac;
              } else {
                dateRanks["${eventTimes[i].toString()}"] = sayac;
              }
            }
          } else {
            dateRanks["${eventTimes[i].toString()}"] = sayac;
          }
        }
      } else {
        dateRanks["${eventTimes[i].toString()}"] = sayac;
      }
      sayac = 0;
    }
    /* dateRanks.forEach((key, value) {
      debugPrint("Date: $key value: $value");
    }); */
    return dateRanks;
  }

  String timeSelector(String string) {
    String hour;
    hour = "Appointment Time: $string:00";
    return hour;
  }

  Map rankedAndSortedMap(Map rankedMap) {
    Map rankedAndSortedMap = Map();
    int max = -1;
    for (int j = 0; j < eventTimes.length; j++) {
      for (int i = 0; i < rankedMap.values.toList().length; i++) {
        if (rankedMap.values.toList()[i] > max) {
          max = rankedMap.values.toList()[i];
        }
      }
      for (int k = 0; k < rankedMap.values.toList().length; k++) {
        if (rankedMap.values.toList()[k] == max) {
          rankedAndSortedMap['${timeSelector(rankedMap.keys.toList()[k])}'] =
              max;
          rankedMap.remove(rankedMap.keys.toList()[k]);
        }
      }
      max = -1;
    }
    return rankedAndSortedMap;
  }
}
