class ModeratorUser {
  List selectedEventDates;
  List selectedEventTimes;
  String eventDates;
  String eventName;
  String eventTimes;
  String uniqueDate;

  ModeratorUser(this.selectedEventDates);

  ModeratorUser.fromMapSelectedDates(Map<String, dynamic> map)
      : selectedEventDates = map['selectedDates'];

  ModeratorUser.fromMapSelectedTimes(Map<String, dynamic> map)
      : selectedEventTimes = map['selectedTimes'];
}

////////FOR INCOMING MEETINGS PAGE
/*  ModeratorUser.fromMapSelectedDatesFromUserDB(Map<String, dynamic> map)
      : eventDates = map['selectedDates'],
        eventName = map['eventName'],
        selectedEventDates = map['selectedDates'];
  ModeratorUser.fromMapSelectedTimesFromUserDB(Map<String, dynamic> map)
      : eventName = map['eventName'],
        eventTimes = map['eventTimes'],
        selectedEventTimes = map['selectedTimes'],
        uniqueDate = map['uniqueDate']; */
