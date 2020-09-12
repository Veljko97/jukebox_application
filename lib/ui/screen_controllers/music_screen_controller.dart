import 'dart:io';

import 'package:jukebox_application/repository/httpService/music/music_repository.dart';
import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/music/song_item_model.dart';
import 'package:jukebox_application/repository/model/music/song_pick_model.dart';
import 'package:jukebox_application/repository/model/response_model.dart';
import 'package:jukebox_application/repository/model/server_data/timestamp_model.dart';
import 'package:web_socket_channel/io.dart';

class MusicScreenController {
  static final MusicScreenController _instance =
      MusicScreenController._internal();

  factory MusicScreenController() {
    return _instance;
  }

  MusicScreenController._internal();

  void getCurrentSong(
      Function(ResponseModel<CurrentSongDescriptionModel>) responseListener) {
    MusicRepository().getCurrentSong(responseListener);
  }

  void getServerTime(Function(ResponseModel<TimestampModel>) responseListener) {
    MusicRepository().getServerTime(responseListener);
  }

  void voteOnSong(int songId, Function(ResponseModel) responseListener) async {
    MusicRepository().voteOnSong(songId, responseListener);
  }

  void getVotingSongList(
      Function(ResponseModel<SongPickModels>) responseListener) {
    MusicRepository().getVotingSongList(responseListener);
  }

  void getTempSongs(Function(ResponseModel<SongItemsModel>) responseListener) {
    MusicRepository().getTempSongs(responseListener);
  }

  void getAllSongs(Function(ResponseModel<SongItemsModel>) responseListener) {
    MusicRepository().getAllSongs(responseListener);
  }

  void postUserSong(File songFile,
      Function(ResponseModel) responseListener) {
    MusicRepository().postUserSong(songFile, responseListener);
  }

  IOWebSocketChannel getWebSocket() {
    return MusicRepository().getWebSocket();
  }
}
