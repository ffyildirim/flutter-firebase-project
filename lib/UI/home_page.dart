import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_app/UI/create_meet_date.dart';
import 'package:meet_app/UI/result_date_page.dart';
import 'package:meet_app/UI/result_time_page.dart';
import 'package:meet_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/models/date_time_info.dart';
import 'package:meet_app/models/user_model.dart';
import 'package:meet_app/repositories/user_repository.dart';

class StartingPage extends StatefulWidget {
  final UserModel userID;

  StartingPage(this.userID);

  @override
  _StartingPageState createState() => _StartingPageState(this.userID);
}

class _StartingPageState extends State<StartingPage>
    with SingleTickerProviderStateMixin {
  final UserModel userID;

  _StartingPageState(this.userID);

  TabController controller;
  final _userRepository = locator<UserRepository>();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.red),
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Created Meetings",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Incoming Meetings",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "sign out",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
                debugPrint("SİGNOUT BUTON ÇALIŞTI");
              },
            )
          ],
          title: Text("My Profile"),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FutureBuilder(
                future: _userRepository.getDateTimeInfo(userID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DateTimeInfo> myList = snapshot.data;
                    return ListView.builder(
                      itemCount: myList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                          child: GestureDetector(
                            child: Card(
                              color: Colors.grey.shade100,
                              elevation: 8,
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.done),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 8, bottom: 8),
                                title: Text(
                                  "Event Name: " + myList[index].eventName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Meeting ${index + 1}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Show details...")
                                  ],
                                ),
                              ),
                            ),
/////////////////////////GESTURE DETECTOR ON TAP (EVENT DETAILS)/////////////////////////////
                            onTap: () {
/////////////////////////////// TIME PART ////////////////////////////
                              if (myList[index].timeList != null) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 8,
                                      title: Text(
                                        "Event Details",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      content: Text(
                                        "Event Date: \n${uniqueDateFormatter(myList[index].stringDate)[0]}\n\nPossible Times: \n${timeListFormatter(myList[index].timeList)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 20, bottom: 10),
                                          child: ButtonBar(
                                            children: [
                                              FlatButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              RaisedButton(
                                                color: Colors.red,
                                                child: Text("Show Result"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultTime(
                                                      eventUniqueDate:
                                                          myList[index].date,
                                                      eventTimes: myList[index]
                                                          .timeList,
                                                      moderatorID:
                                                          userID.userID,
                                                      eventName: myList[index]
                                                          .eventName,
                                                    ),
                                                  ));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
////////////////////////////// DATE PART //////////////////////////////////////
                              if (myList[index].dateList != null) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 8,
                                      title: Text(
                                        "Event Details",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      content: Text(
                                        "Possible Dates: \n${dateListFormatter(myList[index].dateList)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 20, bottom: 10),
                                          child: ButtonBar(
                                            children: [
                                              FlatButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              RaisedButton(
                                                color: Colors.red,
                                                child: Text("Show Result"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultPage(
                                                      eventDates: myList[index]
                                                          .dateList,
                                                      moderatorID:
                                                          userID.userID,
                                                      eventName: myList[index]
                                                          .eventName,
                                                    ),
                                                  ));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            /////////////////// INCOMING MEETINGS PAGE////////////////////
            Container()
          ],
        ),
        /////////////// CREATE NEW EVENT BUTTON ///////////////////
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateMeetDate(),
              ),
            );
          },
          child: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

////////////// one string date formatter //////////////////
  List<String> uniqueDateFormatter(String eventDates) {
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

//////// This is written to convert a time list to the string time
  ///[15, 07, 12] => 15:00, 07:00, 12:00
  String timeListFormatter(List<dynamic> timeList) {
    List<String> stringTimeList = [];
    String hourForm;
    for (int i = 0; i < timeList.length; i++) {
      if (timeList[i] < 10) {
        hourForm = "0${timeList[i].toString()}:00";
      } else {
        hourForm = "${timeList[i].toString()}:00";
      }
      stringTimeList.add(hourForm);
    }
    String stringTime = stringTimeList.toString();
    String stringTimeWithoutStartBracked = stringTime.replaceAll('[', '');
    String stringTimeWithoutEndBracked =
        stringTimeWithoutStartBracked.replaceAll(']', '');

    return stringTimeWithoutEndBracked;
  }

//////// This is written to convert a date list to the string date
  ///[12-07-20, 15-08-20] => 12-07-20, 15-08-20
  String dateListFormatter(List dateList) {
    List<String> dateListSpilited = [];
    for (int i = 0; i < dateList.length; i++) {
      Timestamp dateListTimestamp = dateList[i];
      DateTime dateListDateTime = dateListTimestamp.toDate();
      List<String> spilited = dateListDateTime.toString().split(' ');
      dateListSpilited.add(spilited[0]);
    }
    String dateListString = dateListSpilited.toString();
    String dateListStringWithoutStartAndEndBracked =
        dateListString.replaceAll('[', '').replaceAll(']', '');
    return dateListStringWithoutStartAndEndBracked;
  }
}

/////////////// INCOMING MEETINGS PAGE ///////////////////////
/*  List<Map<String, dynamic>> incomingEventHolder(
      String eventName, String eventDates, List selectedDates) {
    List<Map<String, dynamic>> eventHolderList = [];

    eventHolderList.add({
      'Event Name': eventName,
      'Event Dates': eventDates,
      'Selected Dates': selectedDates
    });
    return eventHolderList;
  } */
