import 'package:flutter/material.dart';
import 'package:meet_app/firebase_services/cloud_firestore_service.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/main.dart';
import 'package:meet_app/models/user_model.dart';

class TimeSelectionPage extends StatefulWidget {
  final UserModel currentUser;
  final String idOnLink;
  final String eventName;
  final String eventTimes;
  final String uniqueDate;

  TimeSelectionPage(
      {@required this.currentUser,
      @required this.idOnLink,
      @required this.eventName,
      @required this.eventTimes,
      @required this.uniqueDate});

  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState(
      this.currentUser,
      this.idOnLink,
      this.eventName,
      this.eventTimes,
      this.uniqueDate);
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  final UserModel user;
  final String idOnLink;
  final String eventName;
  final String eventTimes;
  final String uniqueDate;

  _TimeSelectionPageState(this.user, this.idOnLink, this.eventName,
      this.eventTimes, this.uniqueDate);

  final _firestore = locator<CloudFirestoreService>();
  List<String> selectedTimes = [];
  Color timeColor;
  List<int> changedColors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Selection"),
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
                        Icons.radio_button_checked,
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
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
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
                      title: Text("Event Date"),
                      subtitle: Text(
                        uniqueDateFormatter(uniqueDate)[0],
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
                "Select your available Times :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: GridView.builder(
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.7,
                  crossAxisCount: 4,
                ),
                itemCount: formattedTimes(eventTimes).length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      height: 20,
                      child: Center(
                        child: timeFormatter(formattedTimes(eventTimes)[index]),
                      ),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            color: changedColors.contains(index)
                                ? timeColor
                                : Colors.blue.shade900,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                    ),
                    onTap: () {
                      selectedTimes.add(formattedTimes(eventTimes)[index]);
                      lastFormSelectedTimes(selectedTimes);
                      setState(() {
                        changedColors.add(index);
                        timeColor = Colors.red;
                      });
                    },
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
                child: Center(
                  child: Text(
                    "Confirme",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  await _firestore.saveSelectedTimeInfo(
                      lastFormSelectedTimes(selectedTimes),
                      idOnLink,
                      eventName);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MeetApp(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

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

  List<String> formattedTimes(String eventDates) {
    List<String> first = [];
    String eventDatesWithoutBracked = eventDates.substring(1);
    String eventTimeWithoutEndBracked =
        eventDatesWithoutBracked.replaceAll(']', ' ');
    first = eventTimeWithoutEndBracked.split(',');

    return first;
  }

  Widget timeFormatter(String string) {
    String hour;
    hour = "$string:00";
    return Center(
      child: Text(hour),
    );
  }

  List<String> lastFormSelectedTimes(List<String> selectedTimes) {
    for (int i = 0; i < selectedTimes.length; i++) {
      if (selectedTimes[i].contains(' ')) {
        selectedTimes[i] = selectedTimes[i].replaceAll(' ', '');
      }
      debugPrint("LİST***************** :" + selectedTimes.toString());
    }
    return selectedTimes;
  }
}
