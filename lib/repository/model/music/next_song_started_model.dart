import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/music/song_pick_model.dart';

class NextSongStartedModel {

  CurrentSongDescriptionModel nextSong;
  SongPickModels votingList;

  NextSongStartedModel.fromJson(Map<String, dynamic> json)
      : nextSong = json['nextSong'] != null
            ? CurrentSongDescriptionModel.fromJson(json['nextSong'])
            : null,
        votingList = json['votingList'] != null
            ? SongPickModels.fromJson(json['votingList'])
            : null;
}
