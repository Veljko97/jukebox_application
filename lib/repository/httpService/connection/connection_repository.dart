
import 'dart:convert';

import 'package:jukebox_application/repository/model/response_model.dart';
import 'package:jukebox_application/repository/model/server_data/server_location_model.dart';
import 'package:jukebox_application/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConnectionRepository {
  final String GET_SERVER_LOCATION = Constants.FIREBASE_GET_SERVER_EP;

  static final ConnectionRepository _instance = ConnectionRepository._internal();

  factory ConnectionRepository() {
    return _instance;
  }

  ConnectionRepository._internal();


  void getServerLocations(String serverCode, Function(ResponseModel<ServerLocationModel>) responseListener) async {
    ResponseModel<ServerLocationModel> responseModel = ResponseModel<ServerLocationModel>();

    var response = await http.get(
        GET_SERVER_LOCATION + "?localKey=$serverCode"
    );

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response = ServerLocationModel.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }
}