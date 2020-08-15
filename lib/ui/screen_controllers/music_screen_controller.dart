
import 'package:jukebox_application/repository/httpService/music/music_repository.dart';
import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/response_model.dart';
import 'package:jukebox_application/repository/model/server_data/timestamp_model.dart';
import 'package:web_socket_channel/io.dart';

class MusicScreenController {

  static final MusicScreenController _instance = MusicScreenController._internal();

  factory MusicScreenController() {
    return _instance;
  }

  MusicScreenController._internal();

  void getCurrentSong(
      Function(ResponseModel<CurrentSongDescriptionModel>) responseListener){
    MusicRepository().getCurrentSong(responseListener);
  }

  void getServerTime(
      Function(ResponseModel<TimestampModel>) responseListener) {
    MusicRepository().getServerTime(responseListener);
  }

  IOWebSocketChannel getWebSocket(){
    return MusicRepository().getWebSocket();
  }

}