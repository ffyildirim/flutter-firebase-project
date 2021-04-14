class DateTimeInfo {
  List timeList;
  List dateList;
  String stringDate;
  DateTime date;
  String eventName;

  DateTimeInfo(this.timeList, this.stringDate, this.eventName);

  DateTimeInfo.timeConst(this.timeList, this.date, this.eventName);

  DateTimeInfo.dateConst(this.dateList, this.eventName);

  DateTimeInfo.fromMapTime(Map<String, dynamic> map)
      : eventName = map['EventName'],
        timeList = map['TimeList'],
        stringDate = map['Date'];

  DateTimeInfo.fromMapDate(Map<String, dynamic> map)
      : eventName = map['EventName'],
        dateList = map['DateList'];

  Map<String, dynamic> myMapTime() {
    return {
      "EventName": eventName,
      "TimeList": timeList,
      "Date": date.toString(),
    };
  }

  Map<String, dynamic> myMapDate() {
    return {
      "EventName": eventName,
      "DateList": dateList,
    };
  }
}
