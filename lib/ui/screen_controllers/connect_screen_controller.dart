
import 'package:jukebox_application/repository/httpService/connection/connection_repository.dart';
import 'package:jukebox_application/repository/httpService/music/music_repository.dart';
import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/response_model.dart';
import 'package:jukebox_application/repository/model/server_data/server_location_model.dart';
import 'package:jukebox_application/repository/model/server_data/timestamp_model.dart';
import 'package:web_socket_channel/io.dart';

class ConnectScreenController {

  static final ConnectScreenController _instance = ConnectScreenController._internal();

  factory ConnectScreenController() {
    return _instance;
  }

  ConnectScreenController._internal();

  void getServerLocations(String serverCode, Function(ResponseModel<ServerLocationModel>) responseListener) {
    ConnectionRepository().getServerLocations(serverCode, responseListener);
  }

}