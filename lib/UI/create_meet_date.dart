import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/models/date_time_info.dart';
import 'package:meet_app/models/print_month_year.dart';
import 'package:meet_app/models/user_model.dart';
import 'package:meet_app/repositories/user_repository.dart';
import 'package:share/share.dart';

class CreateMeetDate extends StatefulWidget {
  @override
  _CreateMeetDateState createState() => _CreateMeetDateState();
}

class _CreateMeetDateState extends State<CreateMeetDate>
    with SingleTickerProviderStateMixin {
  final _repository = locator<UserRepository>();
  TabController controller;
  List<int> timeList = [];
  List<DateTime> dateList = [];
  DateTime sentDate;

  final _formKeyTime = GlobalKey<FormState>();
  final _formKeyDate = GlobalKey<FormState>();

  final _controllerTime = TextEditingController();
  final _controllerDate = TextEditingController();

  static int pageDateMonth = DateTime.now().month;
  static int pageDateYear = DateTime.now().year;

  final FocusNode _focusNode = FocusNode();

  DateTimeInfo dateTime;
  DateTimeInfo dateTimeInfoForTime;

  Color timeColor;
  List<int> changedColors = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    timeColor = Colors.blue.shade900;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.date_range),
                  SizedBox(width: 8),
                  Text(
                    "DATE",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.access_time),
                  SizedBox(width: 8),
                  Text(
                    "TIME",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        title: Text("Create Meet Date"),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
// *********************** DATE PART *******************************
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
///////////////////////////// EVENT NAME DATE /////////////////
                  eventNameFormWidget(_formKeyDate, _controllerDate),
//////////////////////////// CALENDERRO //////////////////////
                  Container(
                    height: MediaQuery.of(context).size.height / 1.7,
                    margin: EdgeInsets.only(left: 8, right: 8, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue.shade200,
                      border: Border.all(
                          color: Colors.blue.shade900,
                          width: 5,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            PrintMonthYear.printMontYear(
                                DateTime(pageDateYear, pageDateMonth)),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, bottom: 15, left: 8, right: 8),
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: calendarro(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm The Selected Dates",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.blue.shade900,
                      onPressed: () async {
                        dateTime = DateTimeInfo.dateConst(
                            dateList, _controllerDate.text);
                        final myUser = await _repository.getCurrentUser();
                        final success =
                            await _repository.getSaveDateInfo(dateTime, myUser);
                        if (success) {
                          returnShowDialogForDate();
                        } else {
                          debugPrint("ALERT YOK");
                          ////////[BURAYA HATA MESAJI YAZDIR]
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

// ********************************** TIME PART ******************************
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
////////////////////////////// EVENT NAME TIME///////////////
                  eventNameFormWidget(_formKeyTime, _controllerTime),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 80,
                    child: DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.blue.shade900,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        sentDate = date;
                      },
                    ),
                  ),
                  Container(
                    height: 310,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: GridView.builder(
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.7,
                        crossAxisCount: 4,
                      ),
                      itemCount: 24,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              changedColors.add(index);
                              timeColor = Colors.red;
                            });
                            timeList.add(index);
                          },
                          child: Container(
                            height: 20,
                            child: timeFormatter(index),
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
                      child: Center(
                        child: Text(
                          "Confirm The Selected Hours",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.blue.shade900,
                      onPressed: () async {
                        final dateTime = DateTimeInfo.timeConst(
                            timeList, sentDate, _controllerTime.text);
                        final myUser = await _repository.getCurrentUser();
                        final success =
                            await _repository.getSaveTimeInfo(dateTime, myUser);

                        if (success) {
                          returnShowDialogForTime();
                        } else {
                          debugPrint("ALERT YOK");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeFormatter(int index) {
    String hour;
    if (index < 10) {
      hour = "0$index:00";
    } else {
      hour = "$index:00";
    }
    return Center(
      child: Text(hour),
    );
  }

  Widget eventNameFormWidget(
      GlobalKey<FormState> formKey, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 8, right: 8),
      child: Form(
        key: formKey,
        child: TextFormField(
          textCapitalization: TextCapitalization.characters,
          // autovalidate: true,
          autofocus: false,
          controller: controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade900, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade900, width: 3),
            ),
            prefixIcon: Icon(
              Icons.event,
              color: Colors.blue.shade900,
            ),
            hintText: "Event Name",
            labelText: "Event Name",
            border: OutlineInputBorder(),
            fillColor: Colors.amber,
          ),
          onSaved: (newValue) {
            _focusNode.unfocus();
          },
        ),
      ),
    );
  }

  dynamic returnShowDialogForDate() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "SUCCESS",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          content: Text(
            "Your event date successfully created",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 10),
              child: ButtonBar(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    //elevation: 8,
                    color: Colors.blue,
                    child: Text("Send Invitation"),
                    onPressed: () async {
                      final UserModel user = await _repository.getCurrentUser();
                      final Uri appLink =
                          await _repository.createUriForDate(user, dateTime);
                      try {
                        Share.share(
                            "It's very easy to find the best meeting time!!!\nInstall MeetApp and ask all your friends for their available times at the same time...\n\nIt was sent to ask your available times, click the link: $appLink",
                            subject: 'Look what I made!');
                      } catch (e) {
                        debugPrint("HATA SHARE :" + e.toString());
                      }
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

  dynamic returnShowDialogForTime() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "SUCCESS",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          content: Text(
            "Your event date successfully created",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 10),
              child: ButtonBar(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    //elevation: 8,
                    color: Colors.blue,
                    child: Text("Send Invitation"),
                    onPressed: () async {
                      final UserModel user = await _repository.getCurrentUser();
                      final Uri appLinkTime =
                          await _repository.createUriForTime(user, dateTime);
                      debugPrint("URİ ::::::::::$appLinkTime");
                      try {
                        Share.share(
                            "It's very easy to find the best meeting time!!!\nInstall MeetApp and ask all your friends for their available times at the same time...\n\nIt was sent to ask your available times, click the link: $appLinkTime",
                            subject: 'Look what I made!');
                      } catch (e) {
                        debugPrint("HATA SHARE :" + e.toString());
                      }
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

  Widget calendarro() {
    return Calendarro(
      onPageSelected: (pageStartDate, pageEndDate) {
        setState(() {
          pageDateMonth = pageStartDate.month;
          pageDateYear = pageStartDate.year;
        });
      },
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.MULTI,
      startDate: DateUtils.getFirstDayOfCurrentMonth(),
      endDate: DateUtils.getLastDayOfMonth(DateTime(2021, 9)),
      onTap: (datetime) {
        dateList.add(datetime);
      },
    );
  }
}

/////////// Sürpriz kısmı //////////
/*      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Date: ${formattedUniqueDate(datetime.toString())[0]}\nChoose hours:"),
              content: Container(
                height: 280,
                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                child: GridView.builder(
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.2,
                    crossAxisCount: 4,
                  ),
                  itemCount: 24,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 20,
                        child: Center(
                          child: Text(
                            timeSelectorAlert(index),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: Colors.blue.shade900,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text("Cancel"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 35, bottom: 20),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.blue.shade900,
                    child: Center(
                      child: Text("Okay"),
                    ),
                  ),
                )
              ],
            );
          },
        ); */
