import 'package:flutter/material.dart';
import 'package:meet_app/firebase_services/cloud_firestore_service.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/main.dart';
import 'package:meet_app/models/user_model.dart';

class Deneme extends StatefulWidget {
  final UserModel currentUser;
  final String moderatorID;
  final String eventName;
  final String eventDates;

  const Deneme(
      {@required this.currentUser,
      @required this.moderatorID,
      @required this.eventName,
      @required this.eventDates});
  @override
  _DenemeState createState() => _DenemeState(
      this.currentUser, this.moderatorID, this.eventName, this.eventDates);
}

class _DenemeState extends State<Deneme> {
  final UserModel user;
  final String moderatorID;
  final String eventName;
  final String eventDates;

  _DenemeState(this.user, this.moderatorID, this.eventName, this.eventDates);

  List<String> selectedDates = [];
  Color timeColor;
  List<int> changedColors = [];
  final _firestore = locator<CloudFirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date Selectiion"),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 20, right: 8, left: 8),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.blue.shade900),
                      borderRadius: BorderRadius.circular(8)),
                  child: Card(
                    color: Colors.blue.shade100,
                    child: ListTile(
                      leading: Icon(
                        Icons.event_available,
                        size: 40,
                        color: Colors.blue.shade900,
                      ),
                      title: Text("Event Name"),
                      subtitle: Text(
                        eventName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Text(
                "Select your available dates :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              height: 285,
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
              child: ListView.builder(
                itemCount: formattedDates(eventDates).length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    color: changedColors.contains(index)
                        ? timeColor
                        : Colors.blue.shade100,
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue.shade900,
                        size: 30,
                      ),
                      title: Text(
                        formattedDates(eventDates)[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        selectedDates.add(formattedDates(eventDates)[index]);
                        setState(() {
                          changedColors.add(index);
                          timeColor = Colors.blue.shade300;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: RaisedButton(
                color: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                onPressed: () async {
                  await _firestore.saveSelectedDateInfo(
                      selectedDates, moderatorID, eventName);
                  /*  await _firestore.saveSelectedDateInfoToUserDB(
                      selectedDates, user.userID, eventName, eventDates); */
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MeetApp(),
                  ));
                },
                child: Center(
                  child: Text(
                    "Confirme",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> formattedDates(String eventDates) {
    List<String> first = [];
    String eventDatesWithoutBracked = eventDates.substring(1);
    first = eventDatesWithoutBracked.split(' ');
    List<String> second = [];
    for (int i = 0; i < first.length; i++) {
      if (i % 2 == 0) {
        second.add(first[i]);
      }
    }
    return second;
  }
}
