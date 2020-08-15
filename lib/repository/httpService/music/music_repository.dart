import 'dart:convert';

import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/response_model.dart';
import 'package:jukebox_application/repository/model/server_data/timestamp_model.dart';
import 'package:jukebox_application/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:jukebox_application/utils/server_location_utils.dart';
import 'package:web_socket_channel/io.dart';

class MusicRepository {
  final String WEB_SOCKET_CONNECTION =
      ServerLocationsUtils.BASE_WEB_SOCKET + "/ws/music";
  final String GET_CURRENT_SONG =
      ServerLocationsUtils.BASE_HTTP + "/api/music/getDetails";
  final String GET_TIMESTAMP =
      ServerLocationsUtils.BASE_HTTP + "/api/getServerTime";

  static final MusicRepository _instance = MusicRepository._internal();

  factory MusicRepository() {
    return _instance;
  }

  MusicRepository._internal();

  IOWebSocketChannel getWebSocket() {
    return IOWebSocketChannel.connect(WEB_SOCKET_CONNECTION);
  }

  void getCurrentSong(
      Function(ResponseModel<CurrentSongDescriptionModel>)
          responseListener) async {
    ResponseModel<CurrentSongDescriptionModel> responseModel =
        ResponseModel<CurrentSongDescriptionModel>();

    var response = await http.get(GET_CURRENT_SONG);

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response =
            CurrentSongDescriptionModel.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }

  void getServerTime(
      Function(ResponseModel<TimestampModel>) responseListener) async {
    ResponseModel<TimestampModel> responseModel =
        ResponseModel<TimestampModel>();

    var response = await http.get(GET_TIMESTAMP);

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response =
            TimestampModel.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }
}
