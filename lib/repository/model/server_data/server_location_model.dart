class ServerLocationModel {
  String location;

  ServerLocationModel.fromJson(Map<String, dynamic> json)
      : location = json['location'];
}