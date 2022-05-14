class TimeSlot{
  String timeslot;
  String availibility;

  TimeSlot();

  TimeSlot.fromJson(Map<String, dynamic> json) {
    try {
      timeslot = json['timeslot'] != null ? json['timeslot'] : '';
      availibility = json['availibility'] != null ? json['availibility'] : '';
    } catch (e) {
      print("Exception - timeSlotModel.dart - TimeSlot.fromJson():" + e.toString());
    }
  }
}