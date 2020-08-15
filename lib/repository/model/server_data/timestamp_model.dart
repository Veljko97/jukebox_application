
class TimestampModel {
  int timestamp;

  TimestampModel.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'];
}