import 'dart:convert';
import 'dart:io';

import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/music/song_item_model.dart';
import 'package:jukebox_application/repository/model/music/song_pick_model.dart';
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
      ServerLocationsUtils.BASE_HTTP + "/api/music/getCurrentSong";
  final String GET_CURRENT_PLAYLIST =
      ServerLocationsUtils.BASE_HTTP + "/api/music/getCurrentSongList";
  final String GET_TIMESTAMP =
      ServerLocationsUtils.BASE_HTTP + "/api/getServerTime";
  final String VOTE_ON_SONG =
      ServerLocationsUtils.BASE_HTTP + "/api/music/voteOnSong/";
  final String GET_VOTING_SONG_LIST =
      ServerLocationsUtils.BASE_HTTP + "/api/music/getSongList";
  final String GET_TEMP_SONG =
      ServerLocationsUtils.BASE_HTTP + "/api/music/getTempSongs";
  final String GET_ALL_SONGS =
      ServerLocationsUtils.BASE_HTTP + "/api/music/getAllSongs";
  final String POST_USER_SONG =
      ServerLocationsUtils.BASE_HTTP + "/api/music/addUserSong";

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

  void voteOnSong( int songId,
      Function(ResponseModel) responseListener) async {
    ResponseModel responseModel =
    ResponseModel();

    var response = await http.put("$VOTE_ON_SONG$songId",body: "");

    if (response.statusCode != 200) {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }

  void getVotingSongList(
      Function(ResponseModel<SongPickModels>)
      responseListener) async {
    ResponseModel<SongPickModels> responseModel =
    ResponseModel<SongPickModels>();

    var response = await http.get(GET_VOTING_SONG_LIST);

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response =
            SongPickModels.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }

  void getTempSongs(
      Function(ResponseModel<SongItemsModel>)
      responseListener) async {
    ResponseModel<SongItemsModel> responseModel =
    ResponseModel<SongItemsModel>();

    var response = await http.get(GET_TEMP_SONG);

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response =
            SongItemsModel.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }

  void getAllSongs(
      Function(ResponseModel<SongItemsModel>)
      responseListener) async {
    ResponseModel<SongItemsModel> responseModel =
    ResponseModel<SongItemsModel>();

    var response = await http.get(GET_ALL_SONGS);

    if (response.statusCode == 200) {
      if (response.body != null) {
        responseModel.response =
            SongItemsModel.fromJson(jsonDecode(response.body));
      } else {
        responseModel.error = "${response.statusCode} but empty";
      }
    } else {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }


  void postUserSong(File songFile,
      Function(ResponseModel) responseListener) async {
    ResponseModel responseModel = ResponseModel();

    var uri = Uri.parse(POST_USER_SONG);
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath("song", songFile.path));

    var response = await request.send();

    if (response.statusCode != 200) {
      responseModel.error = "${response.statusCode}";
    }

    responseListener(responseModel);
  }
}
