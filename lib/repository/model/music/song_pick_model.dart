class SongPickModels {

    List<SongPickModel> songList;

    SongPickModels.fromJson(List<dynamic> json)
    : songList = json.map((e) => SongPickModel.fromJson(e)).toList();

}

class SongPickModel {
  int songId;
  String songName;
  int songVotes;

  SongPickModel.fromJson(Map<String, dynamic> json)
      : songId = json['songId'],
        songName = json['songName'],
        songVotes = json['songVotes'];
}
